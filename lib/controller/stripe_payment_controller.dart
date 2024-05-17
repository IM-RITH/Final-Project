// import 'package:easyshop/service/stripe_payment.dart';
// import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// final stripePaymentController =
//     StateNotifierProvider<StripePaymentController, bool>(
//   (ref) => StripePaymentController(
//     ref: ref,
//     stripePaymentService: ref.watch(stripePaymentserviceProvider),
//   ),
// );

// class StripePaymentController extends StateNotifier<bool> {
//   final Ref _ref;
//   final StripePaymentService _stripePaymentService;

//   StripePaymentController(
//       {required Ref ref, required StripePaymentService stripePaymentService})
//       : _ref = ref,
//         _stripePaymentService = stripePaymentService,
//         super(false);
//   Future<void> makePayment(BuildContext context, double amount) {
//     return _stripePaymentService.makePayment(context, amount);
//   }
// }
