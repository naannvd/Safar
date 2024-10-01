import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/Dashboard/PrevTickets/ticket_builder.dart';
import 'package:safar/Dashboard/PrevTickets/ticket_list.dart';
import 'package:safar/Dashboard/route_box.dart';
import 'package:safar/Widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
// import 'package:safar/Widgets/starting_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final fullName = userData['fullName'];
    final firstName = fullName.split(' ')[0];
    // return userData['fullName'];
    return firstName;
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print('User ID : ${user!.uid}');
    return Scaffold(
      backgroundColor: Colors.white,
      body: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: getUserName(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('An error occurred'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No data found'),
                  );
                }
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 100),
                      Text(
                        "Welcome, ${snapshot.data}",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const RouteBox(),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'Recent Trips',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF042F42),
                ),
              ),
            ),
            Container(
              height: 220,
              width: double
                  .infinity, // Still takes up the full width of the parent container
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: const SingleChildScrollView(
                // Horizontal scroll if needed
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 450, // TicketBuilder will have the specified width
                  child: Align(
                    alignment:
                        Alignment.centerLeft, // Align the card to the left
                    child: TicketList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const RoundedNavBar(currentTab: 'Home'),

      // return Center(
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     // mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       const SizedBox(height: 100),
      //       Text(
      //         "Welcome, Areeb",
      //         style: Theme.of(context).textTheme.displayLarge,
      //       ),
      //       const SizedBox(height: 20),
      //       const RouteBox(),
      //     ],
      //   ),
      // ),
    );
  }
}
