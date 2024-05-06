import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic productDetail;

  const ProductDetailScreen({super.key, required this.productDetail});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isBookmarked = false;
  int selectedImageIndex = 0;
  int? selectedSizeIndex;

  @override
  Widget build(BuildContext context) {
    List<String> imageUrls = [];
    if (widget.productDetail != null &&
        widget.productDetail['imageUrlList'] is List) {
      imageUrls = List<String>.from(widget.productDetail['imageUrlList']);
    }
    List<String> sizes =
        widget.productDetail != null && widget.productDetail['sizeList'] is List
            ? List<String>.from(widget.productDetail['sizeList'])
            : ['S', 'M', 'L', 'XL'];

    TextStyle productNameStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
    TextStyle productPriceStyle = GoogleFonts.poppins(
      fontSize: 21,
      color: const Color(0xFF012E87),
      fontWeight: FontWeight.w700,
    );
    TextStyle sizeTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
    TextStyle sizeGuideTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: const Color(0xFF012E87),
      fontWeight: FontWeight.w700,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF153167),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.productDetail != null
              ? widget.productDetail['productName'] ?? 'Product Details'
              : 'Product Details',
          style: GoogleFonts.roboto(
              fontSize: 16, color: Colors.white, fontWeight: FontWeight.w700),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                size: 25),
            onPressed: () {
              setState(() {
                isBookmarked = !isBookmarked;
              });
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 6,
                child: imageUrls.isNotEmpty
                    ? Image.network(
                        imageUrls[selectedImageIndex],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.network('https://via.placeholder.com/400',
                                fit: BoxFit.cover),
                      )
                    : Image.network('https://via.placeholder.com/400',
                        fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: imageUrls.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedImageIndex = index;
                  });
                },
                child: Container(
                  width: 70,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: selectedImageIndex == index
                          ? const Color(0xFF153167)
                          : Colors.grey,
                      width: 1,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.network(
                    imageUrls[index],
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.network(
                        'https://via.placeholder.com/100',
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
          const Divider(height: 20),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.productDetail != null
                      ? widget.productDetail['productName'] ?? 'No Product Name'
                      : 'No Product Name',
                  style: productNameStyle,
                ),
                Text(
                  '\$${widget.productDetail?['productPrice']?.toString() ?? '0'}',
                  style: productPriceStyle,
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Size',
                  style: sizeTextStyle,
                ),
                InkWell(
                  onTap: () {
                    print("size guide");
                  },
                  child: Text(
                    'Size Guide',
                    style: sizeGuideTextStyle,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              children: [
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: List<Widget>.generate(sizes.length, (int index) {
                    bool isSelected = selectedSizeIndex == index;
                    return ChoiceChip(
                      label: Text(
                        sizes[index],
                        style: GoogleFonts.roboto(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: const Color(0xFF4F7ED9),
                      onSelected: (bool selected) {
                        setState(() {
                          selectedSizeIndex = selected ? index : null;
                        });
                      },
                      backgroundColor: Colors.transparent,
                      elevation: 1,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                            color: selectedSizeIndex == index
                                ? Colors.transparent
                                : Colors.grey,
                            width: 1),
                      ),
                    );
                  }),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
