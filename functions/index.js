const { onCall, HttpsError } = require("firebase-functions/v2/https");
const {
  onDocumentCreated,
  onDocumentUpdated,
  onDocumentWritten,
} = require("firebase-functions/v2/firestore");
const { defineSecret } = require("firebase-functions/params");
const logger = require("firebase-functions/logger");
const { initializeApp } = require("firebase-admin/app");
const { getAuth } = require("firebase-admin/auth");
const { getFirestore, FieldValue } = require("firebase-admin/firestore");
const { getStorage } = require("firebase-admin/storage");
const { getMessaging } = require("firebase-admin/messaging");
const { GoogleGenerativeAI } = require("@google/generative-ai");
const axios = require("axios");

initializeApp();

const geminiKey = defineSecret("GEMINI_API_KEY");
const edamamAppId = defineSecret("EDAMAM_APP_ID");
const edamamAppKey = defineSecret("EDAMAM_APP_KEY");
const meteredApiKey = defineSecret("METERED_API_KEY");

const DEFAULT_REGION = "us-central1";
const FIRESTORE_REGION = "asia-south1";

const CALL_RING_SECONDS = 30;

const GEMINI_MODEL = "gemini-3.1-flash-lite";
const MAX_FOOD_RESULTS = 20;

const SESSIONS_TOPIC = "sessions";
const ANDROID_NOTIFICATION_CHANNEL = "yeetfit_channel";
// Must match PushNotificationService.channelId in YeetCoach.
const COACH_NOTIFICATION_CHANNEL = "yeetcoach_default";
const MESSAGE_PREVIEW_LENGTH = 100;

const YANA_SYSTEM_INSTRUCTION =
  "You are Yana, a friendly and knowledgeable AI fitness coach " +
  "built into the Yeetfit app. You help users with workout advice, " +
  "nutrition guidance, recovery tips, and motivation. Always respond " +
  "as Yana. Keep responses concise and encouraging.\n\n" +
  "IMPORTANT FORMATTING RULES:\n" +
  "- Never use markdown formatting. No asterisks, no bold (**text**), no " +
  "italics (*text*), no headers (#), no bullet dashes (-), no numbered " +
  "lists with dots.\n" +
  "- Write in plain conversational sentences and short paragraphs only.\n" +
  "- Use line breaks between thoughts instead of bullet points.\n" +
  "- Sound warm, encouraging and human — like a knowledgeable friend, not " +
  "a report.\n" +
  "- Keep responses concise. Avoid long walls of text.\n" +
  "- If listing items, write them naturally: 'First, do X. Then try Y. " +
  "Finally, Z.' — not as a formatted list.";

function requireAuth(request) {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "User must be authenticated.");
  }
  return request.auth.uid;
}

async function requireAdmin(request) {
  const uid = requireAuth(request);
  const profile = await getFirestore().collection("users").doc(uid).get();
  if (profile.data()?.role !== "admin") {
    throw new HttpsError("permission-denied", "Only coaches can do this.");
  }
  return uid;
}

function describeAxiosError(error) {
  const status = error.response?.status;
  const body = error.response?.data;
  return status ? `HTTP ${status}: ${JSON.stringify(body)}` : error.message;
}

exports.searchFood = onCall(
  { region: DEFAULT_REGION, secrets: [edamamAppId, edamamAppKey] },
  async (request) => {
    requireAuth(request);
    const query = typeof request.data?.query === "string" ? request.data.query.trim() : "";
    if (query.length === 0) return { hints: [] };
    try {
      const response = await axios.get(
        "https://api.edamam.com/api/food-database/v2/parser",
        {
          params: {
            app_id: edamamAppId.value(),
            app_key: edamamAppKey.value(),
            ingr: query,
          },
        }
      );
      const hints = Array.isArray(response.data?.hints) ? response.data.hints : [];
      return {
        hints: hints.slice(0, MAX_FOOD_RESULTS).map((hint) => ({
          food: {
            foodId: hint.food?.foodId,
            label: hint.food?.label,
            image: hint.food?.image ?? null,
            nutrients: hint.food?.nutrients ?? {},
          },
        })),
      };
    } catch (error) {
      const detail = describeAxiosError(error);
      logger.error("Edamam search failed", { detail });
      throw new HttpsError("internal", `Food search failed: ${detail}`);
    }
  }
);

