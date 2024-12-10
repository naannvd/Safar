import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:safar/Dashboard/landing_page.dart';
import 'package:safar/Payment/pages/home_page.dart';
import 'package:safar/Tickets/ticket.dart';
import 'package:safar/Tickets/ticket_book.dart';

class CompleteButton extends StatelessWidget {
  const CompleteButton({super.key, required this.ticketData});
  final Map<String, dynamic> ticketData;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _completeTicket(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LandingPage()),
        );
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
                onRatingChanged: (newRating) {
                  rating = newRating;
                },
                filledIcon: Icons.star,
                emptyIcon: Icons.star_border,
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
                _completeTicket(
                  context,
                );
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

  Future<void> _completeTicket(BuildContext context) async {
    try {
      final ticketId = ticketData['ticketId'];
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('tickets')
              .where('ticketId', isEqualTo: ticketId)
              .limit(1)
              .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference ticketDocRef = querySnapshot.docs.first.reference;
        await ticketDocRef.update({
          'status': 'completed',
          // 'rating': rating,
        });

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
        SnackBar(content: Text('Error completing ticket: $e')),
      );
    }
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId != null) {
        final userDocRef =
            FirebaseFirestore.instance.collection('users').doc(userId);
        await userDocRef.update({
          'loyalty_points': FieldValue.increment(30),
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Loyalty points updated!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User not logged in!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating loyalty points: $e')),
      );
    }
  }
}
