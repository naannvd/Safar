import 'package:flutter/material.dart';
import 'package:safar/Tickets/ticket_book.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeepLinkHandler extends StatefulWidget {
  const DeepLinkHandler({super.key});

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  StreamSubscription? _sub;
  String? _ticketId;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  void _initDeepLinkListener() {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.pathSegments.isNotEmpty) {
        String ticketId = uri.pathSegments.last; // Extract ticketId
        setState(() {
          _ticketId = ticketId;
        });

        // Execute Firestore update logic
        _completeTicket(ticketId);
      }
    }, onError: (err) {
      print('Error occurred while handling deep link: $err');
    });
  }

  Future<void> _completeTicket(String ticketId) async {
    try {
      // Get the ticket document
      Future<QuerySnapshot<Map<String, dynamic>>> futureTicketQuery =
          FirebaseFirestore.instance
              .collection('tickets')
              .where('ticketId', isEqualTo: ticketId)
              .limit(1)
              .get();

      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await futureTicketQuery;

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference ticketDocRef = querySnapshot.docs.first.reference;

        // Update ticket status to "completed"
        await ticketDocRef.update({'status': 'completed'});

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Your ticket has been completed!')),
        );

        // Navigate to TicketBook or another screen if necessary
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const TicketBook()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Ticket not found!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing ticket: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _ticketId == null
            ? const Text('No ticket link received yet.')
            : Text('Ticket ID: $_ticketId'), // Display ticket info
      ),
    );
  }
}
