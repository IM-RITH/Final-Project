import 'package:easyshop/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProductWidget extends ConsumerWidget {
  final dynamic productData;

  const ProductWidget({super.key, required this.productData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if the product is favorited
    final isFavorited =
        ref.watch(favoriteProvider).containsKey(productData['productId']);
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
                  productData['imageUrlList'][0],
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
                      ref
                          .read(favoriteProvider.notifier)
                          .removeFavorite(userId, productData['productId']);
                    } else {
                      ref.read(favoriteProvider.notifier).addToFavorite(
                            userId,
                            productData['productName'],
                            double.tryParse(
                                    productData['productPrice'].toString()) ??
                                0.0,
                            List<String>.from(productData['imageUrlList']),
                            double.tryParse(productData['productDisPrice']
                                    .toString()) ??
                                0.0,
                            productData['productId'],
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
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  SizedBox(width: 5),
                  Text(
                    "N/A",
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
                  productData['productName'],
                  style: productName,
                ),
                Text(
                  '\$${productData['productPrice']}',
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
