import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AttendanceQR extends StatelessWidget {
  final String qrData;

  const AttendanceQR({super.key, required this.qrData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: qrData,
          version: QrVersions.auto,
          size: 200.0,
        ),
      ),
    );
  }
}
