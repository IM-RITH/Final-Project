import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/SeeAllScreen/product_detail.dart';
import 'package:easyshop/views/screens/widget/product_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllProductScreen extends StatefulWidget {
  const AllProductScreen({super.key});

  @override
  State<AllProductScreen> createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final Stream<QuerySnapshot> _allProductStream =
      FirebaseFirestore.instance.collection('products').snapshots();
  TextEditingController searchController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController maxPriceController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  String searchQuery = "";
  double? minPrice;
  double? maxPrice;
  String location = "";

  @override
  void initState() {
    super.initState();
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    minPriceController.dispose();
    maxPriceController.dispose();
    locationController.dispose();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            'Filter Products',
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF153167),
              ),
            ),
          ),
          content: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C2D57), Color(0xFF0C2D57)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: minPriceController,
                    decoration: InputDecoration(
                      labelText: 'Min Price',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon:
                          const Icon(Icons.attach_money, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: maxPriceController,
                    decoration: InputDecoration(
                      labelText: 'Max Price',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon:
                          const Icon(Icons.attach_money, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon:
                          const Icon(Icons.location_on, color: Colors.white),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(
                'Close',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  minPrice = minPriceController.text.isEmpty
                      ? null
                      : double.tryParse(minPriceController.text);
                  maxPrice = maxPriceController.text.isEmpty
                      ? null
                      : double.tryParse(maxPriceController.text);
                  location = locationController.text.toLowerCase();
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF153167),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: Text(
                'Apply',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Products',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Search products...",
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _allProductStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final products = snapshot.data!.docs.where((doc) {
                  Map<String, dynamic> data =
                      doc.data()! as Map<String, dynamic>;
                  String name = data['productName'].toString().toLowerCase();
                  double price = data['productPrice']?.toDouble() ?? 0.0;
                  String productLocation =
                      data['city']?.toString().toLowerCase() ?? "";

                  bool matchesSearchQuery =
                      searchQuery.isEmpty || name.contains(searchQuery);
                  bool matchesMinPrice = minPrice == null || price >= minPrice!;
                  bool matchesMaxPrice = maxPrice == null || price <= maxPrice!;
                  bool matchesLocation =
                      location.isEmpty || productLocation.contains(location);

                  return matchesSearchQuery &&
                      matchesMinPrice &&
                      matchesMaxPrice &&
                      matchesLocation;
                }).toList();

                if (products.isEmpty) {
                  return const Center(
                      child: Text(
                    'No Product Found',
                  ));
                }

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 5,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = products[index];
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductDetailScreen(productDetail: data);
                        }));
                      },
                      child: ProductWidget(productData: data),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
