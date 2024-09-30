import 'dart:math';

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

  Future<void> createTicket(
      {required String userId,
      required String fromStation,
      required String toStation,
      required String routeName,
      required int fare,
      required int timeToNext,
      required String ticketId // Pass the time to the next station in minutes
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
        'ticketId': ticketId,
        'status': 'active',
      });

      print('ticket added');
    } catch (e) {
      throw Exception("Error creating ticket: $e");
    }
  }

  String generateTicketId(String metroRoute) {
    // Define the prefix based on the metro route
    String prefix = '';
    switch (metroRoute) {
      case 'Green-Line':
        prefix = 'G'; // Green Line starts with G
        break;
      case 'Red-Line':
        prefix = 'R'; // Red Line starts with R
        break;
      case 'Orange-Line':
        prefix = 'O'; // Orange Line starts with O
        break;
      case 'Blue-Line':
        prefix = 'B'; // Blue Line starts with B
        break;
      default:
        throw Exception("Invalid metro route provided.");
    }

    // Characters to include in the random part of the ticket ID
    const String chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

    // Generate the random part (5 characters)
    Random random = Random();
    String randomPart =
        List.generate(5, (index) => chars[random.nextInt(chars.length)]).join();

    // Return the final ticket ID (1 character prefix + 5 characters random part)
    return prefix + randomPart;
  }
}
