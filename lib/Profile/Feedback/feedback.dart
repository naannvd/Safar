import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

// Add these imports

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA1CA73),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA1CA73),
        // title: const Text('Your Feedbacks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feedback')
            .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No feedbacks found!'),
            );
          }
          final feedbackDocs = snapshot.data!.docs;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  'Recent Trips',
                  style: GoogleFonts.montserrat(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF042F42),
                  ),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: feedbackDocs.length,
                  itemBuilder: (context, index) {
                    final feedback =
                        feedbackDocs[index].data() as Map<String, dynamic>;
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 5, bottom: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: feedback['rating'] != null
                              ? [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 0),
                                  ),
                                ]
                              : [],
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey.shade300),
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          title: Text(
                            feedback['message'] ?? 'No Title',
                            style: GoogleFonts.montserrat(),
                          ),
                          subtitle: Text(
                            feedback['ticketId'] ?? 'No Message',
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: () {
                                switch (feedback['ticketId']?.substring(0, 1)) {
                                  case 'O':
                                    return const Color(0xFFE06236);
                                  case 'B':
                                    return const Color(0xFF3E7C98);
                                  case 'G':
                                    return const Color(0xFFA1CA73);
                                  case 'R':
                                    return const Color(0xFFCC3636);
                                  default:
                                    return Colors.black;
                                }
                              }(),
                            ),
                          ),
                          trailing: Text(
                            ' Rating : ${(feedback['rating'] ?? 'No Rating').toString()} /5',
                            style: GoogleFonts.montserrat(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
