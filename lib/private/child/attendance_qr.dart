import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildQRCodeWidget extends StatelessWidget {
  const ChildQRCodeWidget({super.key});

  Future<String> fetchChildId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("No logged-in user found");
      }

      final childDoc = await FirebaseFirestore.instance
          .collection('childs')
          .doc(user.uid)
          .get();

      if (!childDoc.exists) {
        throw Exception("Child document not found for user");
      }

      return childDoc.id; // Assuming document ID is the `child_id`
    } catch (e) {
      throw Exception("Error fetching child ID: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchChildId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Error: ${snapshot.error}",
              style: const TextStyle(color: Colors.red),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No child ID found"));
        }

        final childId = snapshot.data!;

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Your QR Code",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                QrImageView(
                  data: childId,
                  version: QrVersions.auto,
                  size: 200.0,
                  // gapless: false,
                  // embeddedImage: const AssetImage('assets/images/bus_icon.png'),
                  // embeddedImageStyle: const QrEmbeddedImageStyle(
                  //   size: Size(40, 40),
                  // ),
                ),
                const SizedBox(height: 20),
                Text(
                  "Child ID: $childId",
                  style: const TextStyle(
                      fontSize: 16, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
