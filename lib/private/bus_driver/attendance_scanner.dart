import 'package:flutter/material.dart';

class AttendanceScanner extends StatelessWidget {
  const AttendanceScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Implement attendance scanning logic
          },
          child: const Text('Scan QR Code'),
        ),
      ),
    );
  }
}
