import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Function to delete order from Firestore
  Future<void> _deleteOrder(String orderId) async {
    await FirebaseFirestore.instance.collection('orders').doc(orderId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance
        .collection('orders')
        .where('buyerId', isEqualTo: auth.currentUser!.uid)
        .where('delivered', isEqualTo: false)
        .orderBy('date', descending: true)
        .snapshots();
    TextStyle appbarText = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: appbarText,
        ),
        backgroundColor: const Color(0xFF0C2D57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Order found'));
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;

              String imageUrl = (data['productImage'] is List &&
                      data['productImage'].isNotEmpty)
                  ? data['productImage'][0]
                  : '';

              return Card(
                color: const Color(0xFF102C57),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      imageUrl.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                imageUrl,
                                width: 70,
                                height: 70,
                                fit: BoxFit.contain,
                              ),
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[200],
                              child: const Icon(Icons.image, size: 50),
                            ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${data['productName']}',
                              style: GoogleFonts.poppins(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${data['totalPrice']}',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OrderDetailsScreen(
                                      orderData: data,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'See Order Details',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // IconButton(
                      //   icon: const Icon(Icons.delete, color: Colors.red),
                      //   onPressed: () {
                      //     _showDeleteConfirmationDialog(context, document.id);
                      //   },
                      // ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> orderData;

  const OrderDetailsScreen({Key? key, required this.orderData})
      : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  double rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool hasReviewed = false;

  @override
  void initState() {
    super.initState();
    _checkIfReviewed();
  }

  Future<void> _checkIfReviewed() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final querySnapshot = await FirebaseFirestore.instance
        .collection('productReview')
        .where('productId', isEqualTo: widget.orderData['productId'])
        .where('buyerId', isEqualTo: user.uid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        hasReviewed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String imageUrl = (widget.orderData['productImage'] is List &&
            widget.orderData['productImage'].isNotEmpty)
        ? widget.orderData['productImage'][0]
        : '';

    List<dynamic> processingSteps = [];
    if (widget.orderData['processing'] is List) {
      processingSteps = widget.orderData['processing'] ?? [];
    }
    int currentStep = widget.orderData['processingStep'] ?? 0;

    bool isDelivered = widget.orderData['delivered'] ?? false;

    // Convert Timestamp to DateTime and format it as a string
    Timestamp timestamp = widget.orderData['date'] ?? Timestamp.now();
    DateTime date = timestamp.toDate();
    String orderDate = DateFormat('hh:mm aa, dd-MM-yyyy').format(date);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Order Details',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: const Color(0xFF0C2D57),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageUrl.isNotEmpty
                  ? Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Center(
                      child: Container(
                        width: 150,
                        height: 150,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 50),
                      ),
                    ),
              const SizedBox(height: 5),
              Text(
                widget.orderData['productName'],
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        context,
                        'Quantity',
                        widget.orderData['quantity'].toString(),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context,
                        'Total Price',
                        '\$${widget.orderData['totalPrice']}',
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context,
                        'Payment Method',
                        widget.orderData['paymentMethod'],
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context,
                        'Order Date',
                        orderDate,
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(
                        context,
                        'Status',
                        (widget.orderData['accept'] ?? false)
                            ? 'Order confirmed'
                            : 'Not yet confirmed',
                        (widget.orderData['accept'] ?? false)
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Processing:',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              if (processingSteps.isNotEmpty &&
                                  currentStep < processingSteps.length)
                                Flexible(
                                  child: Text(
                                    processingSteps[currentStep],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Delivered: ',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                          ),
                          Text(
                            isDelivered ? 'Delivered' : 'Not Yet',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDelivered ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                      if (isDelivered && !hasReviewed)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              'Rate this product:',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RatingBar.builder(
                              initialRating: 0,
                              minRating: 1,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (value) {
                                rating = value;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _reviewController,
                              maxLines: 2,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.rate_review,
                                    color: Colors.blue),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Colors.blue, width: 2),
                                ),
                                labelText: 'Write your review',
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.blueAccent,
                                ),
                                hintText: 'Share your experience...',
                                hintStyle: GoogleFonts.poppins(
                                  color: Colors.blueGrey,
                                ),
                                filled: true,
                                fillColor: Colors.blue.shade50,
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () async {
                                if (_reviewController.text.isEmpty) {
                                  Get.snackbar(
                                    'Error',
                                    'Please write your review',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                  return;
                                }
                                final review = _reviewController.text;
                                Get.showSnackbar(
                                  const GetSnackBar(
                                    message: 'Submitting review...',
                                    showProgressIndicator: true,
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                await FirebaseFirestore.instance
                                    .collection("productReview")
                                    .doc(widget.orderData["orderId"])
                                    .set({
                                  "reviewId": widget.orderData["orderId"],
                                  "productId": widget.orderData["productId"],
                                  "buyerName": widget.orderData["buyerName"],
                                  "buyerEmail": widget.orderData["buyerEmail"],
                                  "buyerId":
                                      FirebaseAuth.instance.currentUser!.uid,
                                  "rating": rating,
                                  "review": review,
                                  "timeStamp": Timestamp.now(),
                                }).then((_) {
                                  Get.snackbar(
                                    'Success',
                                    'Review submitted successfully',
                                    snackPosition: SnackPosition.TOP,
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white,
                                  );
                                  _reviewController.clear();
                                  setState(() {
                                    rating = 0;
                                    hasReviewed = true;
                                  });
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    Navigator.of(context).pop();
                                  });
                                }).catchError((error) {
                                  Get.snackbar(
                                    'Error',
                                    'Failed to submit review',
                                    snackPosition: SnackPosition.BOTTOM,
                                    backgroundColor: Colors.red,
                                    colorText: Colors.white,
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF102C57),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Submit Review',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String value,
      [Color? valueColor]) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black87,
            ),
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
