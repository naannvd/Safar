import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SOSButton extends StatefulWidget {
  final String studentId; // Pass the student's ID to check champion status

  const SOSButton({super.key, required this.studentId});

  @override
  State<SOSButton> createState() => _SOSButtonState();
}

class _SOSButtonState extends State<SOSButton> {
  bool isChampion = false;

  @override
  void initState() {
    super.initState();
    _checkChampionStatus(); // Fetch the champion status on initialization
  }

  Future<void> _checkChampionStatus() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('childs') // Adjust collection if needed
          .doc(widget.studentId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        setState(() {
          isChampion = userDoc['isChampion'] ?? false; // Default to false
        });
      }
    } catch (e) {
      print("Error fetching champion status: $e");
      setState(() {
        isChampion = false; // Fallback to disabled if error occurs
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isChampion
          ? () {
              // Only allow if the user is a champion
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirm Emergency"),
                    content: const Text(
                        "Are you sure you want to send an SOS alert?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () {
                          // sendEmergencyAlert(); // Backend function call
                          Navigator.pop(context);
                        },
                        child: const Text("Send"),
                      ),
                    ],
                  );
                },
              );
            }
          : null, // Disable the button if not a champion
      style: ElevatedButton.styleFrom(
        backgroundColor: isChampion
            ? Colors.red
            : Colors.grey, // Change color based on status
      ),
      child: Text(
        isChampion ? "SOS" : "Disabled", // Change text dynamically
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