exports.callGemini = onCall(
  { region: DEFAULT_REGION, secrets: [geminiKey] },
  async (request) => {
    requireAuth(request);
    const { prompt, imageBase64, mimeType, mode } = request.data || {};
    if (typeof prompt !== "string" || prompt.trim().length === 0) {
      throw new HttpsError("invalid-argument", "A non-empty prompt is required.");
    }
    try {
      const genAI = new GoogleGenerativeAI(geminiKey.value());
      const model = genAI.getGenerativeModel({
        model: GEMINI_MODEL,
        ...(mode === "coach" ? { systemInstruction: YANA_SYSTEM_INSTRUCTION } : {}),
      });
      const parts = [{ text: prompt }];
      if (imageBase64 && mimeType) {
        parts.push({ inlineData: { data: imageBase64, mimeType } });
      }
      const result = await model.generateContent(parts);
      return { text: result.response.text() };
    } catch (error) {
      logger.error("Gemini request failed", { model: GEMINI_MODEL, message: error.message });
      throw new HttpsError("internal", `Gemini request failed: ${error.message}`);
    }
  }
);

exports.getCallConfig = onCall(
  { region: DEFAULT_REGION, secrets: [meteredApiKey] },
  async (request) => {
    requireAuth(request);
    return { apiKey: meteredApiKey.value() };
  }
);

exports.notifyNewSession = onCall({ region: DEFAULT_REGION }, async (request) => {
  await requireAdmin(request);
  const sessionId = request.data?.sessionId;
  if (typeof sessionId !== "string" || sessionId.length === 0) {
    throw new HttpsError("invalid-argument", "A sessionId is required.");
  }
  const session = await getFirestore().collection("sessions").doc(sessionId).get();
  if (!session.exists) {
    throw new HttpsError("not-found", "Session not found.");
  }
  const sessionData = session.data();
  const { title, trainerName } = sessionData;
  const message = {
    notification: {
      title: "New live session ",
      body: `${trainerName ?? "Your coach"} scheduled "${title}". Open Explore to see when.`,
    },
    data: { type: "new_session", sessionId },
    android: { notification: { channelId: ANDROID_NOTIFICATION_CHANNEL } },
  };
  try {
    if (sessionData.isGlobal === true) {
      await getMessaging().send({
        topic: SESSIONS_TOPIC,
        ...message,
      });
    } else if (sessionData.isGlobal === false) {
      const assignedClientUids = sessionData.assignedClientUids;
      if (!Array.isArray(assignedClientUids) || assignedClientUids.length === 0) {
        logger.warn("notifyNewSession skipped: assignedClientUids is missing or empty", {
          sessionId,
        });
        return { success: true };
      }
      const tokens = [];
      for (const uid of assignedClientUids) {
        if (typeof uid !== "string" || uid.length === 0) continue;
        const userDoc = await getFirestore().collection("users").doc(uid).get();
        const fcmToken = userDoc.data()?.fcmToken;
        if (typeof fcmToken === "string" && fcmToken.length > 0) tokens.push(fcmToken);
      }
      await Promise.all(
        tokens.map((token) => getMessaging().send({ token, ...message })),
      );
    }
  } catch (error) {
    logger.error("Session notification failed", { sessionId, message: error.message });
    throw new HttpsError("internal", "Could not send the session notification.");
  }
  return { success: true };
});

