import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/private/parent/add_child.dart';
import 'package:safar/private/parent/daily_trip.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ParentDashboard extends StatefulWidget {
  const ParentDashboard({super.key});

  @override
  State<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard> {
  void subscribeToParentNotifications() async {
    await FirebaseMessaging.instance.subscribeToTopic('parents');
    print("Subscribed to 'parents' topic.");
  }

  @override
  void initState() {
    super.initState();
    subscribeToParentNotifications();
  }

  @override
  Widget build(BuildContext context) {
    print(FirebaseAuth.instance.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 200,
            // ),
            ElevatedButton(
              child: const Text("Add Child"),
              onPressed: () {
                print(FirebaseAuth.instance.currentUser!.uid);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddChildDashboard(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 320,
              // width: double.infinity,
              // decoration: BoxDecoration(color: Colors.grey[200]),
              child: const DailyTrip(),
            )
          ],
        ),
      ),
    );
  }
}
