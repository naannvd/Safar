import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // Show a SnackBar if no tickets are found
        Future.delayed(Duration.zero, () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No Recent Trips. Book a ticket to get started!'),
            ),
          );
        });
      }

      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    }).handleError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tickets: $e')),
      );
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

        return Expanded(
          child: Center(
            child: Text('s'),
          ),
        );
      },
    );
  }
}