exports.onCallCreated = onDocumentCreated(
  { document: "calls/{callId}", region: FIRESTORE_REGION },
  async (event) => {
    const call = event.data?.data();
    const callId = event.params.callId;
    if (!call || call.status !== "ringing") return;
    const db = getFirestore();
    // Clients keep their token on users/{uid}, coaches on coaches/{uid}.
    let receiverRef = db.collection("users").doc(call.receiverId);
    let fcmToken = (await receiverRef.get()).data()?.fcmToken;
    let channelId = ANDROID_NOTIFICATION_CHANNEL;
    if (!fcmToken) {
      receiverRef = db.collection("coaches").doc(call.receiverId);
      fcmToken = (await receiverRef.get()).data()?.fcmToken;
      channelId = COACH_NOTIFICATION_CHANNEL;
    }
    if (!fcmToken) return;
    const callTypeLabel = call.type === "video" ? "video call" : "audio call";
    try {
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: `Incoming ${callTypeLabel}`,
          body: `${call.callerName ?? "Someone"} is calling you`,
        },
        data: {
          type: "incoming_call",
          callId,
          callerId: call.callerId ?? "",
          callerName: call.callerName ?? "",
          callerPhotoUrl: call.callerPhoto ?? "",
          callType: call.type ?? "audio",
        },
        android: {
          priority: "high",
          ttl: CALL_RING_SECONDS * 1000,
          notification: {
            channelId,
            priority: "max",
            defaultVibrateTimings: true,
            defaultSound: true,
            tag: `call_${callId}`,
          },
        },
        apns: {
          payload: { aps: { sound: "default", contentAvailable: true } },
          headers: {
            "apns-priority": "10",
            "apns-push-type": "alert",
            "apns-expiration": String(Math.floor(Date.now() / 1000) + CALL_RING_SECONDS),
          },
        },
      });
    } catch (error) {
      if (error.code === "messaging/registration-token-not-registered") {
        await receiverRef.update({ fcmToken: FieldValue.delete() });
        return;
      }
      logger.error("Incoming call push failed", { callId, message: error.message });
    }
  }
);

function messagePreview(text) {
  const trimmed = typeof text === "string" ? text.trim() : "";
  return trimmed.length > MESSAGE_PREVIEW_LENGTH
    ? `${trimmed.slice(0, MESSAGE_PREVIEW_LENGTH - 1)}…`
    : trimmed;
}

exports.onMessageCreated = onDocumentCreated(
  { document: "chats/{chatId}/messages/{messageId}", region: FIRESTORE_REGION },
  async (event) => {
    const message = event.data?.data();
    const { chatId, messageId } = event.params;
    const senderId = message?.senderId;
    if (!senderId) return;

    const db = getFirestore();
    const chat = (await db.collection("chats").doc(chatId).get()).data();
    const participants = Array.isArray(chat?.participants) ? chat.participants : [];
    const recipientId = participants.find((uid) => uid !== senderId);
    if (!participants.includes(senderId) || !recipientId) return;

    // Coach → client token on users/{uid}; client → coach token on coaches/{uid}.
    const senderCoachDoc = await db.collection("coaches").doc(senderId).get();
    const senderIsCoach = senderCoachDoc.exists;
    const senderDoc = senderIsCoach
      ? senderCoachDoc
      : await db.collection("users").doc(senderId).get();
    const recipientRef = db.collection(senderIsCoach ? "users" : "coaches").doc(recipientId);
    const fcmToken = (await recipientRef.get()).data()?.fcmToken;
    if (!fcmToken) return;

    // YeetFit writes the body to `content`, YeetCoach to both.
    const body = messagePreview(message.text ?? message.content);
    try {
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: senderDoc.data()?.name || (senderIsCoach ? "Your coach" : "Your client"),
          body: body || "Sent you a message",
        },
        data: {
          // YeetFit routes chat pushes and applies the client's "coach messages"
          // setting by "chat_message"; YeetCoach handles "new_message".
          type: senderIsCoach ? "chat_message" : "new_message",
          chatId,
          senderId,
        },
        android: {
          priority: "high",
          notification: {
            channelId: senderIsCoach ? ANDROID_NOTIFICATION_CHANNEL : COACH_NOTIFICATION_CHANNEL,
            tag: `chat_${chatId}`,
          },
        },
        apns: { payload: { aps: { sound: "default" } } },
      });
    } catch (error) {
      if (error.code === "messaging/registration-token-not-registered") {
        await recipientRef.update({ fcmToken: FieldValue.delete() });
        return;
      }
      logger.error("New message push failed", { chatId, messageId, message: error.message });
    }
  }
);

