import 'package:cloud_firestore/cloud_firestore.dart';

class TicketSupport {
  Future<int> getFare(String lineName) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('routes')
          .doc(lineName)
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        // Return the fare from the document
        return snapshot['fare'] as int;
      } else {
        throw Exception("Fare not found for the selected line.");
      }
    } catch (e) {
      throw Exception("Error fetching fare: $e");
    }
  }

  Future<void> createTicket({
    required String userId,
    required String fromStation,
    required String toStation,
    required String routeName,
    required int fare,
    required int timeToNext, // Pass the time to the next station in minutes
  }) async {
    try {
      Timestamp purchaseTime = Timestamp.now();

      DateTime currentTime = DateTime.now();
      DateTime nextStationTime = currentTime.add(Duration(minutes: timeToNext));
      Timestamp timeToNextStation = Timestamp.fromDate(nextStationTime);

      // Map<String, dynamic> ticketData = {

      // };

      await FirebaseFirestore.instance.collection('tickets').add({
        'userId': userId,
        'fromStation': fromStation,
        'toStation': toStation,
        'routeName': routeName,
        'fare': fare,
        'purchaseTime': purchaseTime,
        'timeToNextStation': timeToNextStation,
      });

      print('ticket added');
    } catch (e) {
      throw Exception("Error creating ticket: $e");
    }
  }
}
