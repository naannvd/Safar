import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketQR extends StatelessWidget {
  // final String fromStation;
  // final String toStation;
  // final String ticketNumber;
  // final String purchaseTime;
  // final String timeToNextStation;
  final String ticketId;

  const TicketQR({
    super.key,
    // required this.fromStation,
    // required this.toStation,
    // required this.ticketNumber,
    // required this.purchaseTime,
    // required this.timeToNextStation,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> ticketData = {
    //   'fromStation': fromStation,
    //   'toStation': toStation,
    //   'ticketNumber': ticketNumber,
    //   'purchaseTime': purchaseTime,
    //   'timeToNextStation': timeToNextStation,
    // };

    final String ticketUrl = 'https://your-app-domain.com/ticket/$ticketId';

    // final String encodedTicketData = jsonEncode(ticketData);
    return QrImageView(
      data: ticketUrl,
      version: QrVersions.auto,
      size: 130.0, // Proper size for the QR code
    );
  }
}
