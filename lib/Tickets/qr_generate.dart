import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQR extends StatelessWidget {
  final String fromStation;
  final String toStation;
  final String ticketNumber;
  final String purchaseTime;
  final String timeToNextStation;

  const TicketQR({
    super.key,
    required this.fromStation,
    required this.toStation,
    required this.ticketNumber,
    required this.purchaseTime,
    required this.timeToNextStation,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> ticketData = {
      'fromStation': fromStation,
      'toStation': toStation,
      'ticketNumber': ticketNumber,
      'purchaseTime': purchaseTime,
      'timeToNextStation': timeToNextStation,
    };
    final String encodedTicketData = jsonEncode(ticketData);
    return QrImageView(
      data: encodedTicketData,
      version: QrVersions.auto,
      size: 130.0, // Proper size for the QR code
    );
  }
}
