import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryProductScreen extends StatefulWidget {
  final dynamic categoryData;

  const CategoryProductScreen({super.key, this.categoryData});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryData['categoryName'])
        .snapshots();

    TextStyle productName = GoogleFonts.roboto(
        fontSize: 16,
        color: Colors.white,
        height: 1.3,
        fontWeight: FontWeight.w700);
    TextStyle productPrice = GoogleFonts.poppins(
        fontSize: 16,
        color: const Color(0xFFF3CA52),
        height: 1.3,
        fontWeight: FontWeight.w700);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryData["categoryName"],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No products found'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(5),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.95,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              String imageUrl =
                  data['imageUrlList'] is List ? data['imageUrlList'][0] : '';

              return Card(
                clipBehavior: Clip.antiAlias,
                color: const Color(0xFF343450),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.only(top: 1.0, bottom: 5.0),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                width: 90,
                                height: 120,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 0,
                              left: 8,
                            ),
                            child: Text(
                              data['productName'],
                              style: productName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(
                              '\$${data['productPrice']}',
                              style: productPrice,
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          color: Colors.transparent,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star,
                                  color: Colors.yellow, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                '${data['rating'] ?? "N/A"}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 5,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Material(
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                // Add to cart or wishlist
                              },
                              splashColor: Colors.transparent,
                              // highlightColor: Colors.transparent,
                              child: const Center(
                                child: Icon(Icons.bookmark_border,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 5,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: Material(
                            color: Colors.blue,
                            shape: const CircleBorder(),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                // Add to cart or wishlist
                              },
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              child: const Center(
                                child: Icon(Icons.add,
                                    color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
