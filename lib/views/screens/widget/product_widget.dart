import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductWidget extends StatefulWidget {
  final dynamic productData;

  const ProductWidget({super.key, required this.productData});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
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
            const Color(0xFF0C2D57).withOpacity(0.9),
            const Color(0xFF0C2D57).withOpacity(0.8),
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Align(
                alignment: Alignment.center,
                child: Image.network(
                  widget.productData['imageUrlList'][0],
                  fit: BoxFit.cover,
                  width: 85,
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
                    // Add to cart or wishlist
                  },
                  splashColor: Colors.transparent,
                  child: const Center(
                    child: Icon(Icons.bookmark_border,
                        color: Colors.white, size: 20),
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
