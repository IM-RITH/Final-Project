import 'dart:convert';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic> paymentIntentData = {};

Future<void> makeStripePayment(
    {required String amount, required String currency}) async {
  try {
    paymentIntentData = await createPaymentIntent(amount, currency);
    if (paymentIntentData != null) {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
          merchantDisplayName: "EasyShop",
          customerId: paymentIntentData['customer'],
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          customerEphemeralKeySecret: paymentIntentData['ephemeralKey'],
        ),
      );
      await displayPaymentSheet();
    }
  } catch (e) {
    print("Error in makeStripePayment=> $e");
  }
}

Future<Map<String, dynamic>> createPaymentIntent(
    String amount, String currency) async {
  try {
    Map<String, String> body = {
      "amount": calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };
    var response = await http.post(
      Uri.parse("https://api.stripe.com/v1/payment_intents"),
      body: body,
      headers: {
        "Authorization":
            "Bearer sk_test_51O2byHBwiigsCeoGQn7RmpzY5fx1tmWlcYGNNtljs35HIZN93INCI103pe64FZeHqFByqXRBEFOTlWQNHsGjVSRp00yVUh4Wkk",
        "Content-Type": "application/x-www-form-urlencoded",
      },
    );
    return jsonDecode(response.body);
  } catch (e) {
    print("Error in createPaymentIntent=> $e");
    return {};
  }
}

Future<void> displayPaymentSheet() async {
  try {
    await Stripe.instance.presentPaymentSheet();
    print("Success Payment");
  } catch (e) {
    if (e is StripeException) {
      print("Error from Stripe: ${e.error.localizedMessage}");
    } else {
      print("Unforeseen error: $e");
    }
  }
}

String calculateAmount(String amount) {
  try {
    final amountValue = (double.parse(amount) * 100).toInt();
    return amountValue.toString();
  } catch (e) {
    print("Error in calculateAmount=> $e");
    return '0';
  }
}
