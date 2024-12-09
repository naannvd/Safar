import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safar/private/parent/parent_functionality/add_child.dart';
import 'package:safar/private/parent/parent_functionality/child_list.dart';
import 'package:safar/private/parent/daily_trip.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safar/private/parent/set_location.dart';

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
    final parentId = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              child: const Text("Set Location"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SetLocationScreen(parentId: parentId),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              height: 320,
              child: const DailyTrip(),
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Text(
                'Child List',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF042F42),
                ),
              ),
            ),
            Container(
              height: 320,
              child: ChildList(parentId: parentId),
            ),
          ],
        ),
      ),
    );
  }
}
