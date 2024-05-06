import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductInStoreWidget extends StatefulWidget {
  final dynamic productInStoreData;

  const ProductInStoreWidget({super.key, required this.productInStoreData});

  @override
  State<ProductInStoreWidget> createState() => _ProductInStoreWidgetState();
}

class _ProductInStoreWidgetState extends State<ProductInStoreWidget> {
  @override
  Widget build(BuildContext context) {
    TextStyle productNameStyle = GoogleFonts.roboto(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );
    TextStyle productPriceStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Container(
      width: 180,
      height: 230,
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.1, 0.9],
          colors: [
            Colors.black.withOpacity(0.7),
            Colors.black87.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Align(
                alignment: Alignment.center,
                child: Image.network(
                  widget.productInStoreData['imageUrlList'][0],
                  fit: BoxFit.cover,
                  width: 90,
                  height: 110,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Action for adding to wishlist
                },
                child: const Icon(Icons.bookmark_border,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, color: Colors.yellow, size: 20),
                  SizedBox(width: 4),
                  Text(
                    "5.0",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            right: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.productInStoreData['productName'],
                    style: productNameStyle),
                Text('\$${widget.productInStoreData['productPrice']}',
                    style: productPriceStyle),
              ],
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  // Action for adding to cart
                },
                child: const Icon(Icons.shopping_cart,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
