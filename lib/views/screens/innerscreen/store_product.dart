import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/SeeAllScreen/product_detail.dart';
import 'package:easyshop/views/screens/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreProductScreen extends StatefulWidget {
  final dynamic storeData;

  const StoreProductScreen({super.key, required this.storeData});

  @override
  State<StoreProductScreen> createState() => _StoreProductScreenState();
}

class _StoreProductScreenState extends State<StoreProductScreen> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> storeStream = FirebaseFirestore.instance
        .collection('products')
        .where('storeName', isEqualTo: widget.storeData['storeName'])
        .snapshots();

    TextStyle storeNameStyle = GoogleFonts.roboto(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF474747),
      appBar: AppBar(
        title: Text(
          widget.storeData["storeName"],
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0C2D57),
                        border: Border.all(color: Colors.blue, width: 2),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: ClipOval(
                          child: Image.network(
                            widget.storeData["storeImage"] ?? '',
                            width: 80,
                            height: 110,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey,
                              child: Icon(Icons.store, size: 60),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.storeData["storeName"] ?? 'No Name',
                            style: storeNameStyle),
                        const SizedBox(width: 4),
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 15),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8, left: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Product List',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: storeStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.only(
                      top: 100,
                    ),
                    child: Center(
                        child: Text(
                      'No Products Found',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    )),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 6, left: 6),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: GridView.builder(
                      itemCount: snapshot.data!.docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.95,
                      ),
                      itemBuilder: (context, index) {
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProductDetailScreen(
                                productDetail: data,
                              );
                            }));
                          },
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          child: ProductWidget(productData: data),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
