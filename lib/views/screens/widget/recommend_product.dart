import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecommendProduct extends StatefulWidget {
  const RecommendProduct({super.key});

  @override
  State<RecommendProduct> createState() => _RecommendProductState();
}

class _RecommendProductState extends State<RecommendProduct> {
  final Stream<QuerySnapshot> _productStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong!"),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No products found'));
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                return ProductWidget(
                  productData: productData,
                );
              }),
        );
      },
    );
  }
}
