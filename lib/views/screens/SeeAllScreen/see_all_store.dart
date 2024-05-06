import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/innerscreen/store_product.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SeeAllStoreScreen extends StatefulWidget {
  const SeeAllStoreScreen({super.key});

  @override
  State<SeeAllStoreScreen> createState() => _SeeAllStoreScreenState();
}

class _SeeAllStoreScreenState extends State<SeeAllStoreScreen> {
  final Stream<QuerySnapshot> _storeStream =
      FirebaseFirestore.instance.collection('vendors').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Stores',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _storeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No Store Found'));
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
                  tileColor: Colors.deepPurple[50],
                  leading: Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['storeImage']),
                        fit: BoxFit.contain,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  title: Text(
                    data['storeName'],
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  subtitle: Row(
                    children: [
                      Icon(Icons.arrow_forward,
                          color: Colors.deepPurple, size: 20),
                      SizedBox(width: 4),
                      Text(
                        'Shop Now!',
                        style: TextStyle(color: Colors.deepPurple),
                      ),
                    ],
                  ),
                  onTap: () {
                    // use store product (inner screen file)
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return StoreProductScreen(
                        storeData: data,
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
