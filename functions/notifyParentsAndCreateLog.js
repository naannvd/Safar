const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.notifyParentsAndLog = functions.firestore
    .document("rides/{rideId}")
    .onCreate(async (snapshot, context) => {
        const rideData = snapshot.data();

        try {
            // Notification payload
            const payload = {
                notification: {
                    title: "New Ride for Today",
                    body: `A new ride (${rideData.ride_id}) has been scheduled.`,
                },
                data: {
                    ride_id: rideData.ride_id,
                    driver_id: rideData.driver_id,
                    start_time: rideData.start_time.toDate().toISOString(),
                },
            };

            const response = await admin.messaging().send("parents", payload);
            console.log("Notifications sent to topic 'parents':", response);

            await admin.firestore().collection("notification_log").add({
                ride_id: rideData.ride_id,
                driver_name: rideData.driver_name,
                driver_id: rideData.driver_id,
                notification_title: "New Ride Scheduled",
                notification_body: `A new ride (${rideData.route_name}) has been scheduled.`,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });

            console.log("Notification logged successfully.");
        } catch (error) {
            console.error("Error sending notifications or logging:", error);
        }

        return null;
    });
