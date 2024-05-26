import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String buyerName;
  final String buyerEmail;
  final String buyerId;
  final String productId;
  final double rating;
  final String review;
  final Timestamp timeStamp;

  Review({
    required this.buyerName,
    required this.buyerEmail,
    required this.buyerId,
    required this.productId,
    required this.rating,
    required this.review,
    required this.timeStamp,
  });

  factory Review.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Review(
      buyerName: data['buyerName'] ?? '',
      buyerEmail: data['buyerEmail'] ?? '',
      buyerId: data['buyerId'] ?? '',
      productId: data['productId'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      review: data['review'] ?? '',
      timeStamp: data['timeStamp'] ?? Timestamp.now(),
    );
  }
}
