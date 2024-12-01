import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:safar/Tickets/ticket_book.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({super.key, required this.ticketData});
  final Map<String, dynamic> ticketData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showRatingDialog(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        decoration: const BoxDecoration(
          color: Color(0xFF042F42),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            'Complete Ticket',
            style: GoogleFonts.montserrat(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _showRatingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        double rating = 0.0;
        return AlertDialog(
          title: const Text('Rate your experience'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBar(
                onRatingChanged: (rating) {
                  rating = rating;
                },
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
                // isHalfAllowed: true,
                filledColor: Colors.amber,
                emptyColor: Colors.grey,
                size: 36,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const TicketBook()),
                );
                _completeTicket(context, rating);
              },
              child: Text(
                'Submit',
                style: GoogleFonts.montserrat(
                    fontSize: 16, color: const Color(0xFF042F42)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _completeTicket(BuildContext context, double rating) async {
    try {
      final ticketId = ticketData['ticketId']; // The ticketId stored as a field
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
        // Update the ticket with status completed and save the rating
        await ticketDocRef.update({
          'status': 'completed',
          'rating': rating,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket completed successfully!')),
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
}
