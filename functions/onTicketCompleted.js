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
