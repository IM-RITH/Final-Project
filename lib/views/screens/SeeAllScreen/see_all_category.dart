import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/innerscreen/category_product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeAllCategoryScreen extends StatefulWidget {
  const SeeAllCategoryScreen({super.key});

  @override
  State<SeeAllCategoryScreen> createState() => _SeeAllCategoryScreenState();
}

class _SeeAllCategoryScreenState extends State<SeeAllCategoryScreen> {
  final Stream<QuerySnapshot> _categoryStream =
      FirebaseFirestore.instance.collection('categories').snapshots();

  @override
  Widget build(BuildContext context) {
    TextStyle appbar = GoogleFonts.poppins(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Categories',
          style: appbar,
        ),
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _categoryStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No categories found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  tileColor: Colors.grey[200],
                  leading: Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['image']),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                  ),
                  title: Text(
                    data['categoryName'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Explore Now',
                    style: TextStyle(color: Colors.black45),
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CategoryProductScreen(
                        categoryData: data,
                      );
                    }));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
