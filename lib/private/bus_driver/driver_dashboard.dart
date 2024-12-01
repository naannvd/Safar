import 'package:flutter/material.dart';
import 'package:safar/private/bus_driver/driver_functionality/emergency_sos.dart';
import 'package:safar/private/bus_driver/driver_functionality/mark_attendance.dart';
import 'package:safar/private/bus_driver/driver_functionality/start_ride.dart';

class DriverDashboard extends StatelessWidget {
  const DriverDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        backgroundColor: const Color(0xFF042F42),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RideStart(),
            SizedBox(height: 20),
            AttendanceQRScanner(),
            SizedBox(height: 20),
            EmergencySOS(),
          ],
        ),
      ),
    );
  }
}
