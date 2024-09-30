import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Tickets/ticket_book.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({super.key, required this.ticketData});
  final Map<String, dynamic> ticketData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final ticketId =
              ticketData['ticketId']; // The ticketId stored as a field

          // Get the future QuerySnapshot
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

            await ticketDocRef.update({'status': 'completed'});

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Your ticket has been completed!')),
            );
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
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF042F42),
          borderRadius:
              // BorderRadius.vertical(bottom: Radius.circular(20), ),
              BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text('Complete Ticket',
              style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}