// Firestore caps a write batch at 500 operations.
const DELETE_BATCH_SIZE = 500;

async function deleteDocIfExists(ref) {
  if (!(await ref.get()).exists) return;
  await ref.delete();
  logger.info("Deleted document", { path: ref.path });
}

// Queries may overlap, so matches are de-duplicated by path before deleting.
async function deleteQueryMatches(queries) {
  const snapshots = await Promise.all(queries.map((query) => query.get()));
  const refs = new Map();
  snapshots.forEach((snapshot) =>
    snapshot.docs.forEach((doc) => refs.set(doc.ref.path, doc.ref))
  );
  await Promise.all(
    [...refs.values()].map(async (ref) => {
      await ref.delete();
      logger.info("Deleted document", { path: ref.path });
    })
  );
}

async function deleteChatWithMessages(chatRef) {
  const messages = chatRef.collection("messages");
  let deletedMessages = 0;
  for (;;) {
    const page = await messages.limit(DELETE_BATCH_SIZE).get();
    if (page.empty) break;
    const batch = getFirestore().batch();
    page.docs.forEach((message) => batch.delete(message.ref));
    await batch.commit();
    deletedMessages += page.size;
  }
  logger.info("Deleted chat messages", { path: chatRef.path, count: deletedMessages });
  await chatRef.delete();
  logger.info("Deleted document", { path: chatRef.path });
}

exports.deleteAccount = onCall(
  { region: DEFAULT_REGION, timeoutSeconds: 300 },
  async (request) => {
    const uid = requireAuth(request);
    const db = getFirestore();
    try {
      await db.recursiveDelete(db.collection("users").doc(uid));
      logger.info("Deleted user profile", { uid });
      const challenges = await db.collection("challenges").get();
      await Promise.all(
        challenges.docs.map((challenge) =>
          db.runTransaction(async (tx) => {
            const participant = challenge.ref.collection("participants").doc(uid);
            if (!(await tx.get(participant)).exists) return;
            tx.delete(participant);
            tx.update(challenge.ref, { participantCount: FieldValue.increment(-1) });
          })
        )
      );
      const relationships = db.collection("training_relationships");
      const calls = db.collection("calls");
      const chats = await db.collection("chats").where("participants", "array-contains", uid).get();
      // Subcollections are not deleted with their parent document.
      const clientNotesRef = db.collection("coaches").doc(uid).collection("client_notes");
      const clientNotesDocs = await clientNotesRef.listDocuments();
      for (let i = 0; i < clientNotesDocs.length; i += DELETE_BATCH_SIZE) {
        const notesBatch = db.batch();
        clientNotesDocs.slice(i, i + DELETE_BATCH_SIZE).forEach((doc) => notesBatch.delete(doc));
        await notesBatch.commit();
      }
      await Promise.all([
        deleteDocIfExists(db.collection("coaches").doc(uid)),
        deleteDocIfExists(db.collection("clients").doc(uid)),
        deleteQueryMatches([
          relationships.where("clientUid", "==", uid),
          relationships.where("coachId", "==", uid),
        ]),
        deleteQueryMatches([
          calls.where("callerId", "==", uid),
          calls.where("receiverId", "==", uid),
        ]),
        ...chats.docs.map((chat) => deleteChatWithMessages(chat.ref)),
      ]);
      const clientsWithCoach = await db
        .collection("clients")
        .where("currentCoachId", "==", uid)
        .get();
      if (!clientsWithCoach.empty) {
        const docs = clientsWithCoach.docs;
        for (let i = 0; i < docs.length; i += DELETE_BATCH_SIZE) {
          const batch = db.batch();
          docs.slice(i, i + DELETE_BATCH_SIZE).forEach((doc) =>
            batch.update(doc.ref, {
              currentCoachId: FieldValue.delete(),
              updatedAt: FieldValue.serverTimestamp(),
            })
          );
          await batch.commit();
        }
        logger.info("Cleared currentCoachId on orphaned clients", {
          uid,
          count: clientsWithCoach.size,
        });
      }
    } catch (error) {
      logger.error("Deleting user data failed", { uid, message: error.message });
      throw new HttpsError("internal", `Could not delete account data: ${error.message}`);
    }
    try {
      await getStorage().bucket().deleteFiles({ prefix: `users/${uid}/` });
    } catch (error) {
      logger.warn("Deleting user files failed", { uid, message: error.message });
    }
    try {
      await getStorage().bucket().deleteFiles({ prefix: `coach_profiles/${uid}/` });
      logger.info("Deleted coach profile files", { uid });
    } catch (error) {
      logger.warn("Deleting coach profile files failed", { uid, message: error.message });
    }
    try {
      await getAuth().deleteUser(uid);
    } catch (error) {
      if (error.code !== "auth/user-not-found") {
        logger.error("Deleting auth user failed", { uid, message: error.message });
        throw new HttpsError("internal", `Could not delete account: ${error.message}`);
      }
    }
    return { success: true };
  }
);

