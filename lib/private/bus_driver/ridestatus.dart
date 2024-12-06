import 'package:flutter/material.dart';
import 'package:safar/private/bus_driver/driver_functionality/mark_attendance.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safar/private/bus_driver/driver_functionality/present_students.dart';

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

            // Placeholder for Map
            // Container(
            //   height: 200,
            //   width: double.infinity,
            //   color: Colors.grey[300],
            //   child: const Center(
            //     child: Text(
            //       "Map Placeholder",
            //       style: TextStyle(fontSize: 16, color: Colors.black54),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 20),
            // ignore: avoid_unnecessary_containers
            Expanded(
              child: PresentStudents(
                rideId: widget.rideId,
              ),
            ),
            const SizedBox(height: 20),
            const AttendanceQRScanner(),
          ],
        ),
      ),
    );
  }
}
