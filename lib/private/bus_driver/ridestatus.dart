import 'package:flutter/material.dart';
import 'package:safar/private/bus_driver/driver_functionality/mark_attendance.dart';
import 'package:safar/private/bus_driver/driver_functionality/present_students.dart';
import 'package:safar/private/bus_driver/full_map.dart';

class RideStatusScreen extends StatefulWidget {
  final String rideId;

  const RideStatusScreen({super.key, required this.rideId});

  @override
  State<RideStatusScreen> createState() => _RideStatusScreenState();
}

class _RideStatusScreenState extends State<RideStatusScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
        backgroundColor: const Color(0xFF042F42),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Ride Status Header
            Text(
              "Ride ID: ${widget.rideId}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // "View Full Map" Button
            ElevatedButton(
              onPressed: () {
                // Navigate to the FullMapScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullMapScreen(rideId: widget.rideId),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF042F42),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'View Full Map',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Present Students List
            Expanded(
              child: PresentStudents(
                rideId: widget.rideId,
              ),
            ),

            const SizedBox(height: 20),

            // Attendance QR Scanner
            const AttendanceQRScanner(),
          ],
        ),
      ),
    );
  }
}
