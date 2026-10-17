import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:yeetfit/core/constants/function_regions.dart';
import '../../domain/entities/client_profile.dart';
import '../../domain/repositories/coach_repository.dart';
import '../models/coach_model.dart';

class CoachDataSource {
  static const _removeCoachFunction = 'removeCoach';

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _functions;

  CoachDataSource({FirebaseFirestore? firestore, FirebaseFunctions? functions})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _functions =
          functions ??
          FirebaseFunctions.instanceFor(region: FunctionRegions.coaching);

  CollectionReference<Map<String, dynamic>> get _coaches =>
      _firestore.collection('coaches');

  CollectionReference<Map<String, dynamic>> get _relationships =>
      _firestore.collection('training_relationships');

  /// Live list of active coaches with a complete profile. Sorted
  /// client-side: ordering by name in the query would need a composite
  /// index alongside the `isActive` filter.
  Stream<List<CoachModel>> watchActiveCoaches() {
    return _coaches
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) =>
              [
                for (final doc in snapshot.docs)
                  if (_isComplete(doc)) CoachModel.fromFirestore(doc),
              ]..sort(
                (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
              ),
        );
  }

  /// `null` when the coach's profile no longer exists or is incomplete.
  Future<CoachModel?> getCoach(String coachId) async {
    final ref = _coaches.doc(coachId);
    DocumentSnapshot<Map<String, dynamic>> doc;
    try {
      doc = await ref.get(const GetOptions(source: Source.server));
    } on FirebaseException catch (e) {
      if (e.code != 'unavailable') rethrow;
      doc = await ref.get(const GetOptions(source: Source.cache));
    }
    return _isComplete(doc) ? CoachModel.fromFirestore(doc) : null;
  }

  /// Skips leftover or half-written profiles: YeetCoach always writes a
  /// `uid` matching the doc ID and a name.
  static bool _isComplete(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final name = data?['name'];
    return name is String && name.trim().isNotEmpty && data?['uid'] == doc.id;
  }

  /// Live `clients/{uid}` profile, including the coach-assigned training days.
  Stream<ClientProfile> watchClientProfile(String clientUid) {
    return _firestore.collection('clients').doc(clientUid).snapshots().map((
      doc,
    ) {
      return ClientProfile.fromMap(doc.data() ?? const {});
    });
  }

  Stream<String?> watchCurrentCoachId(String clientUid) {
    return watchClientProfile(
      clientUid,
    ).map((profile) => profile.currentCoachId);
  }

  /// Local writes show up in the snapshot straight away, so the button flips
  /// to "Request Pending" before the server acknowledges the request.
  Stream<bool> watchHasPendingRequest({
    required String clientUid,
    required String coachId,
  }) {
    return _relationships
        .where('clientUid', isEqualTo: clientUid)
        .where('coachId', isEqualTo: coachId)
        .where('status', isEqualTo: 'pending')
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  // The rules deny reading a relationship doc that doesn't exist yet, so
  // existence is checked with a query filtered on the client's own uid.
  // An existing doc can't be overwritten (the update rule only allows
  // status changes), so a declined or ended request is re-opened instead.
  Future<void> requestCoach({
    required String clientUid,
    required String coachId,
  }) async {
    final docId = '${clientUid}_$coachId';
    final existing = await _relationships
        .where('clientUid', isEqualTo: clientUid)
        .where('coachId', isEqualTo: coachId)
        .get();
    final current = existing.docs.where((doc) => doc.id == docId).firstOrNull;

    if (current == null) {
      await _relationships.doc(docId).set({
        'coachId': coachId,
        'clientUid': clientUid,
        'status': 'pending',
        'requestedAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    switch (current.data()['status']) {
      case 'pending':
        return;
      case 'active':
        throw const CoachRequestException('This coach is already yours');
      default:
        await current.reference.update({
          'status': 'pending',
          'updatedAt': FieldValue.serverTimestamp(),
        });
    }
  }

  /// Clears the client's coach and ends the relationship server-side; the
  /// rules don't let clients change `currentCoachId` themselves.
  Future<void> removeCoach() async {
    try {
      await _functions.httpsCallable(_removeCoachFunction).call<Object?>();
    } on FirebaseFunctionsException catch (e) {
      debugPrint('removeCoach failed: ${e.code} — ${e.message}');
      throw CoachRemovalException(
        e.message?.trim().isNotEmpty == true
            ? e.message!
            : 'Could not remove your coach. Please try again.',
      );
    }
  }
}
