import 'package:easyshop/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
    final cartProviderData = ref.read(cartProvider);
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
                  const Icon(Icons.check_box_outline_blank_sharp),
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
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: paymentMethods.length,
                itemBuilder: (context, index) {
                  final paymentMethod = paymentMethods[index];
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedPaymentMethod = paymentMethod['method']!;
                      });
                    },
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      width: 170,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _selectedPaymentMethod == paymentMethod['method']
                            ? Colors.green
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            paymentMethod['icon'] == 'cash'
                                ? Icons.attach_money
                                : Icons.payment,
                            size: 30,
                            color: _selectedPaymentMethod ==
                                    paymentMethod['method']
                                ? Colors.white
                                : Colors.black,
                          ),
                          Text(
                            paymentMethod['label']!,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _selectedPaymentMethod ==
                                      paymentMethod['method']
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0C2D57),
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 130),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Place Order',
                    style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
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
