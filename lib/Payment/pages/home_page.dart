import 'package:flutter/material.dart';
import 'package:safar/Payment/services/stripe_service.dart';

class PaymentScreen extends StatelessWidget {
  final VoidCallback onPaymentSuccess;

  const PaymentScreen({super.key, required this.onPaymentSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Stripe Payment"),
      ),
      body: Center(
        child: MaterialButton(
          onPressed: () async {
            try {
              await StripeService.instance.makePayment(amount: 5000);
              // If payment is successful, invoke the callback
              onPaymentSuccess();
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Payment failed: $e')),
              );
            }
          },
          color: Colors.green,
          child: const Text(
            "Make Payment",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
