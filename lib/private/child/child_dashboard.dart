import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:safar/private/child/attendance_QR.dart';
import 'package:safar/private/child/sos_button.dart';

class ChildDashboard extends StatelessWidget {
  const ChildDashboard({super.key});

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      final userData = await FirebaseFirestore.instance
          .collection('childs')
          .doc(user!.uid)
          .get();
      final fullName = userData['child_name'];
      return fullName;
    } on Exception {
      // TODO
    }
    return 'User not found';
  }

  @override
  Widget build(BuildContext context) {
    final student = FirebaseAuth.instance.currentUser;
    return FutureBuilder<String>(
      future: getUserName(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return const Center(child: Text('Error fetching data'));
        } else {
          // print(student!.uid);
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ChildQRCodeWidget(),
                        ),
                      );
                    },
                    child: const Text('Scan your attendance'),
                  ),
                  const SizedBox(height: 20),
                  Text('Child Dashboard: ${snapshot.data}'),
                  const SizedBox(height: 20),
                  SOSButton(studentId: student!.uid),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
