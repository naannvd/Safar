// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart';

class TicketCard extends StatelessWidget {
  const TicketCard(
      {super.key, required this.toStation, required this.fromStation});
  final String toStation;
  final String fromStation;

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

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    // final fullName = userData['fullName'];
    // final firstName = fullName.split(' ')[0];
    return userData['fullName'];
    // return firstName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFA1CA73,
      ),
      body: FutureBuilder(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Center(
            child: Container(
              width: 350, // Approximate max-w-sm in Tailwind
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
                    padding: const EdgeInsets.all(24),
                    decoration: const BoxDecoration(
                      // gradient: LinearGradient(
                      //   colors: [
                      //     Color(0xFF3B82F6),
                      //     Color(0xFF8B5CF6)
                      //   ], // from-blue-500 to-purple-600
                      //   begin: Alignment.centerLeft,
                      //   end: Alignment.centerRight,
                      // ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(12)),
                    ),
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
                          children: [
                            // Left Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    toStation,
                                    style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 14,
                                      color: Color(0xFF042F42),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Dec 10 6:00pm',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: Color(0xFF042F42),
                                    ),
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
                                  Text(fromStation,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Dec 10 6:20pm',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 12,
                                      color: Color(0xFF042F42),
                                    ),
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
                                const Text(
                                  'Passenger Name',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "${snapshot.data}",
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Seat No.
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Seat No.',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '3,4',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            // Ticket No.
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Ticket No.',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '5SB7W0',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Dashed Divider
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          indent: 0,
                          endIndent: 0,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  // Footer Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF3F4F6), // gray-100
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Stack(
                      children: [
                        // Top Left Circle
                        Positioned(
                          top: -8,
                          left: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Top Right Circle
                        Positioned(
                          top: -8,
                          right: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        // Content
                        const Column(
                          children: [
                            SizedBox(height: 8),
                            Text(
                              'Show this to the counter at the bus station',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Ticket Status: CONFIRMED',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const RoundedNavBar(currentTab: 'Ticket'),
    );
  }
}
