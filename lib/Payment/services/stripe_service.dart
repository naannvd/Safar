import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:safar/consts.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment({required int amount}) async {
    try {
      // Default currency set to PKR
      String currency = "pkr";

      String? paymentIntentClientSecret = await _createPaymentIntent(
        amount,
        currency,
      );
      if (paymentIntentClientSecret == null) {
        throw Exception("Failed to create payment intent");
      }

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Sayyed Areeb",
        ),
      );

      await _processPayment();

      // If we reach here without exceptions, payment is completed successfully.
    } catch (e) {
      // Rethrow the exception so that the caller can detect the failure
      rethrow;
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Error creating payment intent: $e");
      return null;
    }
  }

  Future<void> _processPayment() async {
    try {
      // This call presents the payment sheet and will confirm payment upon success.
      await Stripe.instance.presentPaymentSheet();

      // Do NOT call confirmPaymentSheetPayment() again.
      // presentPaymentSheet() should handle the payment confirmation flow itself.
    } catch (e) {
      print("Error presenting payment sheet: $e");
      rethrow; // rethrow the error so that the parent method can handle it
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100; // Convert to smallest currency unit
    return calculatedAmount.toString();
  }
}
