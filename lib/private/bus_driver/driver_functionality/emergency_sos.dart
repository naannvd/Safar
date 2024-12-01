import 'package:flutter/material.dart';

class EmergencySOS extends StatelessWidget {
  const EmergencySOS({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Logic to trigger emergency alert
        // Example: sendEmergencyAlert();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: const Text(
        "Emergency Alert",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
