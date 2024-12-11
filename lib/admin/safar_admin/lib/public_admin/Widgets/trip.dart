import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class TripScreen extends StatelessWidget {
  const TripScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchTickets() async {
    try {
      final ticketSnapshot = await FirebaseFirestore.instance
          .collection('tickets')
          .orderBy('purchaseTime', descending: true)
          .get();

      final userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();

      final userMap = {
        for (var user in userSnapshot.docs) user.id: user.data()
      };

      final tickets = ticketSnapshot.docs.map((doc) {
        final ticketData = doc.data();
        final userId = ticketData['userId'];
        final user = userMap[userId];

        return {
          ...ticketData,
          'id': doc.id,
          'fullName': user?['fullName'] ?? 'Unknown',
        };
      }).toList();

      return tickets;
    } catch (e) {
      print("Error fetching tickets: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Trips",
          style: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTickets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text("No trips available or an error occurred."),
            );
          }

          final tickets = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final fromStation = ticket['fromStation'] ?? 'Unknown';
              final toStation = ticket['toStation'] ?? 'Unknown';
              final passenger = ticket['fullName'] ?? 'Unknown';
              final fare = ticket['fare']?.toString() ?? '0';
              final purchaseTime = ticket['purchaseTime'] != null
                  ? DateFormat.yMMMMd()
                      .format((ticket['purchaseTime'] as Timestamp).toDate())
                  : 'Unknown Date';

              return Card(
                color: const Color(0xFF042F40),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.green),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Source",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        fromStation,
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.red),
                                  const SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Destination",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      Text(
                                        toStation,
                                        style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Passenger",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 14),
                              ),
                              Text(
                                passenger,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Date",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 14),
                              ),
                              Text(
                                purchaseTime,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Fare",
                                style: TextStyle(
                                    color: Colors.white54, fontSize: 14),
                              ),
                              Text(
                                fare,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
