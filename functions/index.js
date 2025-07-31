const functions = require("firebase-functions");
const axios = require("axios");

const razorpayKey = "rzp_test_NLWYHWhXd7xZAp"; // Your Razorpay key ID
const razorpaySecret = "PJUeJ0MLOv4PfIzogDqtDEtK"; // Your Razorpay secret key

exports.createOrder = functions.region("asia-south1").https.onCall(async (data, context) => {
  try {
    const { amount, currency, receipt } = data;

    if (!context.auth) {
      throw new functions.https.HttpsError("unauthenticated", "User must be authenticated.");
    }

    const response = await axios.post(
      "https://api.razorpay.com/v1/orders",
      {
        amount: amount * 100, // Amount in paise
        currency: currency || "INR",
        receipt: receipt || `receipt_${Date.now()}`,
      },
      {
        auth: {
          username: razorpayKey,
          password: razorpaySecret,
        },
        headers: {
          "Content-Type": "application/json",
        },
      }
    );

    return {
      status: "success",
      orderId: response.data.id,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      `Error creating order: ${error.message}`
    );
  }
});

