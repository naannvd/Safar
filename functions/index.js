/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const functions = require("firebase-functions");
// const stripe = require('stripe')('your_stripe_secret_key'); // Replace with your Stripe secret key

// const functions = require('firebase-functions');
const admin = require("firebase-admin");
const { topic } = require("firebase-functions/v1/pubsub");

admin.initializeApp();

// Cloud Firestore triggers ref: https://firebase.google.com/docs/functions/firestore-events
exports.notifyParentsAndLog = functions.firestore
  .document("rides/{rideId}")
  .onCreate(async (snapshot, context) => {
    const rideData = snapshot.data();

    if (!rideData) {
      console.error("No ride data found!");
      return null;
    }

    try {
      // Notification Payload
      const payload = {
        notification: {
          title: "New Ride Scheduled",
          body: `A new ride (${rideData.ride_id}) has been scheduled.`,
        },
        data: {
          ride_id: rideData.ride_id,
          driver_id: rideData.driver_id,
          start_time: rideData.start_time?.toDate()?.toISOString() || "",
          click_action: 'FLUTTER_NOTIFICATION_CLICK',

        },
        topic: "parents",
      };

      console.log("Sending notification with payload: ", payload);

      // Send Notification
      const response = await admin.messaging().send(payload);
      console.log("Notification sent: ", response);

      // Log Notification in Firestore
      await admin.firestore().collection("notification_log").add({
        ride_id: rideData.ride_id,
        driver_id: rideData.driver_id,
        driver_name: rideData.driver_name || "Unknown",
        notification_title: "New Ride Scheduled",
        notification_body: `A new ride (${rideData.ride_id}) has been scheduled.`,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log("Notification logged in Firestore.");
    } catch (error) {
      console.error("Error in notifyParentsAndLog function: ", error);
    }

    return null;
  });
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
