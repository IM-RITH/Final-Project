// import 'dart:convert';

// import 'package:easyshop/const/stripe_api.dart';
// import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// final stripePaymentserviceProvider =
//     Provider((ref) => StripePaymentService(ref: ref));

// class StripePaymentService {
//   final Ref _ref;
//   StripePaymentService({required Ref ref}) : _ref = ref;

//   Map<String, dynamic>? paymentIntent;

//   Future<void> makePayment(BuildContext context, double amount) async {
//     try {
//       // create payment intent
//       paymentIntent = await createPaymentIntent(amount.toString(), 'USD');

//       // initialize payment sheet
//       await Stripe.instance
//           .initPaymentSheet(
//               paymentSheetParameters: SetupPaymentSheetParameters(
//             customFlow: true,
//             paymentIntentClientSecret:
//                 paymentIntent!['client_secret'], // gotten from payment intent
//             // customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
//             style: ThemeMode.light,
//             merchantDisplayName: 'EasyShop',
//             // customerId: paymentIntent!['customerId'],
//             // googlePay: const PaymentSheetGooglePay(merchantCountryCode: "US"),
//             allowsDelayedPaymentMethods: true,
//           ))
//           .then((value) {});

//       // display payment sheet
//       displayPaymentSheet(context);
//     } catch (e) {
//       throw Exception(e);
//     }
//   }

//   createPaymentIntent(String amount, String currency) async {
//     try {
//       // request body
//       Map<String, dynamic> body = {
//         "amount": calculateAmount(amount),
//         "currency": currency,
//       };

//       // make post request to stripe
//       var response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           'Authorization': 'Bearer ${StripeApi.stripeSecretKey}',
//           'Content-Type': 'application/x-www-form-urlencoded'
//         },
//         body: body,
//       );
//       if (response.statusCode == 200) {}
//       return json.decode(response.body);
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   // total amount
//   calculateAmount(String amount) {
//     final calculateAmount = (double.parse(amount) * 100).toInt();
//     return calculateAmount.toString();
//   }

//   // display payment sheet
//   displayPaymentSheet(BuildContext context) async {
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         showDialog(
//             context: context,
//             builder: (_) => const AlertDialog(
//                   content: Column(
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         color: Colors.green,
//                         size: 100.0,
//                       ),
//                       SizedBox(
//                         height: 10.0,
//                       ),
//                       Text("Payment Successful!")
//                     ],
//                   ),
//                 ));

//         paymentIntent = null;
//       }).onError((error, stackTrace) {
//         throw Exception(error);
//       });
//     } on StripeException catch (e) {
//       print('Error is:--> $e');
//       const AlertDialog(
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Row(
//               children: [
//                 Icon(
//                   Icons.cancel,
//                   color: Colors.red,
//                 ),
//                 Text('Payment failed'),
//               ],
//             )
//           ],
//         ),
//       );
//     } catch (e) {
//       print('$e');
//     }
//   }
// }
