import 'package:easyshop/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductWidget extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductWidget({super.key, required this.productData});

  @override
  ConsumerState<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends ConsumerState<ProductWidget> {
  double averageRating = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAverageRating();
  }

  Future<void> fetchAverageRating() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('productReview')
          .where('productId', isEqualTo: widget.productData['productId'])
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        double totalRating = 0.0;
        for (var doc in querySnapshot.docs) {
          totalRating += doc['rating'];
        }
        setState(() {
          averageRating = totalRating / querySnapshot.docs.length;
        });
      } else {
        setState(() {
          averageRating = 0.0; // No ratings yet
        });
      }
    } catch (e) {
      print("Failed to fetch average rating: $e");
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if the product is favorited
    final isFavorited = ref
        .watch(favoriteProvider)
        .containsKey(widget.productData['productId']);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where userId is null, possibly show an error or redirect to login
      return const Center(
        child: Text('User not logged in'),
      );
    }

    TextStyle productName = GoogleFonts.roboto(
        fontSize: 15,
        color: Colors.white,
        height: 1.3,
        fontWeight: FontWeight.w700);
    TextStyle productPrice = GoogleFonts.poppins(
        fontSize: 15,
        color: const Color(0xFFF3CA52),
        height: 1.3,
        fontWeight: FontWeight.w700);

    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.all(5.0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.1, 0.9],
          colors: [
            const Color(0xFF0C2D57).withOpacity(1),
            const Color(0xFF0C2D57).withOpacity(1),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.transparent.withOpacity(0.5),
            blurRadius: 2,
            spreadRadius: 2,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 30,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Align(
                alignment: Alignment.center,
                child: Image.network(
                  widget.productData['imageUrlList'][0],
                  fit: BoxFit.contain,
                  width: 110,
                  height: 110,
                ),
              ),
            ),
          ),
          Positioned(
            top: 4,
            right: 5,
            child: SizedBox(
              width: 25,
              height: 25,
              child: Material(
                color: Colors.blue,
                shape: const CircleBorder(),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    if (isFavorited) {
                      ref.read(favoriteProvider.notifier).removeFavorite(
                          userId, widget.productData['productId']);
                    } else {
                      ref.read(favoriteProvider.notifier).addToFavorite(
                            userId,
                            widget.productData['productName'],
                            double.tryParse(widget.productData['productPrice']
                                    .toString()) ??
                                0.0,
                            List<String>.from(
                                widget.productData['imageUrlList']),
                            double.tryParse(widget
                                    .productData['productDisPrice']
                                    .toString()) ??
                                0.0,
                            widget.productData['productId'],
                          );
                      Get.snackbar(
                        'Favorites',
                        'Added to Favorites',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(5),
                        duration: const Duration(seconds: 2),
                      );
                    }
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Center(
                    child: Icon(
                        isFavorited ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 20),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              color: Colors.transparent,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  const SizedBox(width: 5),
                  Text(
                    isLoading
                        ? 'N/A'
                        : averageRating == 0.0
                            ? 'N/A'
                            : averageRating.toStringAsFixed(1),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productData['productName'],
                  style: productName,
                ),
                Text(
                  '\$${widget.productData['productPrice']}',
                  style: productPrice,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: SizedBox(
              width: 25,
              height: 25,
              child: Material(
                color: Colors.blue,
                shape: const CircleBorder(),
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // Add to cart or wishlist
                  },
                  splashColor: Colors.transparent,
                  child: const Center(
                    child: Icon(Icons.forward, color: Colors.white, size: 18),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
