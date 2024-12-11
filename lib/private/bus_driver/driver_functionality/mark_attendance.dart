import 'package:flutter/material.dart';
import 'package:safar/Profile/QrScanner/scanner_with_window.dart';

class AttendanceQRScanner extends StatelessWidget {
  const AttendanceQRScanner({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Makes the button take full width
      height: 50, // Increases the height of the button
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const BarcodeScannerWithScanWindow(),
            ),
          );
        },
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            const Color(0xFFA1CA73),
          ),
        ),
        child: const Text(
          'Scan QR Code',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: 'Montserrat',
            color: Color(0xFF042F40),
          ),
        ),
      ),
    );
  }
}
