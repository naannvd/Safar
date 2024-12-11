// PaymentHelper.dart (example)
import 'package:flutter/material.dart';
import 'package:safar/Payment/services/stripe_service.dart';
// Import the TicketCard widget (adjust the path as needed)
// import 'package:safar/tickets/ticket_card.dart';

class PaymentHelper {
  static Future<bool> openStripePaymentView(
      BuildContext context, int amount) async {
    try {
      await StripeService.instance.makePayment(amount: amount);
      // If payment is successful, navigate to the TicketCard screen or simply return true.
      // Remove the navigation to TicketCard here if you only want to create the ticket after payment.

      // Payment successful
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
      return false;
    }
  }
}
