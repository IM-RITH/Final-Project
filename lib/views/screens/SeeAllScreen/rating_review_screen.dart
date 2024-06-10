import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/models/rating_review.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingReviewScreen extends StatefulWidget {
  final String productId;

  const RatingReviewScreen({super.key, required this.productId});

  @override
  State<RatingReviewScreen> createState() => _RatingReviewScreenState();
}

class _RatingReviewScreenState extends State<RatingReviewScreen> {
  Future<List<Review>> _fetchReviews() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('productReview')
        .where('productId', isEqualTo: widget.productId)
        .get();

    return querySnapshot.docs.map((doc) => Review.fromFirestore(doc)).toList();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle appbarText = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );
    TextStyle buyerNameText = GoogleFonts.poppins(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
    TextStyle reviewText = GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    );
    TextStyle dateText = GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.grey,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ratings and Reviews',
          style: appbarText,
        ),
        backgroundColor: const Color(0xFF0C2D57),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Review>>(
        future: _fetchReviews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching reviews'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No reviews yet'));
          }

          List<Review> reviews = snapshot.data!;

          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              Review review = reviews[index];

              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          radius: 25,
                          child: Text(
                            review.buyerName[0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                review.buyerName,
                                style: buyerNameText,
                              ),
                              const SizedBox(height: 5),
                              RatingBarIndicator(
                                rating: review.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(review.timeStamp.toDate()),
                                style: dateText,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                review.review,
                                style: reviewText,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
