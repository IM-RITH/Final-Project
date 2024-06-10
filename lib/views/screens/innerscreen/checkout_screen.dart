import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/const/fcmkey.dart';
import 'package:easyshop/fetch_access_token/fetch_access_token.dart';
import 'package:easyshop/provider/cart_provider.dart';
import 'package:easyshop/service/payment.dart';
import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String _selectedPaymentMethod = 'cod';

  // Define the payment methods available
  final List<Map<String, String>> paymentMethods = [
    {'method': 'cod', 'label': 'Cash on Delivery', 'icon': 'cash'},
    {'method': 'card', 'label': 'Pay with Card', 'icon': 'card'},
    {'method': 'paypal', 'label': 'Pay with PayPal', 'icon': 'paypal'},
  ];

  @override
  void initState() {
    super.initState();
    _setCurrentLocation();
  }

  Future<void> _setCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        String buildingNumber = place.subThoroughfare ?? '';
        String streetName = place.thoroughfare ?? '';
        String villageName = place.subLocality ?? '';
        String communeName = place.locality ?? '';
        String provinceName = place.administrativeArea ?? '';
        String countryName = place.country ?? '';

        String address = [
          buildingNumber,
          streetName,
          villageName,
          communeName,
          provinceName,
          countryName
        ].where((part) => part.isNotEmpty).join(', ');

        setState(() {
          _addressController.text = address;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _placeOrder() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final _cartProvider = ref.read(cartProvider.notifier);
    final userDocs =
        await fireStore.collection('buyers').doc(auth.currentUser!.uid).get();
    final String buyerName =
        (userDocs.data() as Map<String, dynamic>)['username'];

    for (var key in _cartProvider.getCartItem.keys) {
      final item = _cartProvider.getCartItem[key];
      final productDoc =
          await fireStore.collection('products').doc(item!.productId).get();
      final vendorId = productDoc['vendorId'];
      final orderId = const Uuid().v4();

      await fireStore.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'productId': item.productId,
        'productName': item.productName,
        'quantity': item.productQuantity,
        'totalPrice':
            item.productQuantity * item.productDisPrice + item.shippingFees,
        'shippingFees': item.shippingFees,
        'buyerName': buyerName,
        'buyerEmail': (userDocs.data() as Map<String, dynamic>)['email'],
        'buyerId': auth.currentUser!.uid,
        'vendorId': vendorId,
        'accept': false,
        'date': DateTime.now(),
        'productSize': item.productSize,
        'productColor': item.productColor,
        'productImage': item.imageUrlList,
        'address': _addressController.text,
        'phone': _phoneController.text,
        'paymentMethod': _selectedPaymentMethod,
        'delivered': false,
        'status': 'ended',
        'processing': [
          'Order placed',
          'Vendor accepted your order',
          'Your product is being prepared for delivery',
          'Your product is out for delivery',
          'Your product is near your location',
          'Your product has been delivered',
        ],
      }).whenComplete(() {
        // send push notification to seller about new order
        sendNotificationToVendor(
          vendorId.toString(),
          orderId,
          buyerName,
        );
      });
    }
  }

  // pay with flutterwave
  Future<void> _handleFlutterwavePayment(double amount) async {
    final Customer customer = Customer(
      name: "FLW Developer",
      phoneNumber: _phoneController.text,
      email: (FirebaseAuth.instance.currentUser)!.email!,
    );

    final Flutterwave flutterwave = Flutterwave(
      context: context,
      publicKey: "FLWPUBK_TEST-221d38d79a2870a15fe6e7bb3960512d-X",
      currency: "USD",
      txRef: const Uuid().v4(),
      amount: amount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude, bank transfer",
      customization: Customization(
        title: "Test Payment",
        description: "Payment for items in cart",
        logo: "https://flutterwave.com/images/logo-colored.svg",
      ),
      isTestMode: true,
      redirectUrl:
          "https://www.google.com", // Replace with your actual redirect URL
    );

    final ChargeResponse response = await flutterwave.charge();
    log("Response received: ${response.toJson()}");
    if (response != null) {
      if (response.status == "successful" || response.status == "success") {
        log("Payment successful: ${response.toJson()}");
        await _placeOrder();
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Payment Success',
          'Your payment was successful.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        log("Payment failed: ${response.toJson()}");
        setState(() {
          _isLoading = false;
        });
        Get.snackbar(
          'Payment Failed',
          'Your payment was not successful. Please try again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'Payment Cancelled',
        'Your payment was cancelled.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _handlePayPalPayment(double amount) async {
    setState(() {
      _isLoading = true;
    });

    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => PaypalCheckoutView(
        sandboxMode: true,
        clientId:
            "ASmxTdcBA0zT_BM8TReTfTv1qPXj6CxOQzcqGaqsH5AJEXSFq7crYS1ZHNwveA-kepdtMTY5DSDViznr",
        secretKey:
            "EHy45zDx1hZtTdpCQX07QUbmip229XOPpuTTdz7ln8fY5RgdWR55Ab9_6LMyLn15F_SZTK0rcYyNlMgI",
        transactions: [
          {
            "amount": {
              "total": amount.toStringAsFixed(2),
              "currency": "USD",
              "details": {
                "subtotal": amount.toStringAsFixed(2),
                "shipping": '0',
                "shipping_discount": 0
              }
            },
            "description": "Payment for your order",
            "item_list": {
              "items": [
                {
                  "name": "Total Order",
                  "quantity": 1,
                  "price": amount.toStringAsFixed(2),
                  "currency": "USD"
                }
              ]
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          log("onSuccess: $params");
          await _placeOrder();
          setState(() {
            _isLoading = false;
          });
          Get.snackbar(
            'Payment Success',
            'Your payment was successful.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          Navigator.pop(context);
        },
        onError: (error) {
          log("onError: $error");
          setState(() {
            _isLoading = false;
          });
          Get.snackbar(
            'Payment Failed',
            'Your payment was not successful. Please try again.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          Navigator.pop(context);
        },
        onCancel: () {
          log('cancelled:');
          setState(() {
            _isLoading = false;
          });
          Get.snackbar(
            'Payment Cancelled',
            'Your payment was cancelled.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          Navigator.pop(context);
        },
      ),
    ));
  }

  // send notication to seller
  void sendNotificationToVendor(
      String vendorId, String orderId, String buyerName) async {
    String vendorDeviceToken = "";
    // Fetch vendor device token
    DocumentSnapshot vendorSnapshot = await FirebaseFirestore.instance
        .collection("vendors")
        .doc(vendorId)
        .get();
    if (vendorSnapshot.exists) {
      Map<String, dynamic>? vendorData =
          vendorSnapshot.data() as Map<String, dynamic>?;
      if (vendorData != null && vendorData["vendorDeviceToken"] != null) {
        vendorDeviceToken = vendorData["vendorDeviceToken"].toString();
      }
    }

    // Print the vendorDeviceToken
    print("Vendor Device Token: $vendorDeviceToken");

    // Use the access token generated from the Node.js script
    final String accessToken = await fetchAccessToken();

    // Define the notification payload
    final Map<String, dynamic> notificationPayload = {
      "message": {
        "token": vendorDeviceToken,
        "notification": {
          "title": "New Order Placed",
          "body":
              "You have received a new order from $buyerName. Order ID: $orderId",
        },
        "data": {
          "id": "0",
          "buyerOrderId": orderId,
          "buyerName": buyerName,
        },
        "android": {
          "notification": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
          }
        },
      }
    };

    // Send the notification
    final response = await http.post(
      Uri.parse(
          'https://fcm.googleapis.com/v1/projects/easyshop-project-efff5/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(notificationPayload),
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProviderData = ref.watch(cartProvider);
    final totalAmountWithShipping =
        ref.read(cartProvider.notifier).totalPriceWithShipping();
    // final _stripePaymentController =
    //     ref.watch(stripePaymentController.notifier);

    TextStyle appBarStyle = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    TextStyle productNameStyle = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    TextStyle quantity = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    TextStyle urItemText = GoogleFonts.roboto(
      fontSize: 18,
      color: const Color(0xFF31363F),
      fontWeight: FontWeight.w700,
    );
    TextStyle selectPaymentText = GoogleFonts.roboto(
      fontSize: 18,
      color: const Color(0xFF31363F),
      fontWeight: FontWeight.w700,
    );

    InputDecoration inputDecoration(String hintText, IconData icon) {
      return InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(icon, color: const Color(0xFF0C2D57)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0C2D57), width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFCCCCCC), width: 1),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out', style: appBarStyle),
        backgroundColor: const Color(0xFF0C2D57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    decoration:
                        inputDecoration("Enter your address", Icons.home),
                    keyboardType: TextInputType.streetAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        inputDecoration("Enter your phone number", Icons.phone),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      } else if (!RegExp(r'^\d{10,15}$').hasMatch(value)) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        Icons.shopping_cart,
                        color: Color(0xFF31363F),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text("Your Item", style: urItemText),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cartProviderData.length,
                    itemBuilder: (context, index) {
                      final cartItem = cartProviderData.values.toList()[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Card(
                          color: const Color(0xFF31363F),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntrinsicHeight(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      cartItem.imageUrlList[0],
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(cartItem.productName,
                                            style: productNameStyle),
                                        // Additional product details
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey[800],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Center(
                                      child: Text('${cartItem.productQuantity}',
                                          style: quantity),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  // Payment method selection
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        const Icon(Icons.payment, color: Color(0xFF31363F)),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          "Select Payment Method",
                          style: selectPaymentText,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  ...paymentMethods.map((method) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPaymentMethod = method['method']!;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: _selectedPaymentMethod == method['method']
                              ? Colors.blue[50]
                              : Colors.white,
                          border: Border.all(
                            color: _selectedPaymentMethod == method['method']
                                ? Colors.blue
                                : Colors.grey[300]!,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              method['icon'] == 'cash'
                                  ? Icons.attach_money
                                  : method['icon'] == 'card'
                                      ? Icons.payment
                                      : Icons.paypal,
                              color: _selectedPaymentMethod == method['method']
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              method['label']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color:
                                    _selectedPaymentMethod == method['method']
                                        ? Colors.blue
                                        : Colors.grey[700],
                              ),
                            ),
                            const Spacer(),
                            if (_selectedPaymentMethod == method['method'])
                              const Icon(
                                Icons.check_circle,
                                color: Colors.blue,
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  // Display total price and place order button in a row
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width * 0.45,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0C2D57),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total + Fees: \$${totalAmountWithShipping.toStringAsFixed(2)}',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              if (_selectedPaymentMethod == 'cod') {
                                await _placeOrder();
                                setState(() {
                                  _isLoading = false;
                                });
                                Get.snackbar(
                                  'Order Placed',
                                  'Your order is placed.',
                                  snackPosition: SnackPosition.TOP,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              } else if (_selectedPaymentMethod == 'card') {
                                await _handleFlutterwavePayment(
                                    totalAmountWithShipping);
                                setState(() {
                                  _isLoading = false;
                                });
                                // Get.snackbar(
                                //   'Payment Success',
                                //   'Your payment was successful.',
                                //   snackPosition: SnackPosition.TOP,
                                //   backgroundColor: Colors.green,
                                //   colorText: Colors.white,
                                // );
                              } else if (_selectedPaymentMethod == 'paypal') {
                                // Pay with PayPal
                                await _handlePayPalPayment(
                                    totalAmountWithShipping);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(
                              MediaQuery.of(context).size.width * 0.45,
                              50,
                            ),
                            backgroundColor: const Color(0xFF0C2D57),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.forward,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Place Order',
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Placing Order... Please Wait',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
