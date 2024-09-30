import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:safar/Tickets/complete_button.dart';
import 'package:safar/Tickets/qr_generate.dart';
import 'package:safar/Tickets/ticket_book.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart';

class TicketCard extends StatelessWidget {
  const TicketCard({super.key});

  // Function to build a dashed line for the UI
  Widget buildDashedLine(
      {double height = 2,
      double dashWidth = 5,
      double dashGap = 3,
      Color color = Colors.black}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double totalWidth = constraints.maxWidth;
        final int dashCount = (totalWidth / (dashWidth + dashGap)).floor();
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(dashCount, (_) {
            return Container(
              width: dashWidth,
              height: height,
              margin: EdgeInsets.only(right: dashGap),
              color: color,
            );
          }),
        );
      },
    );
  }

  // Function to fetch username from Firestore
  Future<String> getUserName(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.data() == null ||
          !userData.data()!.containsKey('fullName')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: User full name not found!')),
        );
        throw Exception("Full name not found in user data");
      }

      return userData['fullName'];
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
      return 'Unknown User';
    }
  }

  String formatDate(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMM d, h:mm a')
        .format(dateTime); // Sep 30, 4:51 am format
  }

  // Function to fetch active tickets from Firestore
  Future<List<Map<String, dynamic>>> fetchActiveTickets(
      BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      QuerySnapshot ticketData = await FirebaseFirestore.instance
          .collection('tickets')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'active')
          .get();

      if (ticketData.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active tickets found')),
        );
        throw Exception("No active tickets found");
      }

      return ticketData.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching tickets: ${e.toString()}')),
      );
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFA1CA73,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchActiveTickets(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Error occurred or no active tickets found!'),
            );
          }

          Map<String, dynamic> ticketData = snapshot.data!.first;

          String toStation = ticketData['toStation'] ?? 'Unknown Station';
          String fromStation = ticketData['fromStation'] ?? 'Unknown Station';
          String ticketId = ticketData['ticketId'] ?? 'Unknown ID';
          String userName = ticketData['userName'] ?? 'Unknown User';
          String purchaseTime = formatDate(ticketData['purchaseTime'] != null
              ? (ticketData['purchaseTime'])
              : 'Unknown Time');
          String timeToNextStation = formatDate(
              ticketData['timeToNextStation'] != null
                  ? (ticketData['timeToNextStation'])
                  : 'Unknown Time');
          String fare = ticketData['fare']?.toString() ?? 'Unknown Fare';

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  'Ticket Details',
                  style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Center(
                child: Container(
                  width: 350,
                  margin: const EdgeInsets.symmetric(vertical: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 5,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Section
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            const Text(
                              'SAFAR',
                              style: TextStyle(
                                fontFamily: 'TitleFont',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF042F42),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Left Text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        fromStation.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        purchaseTime,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                // Bus Icon with Dashed Lines
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      // Left Dashed Line
                                      SizedBox(
                                        width: 30,
                                        child: buildDashedLine(
                                          height: 2,
                                          dashWidth: 5,
                                          dashGap: 3,
                                          color: const Color(0xFF042F42),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const FaIcon(
                                        FontAwesomeIcons.bus,
                                        size: 24,
                                        color: Color(0xFF042F42),
                                      ),
                                      const SizedBox(width: 4),
                                      // Right Dashed Line
                                      SizedBox(
                                        width: 30,
                                        child: buildDashedLine(
                                          height: 2,
                                          dashWidth: 5,
                                          dashGap: 3,
                                          color: const Color(0xFF042F42),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Right Text
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        toStation.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        timeToNextStation,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Content Section
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            // First Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Passengers
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Passenger Name',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 71, 69, 69),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    FutureBuilder<String>(
                                      future: getUserName(context),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error.toString()}');
                                        }
                                        return Text(
                                          snapshot.data!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Fare',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 71, 69, 69),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      fare,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                // Ticket No.
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Ticket No.',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            255, 71, 69, 69),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ticketId,
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            // Dashed Divider
                            // const Divider(
                            //   color: Colors.grey,
                            //   thickness: 1,
                            //   indent: 0,
                            //   endIndent: 0,
                            // ),
                            const SizedBox(height: 18),

                            // const SizedBox(height: 4),
                            Text(
                              'Ticket Status: CONFIRMED',
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF042F42),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                      ),
                      // Footer Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                            left: 24, top: 5, bottom: 15, right: 24),
                        decoration: const BoxDecoration(
                          // color: Color(0xFFF3F4F6), // gray-100
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(12)),
                        ),
                        child: Flexible(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 4),
                              // TicketQR is now placed inside a constrained layout
                              const Text(
                                'Show this to the counter at the bus station',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TicketQR(
                                  fromStation: fromStation,
                                  toStation: toStation,
                                  ticketNumber: ticketId,
                                  purchaseTime: purchaseTime,
                                  timeToNextStation: timeToNextStation)
                            ],
                          ),
                        ),
                      ),
                      // TicketQR(
                      //   fromStation: fromStation,
                      //   toStation: toStation,
                      //   ticketNumber: ticketId,
                      //   purchaseTime: purchaseTime,
                      //   timeToNextStation: timeToNextStation,
                      // ),
                    ],
                  ),
                ),
              ),
              CompleteButton(ticketData: ticketData),
            ],
          );
        },
      ),
      bottomNavigationBar: const RoundedNavBar(currentTab: 'Ticket'),
    );
  }
}
