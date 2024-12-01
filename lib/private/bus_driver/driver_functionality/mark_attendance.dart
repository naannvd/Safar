import 'package:flutter/material.dart';
import 'package:safar/Profile/QrScanner/scanner_with_window.dart';

class AttendanceQRScanner extends StatelessWidget {
  const AttendanceQRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const BarcodeScannerWithScanWindow(),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3E7C98),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      child: const Text(
        "Scan QR Code",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
