import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/provider/cart_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

class CheckOutScreen extends ConsumerStatefulWidget {
  const CheckOutScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends ConsumerState<CheckOutScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedPaymentMethod = 'cod'; // Default to cash on delivery

  // Define the payment methods available
  final List<Map<String, String>> paymentMethods = [
    {'method': 'cod', 'label': 'Cash on Delivery', 'icon': 'cash'},
    {'method': 'stripe', 'label': 'Pay with Stripe', 'icon': 'card'},
  ];

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartProviderData = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).totalPrice();

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: inputDecoration("Enter your address", Icons.home),
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _phoneController,
              decoration:
                  inputDecoration("Enter your phone number", Icons.phone),
              keyboardType: TextInputType.phone,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            : Icons.payment,
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
                          color: _selectedPaymentMethod == method['method']
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
                      vertical: 13,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Total: \$${totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      DocumentSnapshot userDocs = await fireStore
                          .collection('buyers')
                          .doc(auth.currentUser!.uid)
                          .get();

                      for (var key in _cartProvider.getCartItem.keys) {
                        final item = _cartProvider.getCartItem[key];
                        final productDoc = await fireStore
                            .collection('products')
                            .doc(item!.productId)
                            .get();
                        final vendorId = productDoc['vendorId'];

                        final orderId = const Uuid().v4();
                        await fireStore.collection('orders').doc(orderId).set({
                          'orderId': orderId,
                          'productId': item.productId,
                          'productName': item.productName,
                          'quantity': item.productQuantity,
                          'price': item.productQuantity * item.productDisPrice,
                          'buyerName': (userDocs.data()
                              as Map<String, dynamic>)['username'],
                          'buyerEmail': (userDocs.data()
                              as Map<String, dynamic>)['email'],
                          'buyerId': auth.currentUser!.uid,
                          'vendorId': vendorId,
                          'status': 'pending',
                          'date': DateTime.now(),
                          'productSize': item.productSize,
                          'productColor': item.productColor,
                          'productImage': item.imageUrlList,
                        });
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
                            fontSize: 16,
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
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
