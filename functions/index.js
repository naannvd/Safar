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
exports.onTicketCompleted = functions.firestore
  .document('tickets/{ticketId}')
  .onUpdate((change, context) => {
    const afterData = change.after.data();
    const beforeData = change.before.data();
    if (beforeData.status !== 'completed' && afterData.status === 'completed') {
      const userId = afterData.userId;
      const userLoyaltyRef = admin.firestore().collection('users').doc(userId).collection('loyalty').doc('rewards');
      
      return admin.firestore().runTransaction(async (t) => {
        const doc = await t.get(userLoyaltyRef);
        let { ticketsCompleted, completionGoal, discountAvailable } = doc.data();

        ticketsCompleted += 1;
        if (ticketsCompleted >= completionGoal) {
          discountAvailable = true;
          // Optionally reset ticketsCompleted or set a new completionGoal
          ticketsCompleted = 0; // reset after reward
        }

        t.update(userLoyaltyRef, { 
          ticketsCompleted, 
          discountAvailable 
        });
      });
    }
    return null;
  });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
