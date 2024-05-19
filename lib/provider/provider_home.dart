import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Define providers for buyerId, productId, and productName
final buyerIdProvider = Provider<String>((ref) {
  return FirebaseAuth.instance.currentUser?.uid ?? '';
});

final productIdsProvider = StreamProvider<List<String>>((ref) async* {
  // Stream all product IDs from Firestore
  final productsCollection = FirebaseFirestore.instance.collection('products');
  final snapshotStream = productsCollection.snapshots();

  await for (var snapshot in snapshotStream) {
    yield snapshot.docs.map((doc) => doc.id).toList();
  }
});

final productProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, productId) async {
  // Fetch product details from Firestore
  final productDoc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();

  if (!productDoc.exists) {
    // Handle non-existent document
    throw Exception('Product document does not exist.');
  }

  return productDoc.data()!;
});

final vendorIdProvider =
    FutureProvider.family<String, String>((ref, productId) async {
  // Fetch vendorId from Firestore
  final productDoc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();

  if (!productDoc.exists) {
    // Handle non-existent document
    throw Exception('Product document does not exist.');
  }

  return productDoc['vendorId'] as String;
});

final vendorNameProvider =
    FutureProvider.family<String, String>((ref, vendorId) async {
  // Fetch vendorName from Firestore
  final vendorDoc = await FirebaseFirestore.instance
      .collection('vendors')
      .doc(vendorId)
      .get();

  if (!vendorDoc.exists) {
    // Handle non-existent document
    throw Exception('Vendor document does not exist.');
  }

  return vendorDoc['storeName'] as String;
});
