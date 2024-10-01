import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ticket_builder.dart'; // Make sure to import your TicketBuilder widget

class TicketList extends StatefulWidget {
  const TicketList({super.key});

  @override
  State<TicketList> createState() => _TicketListState();
}

class _TicketListState extends State<TicketList> {
  Stream<List<Map<String, dynamic>>> fetchCompletedTickets(
      BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    return FirebaseFirestore.instance
        .collection('tickets')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'completed')
        .orderBy('purchaseTime', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'toStation': data['toStation'],
          'fromStation': data['fromStation'],
          'purchaseTime': data['purchaseTime'],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: fetchCompletedTickets(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recent trips.'));
        }

        final List<Map<String, dynamic>> completedTickets = snapshot.data!;

        return ListView.builder(
          itemCount: completedTickets.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final ticket = completedTickets[index];
            final toStation = ticket['toStation'] ?? 'Unknown';
            final fromStation = ticket['fromStation'] ?? 'Unknown';
            final purchaseTime = ticket['purchaseTime'] as Timestamp;

            final DateTime purchaseDate = purchaseTime.toDate();
            final String month = DateFormat.MMMM().format(purchaseDate);
            final String day = DateFormat.d().format(purchaseDate);
            final isReversed = index % 2 == 1;

            return TicketBuilder(
              month: month,
              day: day,
              fromStation: fromStation,
              toStation: toStation,
              isReversed: isReversed,
            );
          },
        );
      },
    );
  }
}
