import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      body: FutureBuilder(
        future: getUserName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
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
                const SizedBox(height: 20),
                const RouteBox(),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: RoundedNavBar(currentTab: 'Home'),

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