// A client ends their coaching relationship. Runs server-side because the
// client rules forbid clients from changing currentCoachId.
exports.removeCoach = onCall({ region: FIRESTORE_REGION }, async (request) => {
  const clientUid = requireAuth(request);
  const db = getFirestore();
  const clientRef = db.collection("clients").doc(clientUid);
  const coachId = (await clientRef.get()).data()?.currentCoachId;
  if (!coachId) {
    throw new HttpsError("failed-precondition", "No coach assigned");
  }

  const relationshipRef = db
    .collection("training_relationships")
    .doc(`${clientUid}_${coachId}`);
  const relationship = await relationshipRef.get();

  const batch = db.batch();
  batch.update(clientRef, {
    currentCoachId: FieldValue.delete(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  // update() on a missing doc would fail the whole batch and leave the coach
  // assigned, so a missing relationship is logged and skipped.
  if (relationship.exists) {
    batch.update(relationshipRef, {
      status: "ended",
      endedBy: "client",
      endedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  } else {
    logger.warn("removeCoach: relationship not found", { clientUid, coachId });
  }
  await batch.commit();
  logger.info("Coach removed", { clientUid, coachId });

  try {
    const [coach, client] = await Promise.all([
      db.collection("coaches").doc(coachId).get(),
      db.collection("users").doc(clientUid).get(),
    ]);
    const fcmToken = coach.data()?.fcmToken;
    if (fcmToken) {
      const clientName = client.data()?.name || "A client";
      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: "Client left",
          body: `${clientName} has removed you as their coach.`,
        },
        data: { type: "coach_removed", clientUid },
        android: {
          priority: "high",
          notification: { channelId: COACH_NOTIFICATION_CHANNEL },
        },
        apns: { payload: { aps: { sound: "default" } } },
      });
    }
  } catch (error) {
    logger.warn("removeCoach push failed", { clientUid, coachId, message: error.message });
  }

  return { success: true };
});

exports.onRelationshipEnded = onDocumentUpdated(
  { document: "training_relationships/{id}", region: FIRESTORE_REGION },
  async (event) => {
    const before = event.data.before.data();
    const after  = event.data.after.data();

    if (before.status === "ended" || after.status !== "ended" || after.endedBy !== "coach") {
      return null;
    }

    const clientUid = after.clientUid;
    if (!clientUid) return null;

    try {
      const clientUserDoc = await getFirestore().collection("users").doc(clientUid).get();
      const fcmToken = clientUserDoc.data()?.fcmToken;
      if (!fcmToken) return null;

      await getMessaging().send({
        token: fcmToken,
        notification: {
          title: "Training Update",
          body: "Your coach has ended your training relationship.",
        },
        data: { type: "relationship_ended" },
        apns: { payload: { aps: { sound: "default" } } },
        android: {
          priority: "high",
          notification: {
            channelId: ANDROID_NOTIFICATION_CHANNEL,
          },
        },
      });
    } catch (e) {
      logger.error("onRelationshipEnded FCM error:", e);
    }
    return null;
  }
);

exports.onChallengeAssigned = onDocumentWritten(
  { document: "challenges/{challengeId}", region: FIRESTORE_REGION },
  async (event) => {
    const before = event.data?.before?.data() ?? {};
    const after  = event.data?.after?.data();

    // Document deleted — nothing to do
    if (!after) return null;

    const beforeAssigned = before.assignedTo ?? [];
    const afterAssigned  = after.assignedTo  ?? [];

    // Find UIDs that were just added to assignedTo
    const newlyAssigned = afterAssigned.filter(uid => !beforeAssigned.includes(uid));
    if (newlyAssigned.length === 0) return null;

    const challengeTitle = after.title ?? "New Challenge";

    const db = getFirestore();
    const sends = newlyAssigned.map(async (uid) => {
      try {
        const userDoc = await db.collection("users").doc(uid).get();
        const fcmToken = userDoc.data()?.fcmToken;
        if (!fcmToken) return;

        await getMessaging().send({
          token: fcmToken,
          notification: {
            title: "New Challenge Assigned!",
            body: `Your coach assigned you: ${challengeTitle}`,
          },
          data: { type: "challenge_assigned", challengeId: event.params.challengeId },
          apns: { payload: { aps: { sound: "default" } } },
          android: {
            priority: "high",
            notification: { channelId: ANDROID_NOTIFICATION_CHANNEL },
          },
        });
      } catch (e) {
        logger.error(`onChallengeAssigned FCM error for uid ${uid}:`, e);
      }
    });

    await Promise.allSettled(sends);
    return null;
  }
);

// When a coach profile is created, elevate the user's role to admin.
// The client writes the coach document; this trigger handles the privileged part.
exports.onCoachCreated = onDocumentCreated(
  { document: "coaches/{uid}", region: FIRESTORE_REGION },
  async (event) => {
    const uid = event.params.uid;
    const db = getFirestore();
    try {
      await db.collection("users").doc(uid).set({ role: "admin" }, { merge: true });      logger.info("Coach role granted", { uid });
    } catch (error) {
      logger.error("onCoachCreated failed", { uid, message: error.message });
    }
  }
);

// Recomputes a coach's average whenever a client creates, edits, or deletes
// their rating. Admin SDK bypasses the rule that hides ratings from the coach.
exports.onRatingWritten = onDocumentWritten(
  {
    document: "coaches/{coachUid}/ratings/{clientUid}",
    region: FIRESTORE_REGION,
  },
  async (event) => {
    const coachUid = event.params.coachUid;
    const ratingsSnap = await getFirestore()
      .collection("coaches")
      .doc(coachUid)
      .collection("ratings")
      .get();

    const stars = ratingsSnap.docs
      .map((d) => d.data().stars)
      .filter((s) => typeof s === "number" && s >= 1 && s <= 5);

    const ratingCount = stars.length;
    const averageRating = ratingCount > 0
      ? Math.round((stars.reduce((a, b) => a + b, 0) / ratingCount) * 10) / 10
      : 0;

    await getFirestore().collection("coaches").doc(coachUid).update({
      averageRating,
      ratingCount,
    });
  }
);