import 'package:flutter/material.dart';
import 'package:safar/private/bus_driver/attendance_scanner.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: const Color(0xFF042F42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to start ride screen or logic
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AttendanceScanner()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA1CA73),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text(
                "Start Ride",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to QR scanning functionality
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const AttendanceScanner()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E7C98),
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text(
                "Scan QR Code",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Trigger emergency alert
                // sendEmergencyAlert();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
              child: const Text(
                "Emergency Alert",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
