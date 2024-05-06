import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/SeeAllScreen/product_detail.dart';
import 'package:easyshop/views/screens/widget/product_widget.dart';
import 'package:flutter/material.dart';

class CategoryProductScreen extends StatefulWidget {
  final dynamic categoryData;

  const CategoryProductScreen({super.key, this.categoryData});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  // category detail (click from category see all)
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('category', isEqualTo: widget.categoryData['categoryName'])
        .snapshots();

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

              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
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
          );
        },
      ),
    );
  }
}
