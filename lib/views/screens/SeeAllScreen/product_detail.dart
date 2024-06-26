import 'package:easyshop/models/favorite_model.dart';
import 'package:easyshop/provider/cart_provider.dart';
import 'package:easyshop/provider/favorite_provider.dart';
import 'package:easyshop/provider/select_color.dart';
import 'package:easyshop/provider/select_size_provider.dart';
import 'package:easyshop/views/screens/SeeAllScreen/rating_review_screen.dart';
import 'package:easyshop/views/screens/innerscreen/store_product.dart';
import 'package:easyshop/views/screens/main_screen/utils/utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productDetail;

  const ProductDetailScreen({super.key, required this.productDetail});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  bool isBookmarked = false;
  int selectedImageIndex = 0;
  int? selectedSizeIndex;
  int? selectedColorIndex;
  double averageRating = 0;
  int totalReviews = 0;

  @override
  void initState() {
    super.initState();
    // Check if the productDetail is an instance of FavoriteModel
    if (widget.productDetail is FavoriteModel) {
      isBookmarked = ref
          .read(favoriteProvider)
          .containsKey(widget.productDetail.productId);
    } else if (widget.productDetail is Map) {
      isBookmarked = ref
          .read(favoriteProvider)
          .containsKey(widget.productDetail['productId']);
    }
    fetchReviews();
  }

  Future<void> fetchReviews() async {
    final reviewsSnapshot = await FirebaseFirestore.instance
        .collection('productReview')
        .where('productId', isEqualTo: widget.productDetail['productId'])
        .get();

    if (reviewsSnapshot.docs.isNotEmpty) {
      double totalRating = 0;
      for (var doc in reviewsSnapshot.docs) {
        totalRating += doc['rating'];
      }
      setState(() {
        totalReviews = reviewsSnapshot.docs.length;
        averageRating =
            double.parse((totalRating / totalReviews).toStringAsFixed(2));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    final favorites = ref.watch(favoriteProvider);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where userId is null, possibly show an error or redirect to login
      return const Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    isBookmarked = favorites.containsKey(widget.productDetail['productId']);

    // select size product
    final selectSize = ref.watch(
      selectSizeProvider(
        widget.productDetail['productId'],
      ),
    );

    // select color
    final selectColor = ref.watch(
      selectColorProvider(
        widget.productDetail['productId'],
      ),
    );

    List<String> imageUrls = [];
    if (widget.productDetail != null &&
        widget.productDetail['imageUrlList'] is List) {
      imageUrls = List<String>.from(widget.productDetail['imageUrlList']);
    }
    List<String> sizes =
        widget.productDetail != null && widget.productDetail['sizeList'] is List
            ? List<String>.from(widget.productDetail['sizeList'])
            : ['S', 'M', 'L', 'XL'];
    List<String> colors = widget.productDetail != null &&
            widget.productDetail['colorList'] is List
        ? List<String>.from(widget.productDetail['colorList'])
        : ['Black', 'Green', 'White'];
    String description = widget.productDetail['productDescription'] ??
        "No description available";
    String storeName = widget.productDetail['storeName'] ?? 'No Name Store';
    String storeImage =
        widget.productDetail['storeImage'] ?? 'https://via.placeholder.com/150';

    TextStyle productNameStyle = GoogleFonts.roboto(
      fontSize: 20,
      color: Colors.black87,
      fontWeight: FontWeight.bold,
    );
    TextStyle instockStyle = GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.black38,
      fontWeight: FontWeight.w600,
    );
    TextStyle productPriceStyle = GoogleFonts.poppins(
      fontSize: 21,
      color: const Color(0xFF012E87),
      fontWeight: FontWeight.w700,
    );
    TextStyle productDisPriceStyle = GoogleFonts.poppins(
      fontSize: 19,
      color: Colors.grey,
      decoration: TextDecoration.lineThrough,
      fontWeight: FontWeight.w600,
    );
    TextStyle sizeTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
    TextStyle sizeGuideTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.black38,
    );
    TextStyle descriptionSubTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
    TextStyle descriptionTextStyle = GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.black54,
      fontWeight: FontWeight.w600,
    );
    TextStyle reviewSubTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
    TextStyle storeNameTextStyle = GoogleFonts.roboto(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w700,
    );
    TextStyle addAndChatTextStyle = GoogleFonts.roboto(
      fontSize: 15,
      color: Colors.white,
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

              if (isBookmarked) {
                double productPrice = double.tryParse(
                        widget.productDetail['productPrice'].toString()) ??
                    0.0;
                double productDisPrice = double.tryParse(
                        widget.productDetail['productDisPrice'].toString()) ??
                    0.0;
                List<String> imageUrlList =
                    List<String>.from(widget.productDetail['imageUrlList']);

                _favoriteProvider.addToFavorite(
                  userId,
                  widget.productDetail['productName'],
                  productPrice,
                  imageUrlList,
                  productDisPrice,
                  widget.productDetail['productId'],
                );
                Get.snackbar(
                  'Favorites',
                  'Added to Favorites',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin: const EdgeInsets.all(5),
                  duration: const Duration(seconds: 2),
                );
              } else {
                _favoriteProvider.removeFavorite(
                    userId, widget.productDetail['productId']);
                Get.snackbar(
                  'Favorites',
                  'Removed from Favorites',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red,
                  colorText: Colors.white,
                  borderRadius: 10,
                  margin: const EdgeInsets.all(5),
                  duration: const Duration(seconds: 2),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color(0xFF153448),
              child: Center(
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
            ),
            SizedBox(
              height: 60,
              child: Container(
                color: Colors.white,
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
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedImageIndex == index
                              ? const Color(0xFF153167)
                              : Colors.green,
                          width: 1,
                        ),
                        color: const Color(0xFF153167),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          imageUrls[index],
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.network('https://via.placeholder.com/100',
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.productDetail != null
                            ? widget.productDetail['productName'] ??
                                'No Product Name'
                            : 'No Product Name',
                        style: productNameStyle,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: widget.productDetail != null &&
                                  widget.productDetail['instock'] == 'In Stock'
                              ? const Color(0xFF8A9418)
                              : Colors.redAccent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Text(
                          widget.productDetail != null
                              ? widget.productDetail['instock'] ??
                                  'Out Of Stock'
                              : 'No Stock',
                          style: instockStyle.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        '\$${widget.productDetail?['productDisPrice']?.toString() ?? '0'}',
                        style: productPriceStyle,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${widget.productDetail?['productPrice']?.toString() ?? '0'}',
                        style: productDisPriceStyle,
                      ),
                    ],
                  )
                ],
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Size',
                        style: sizeTextStyle,
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      const Icon(
                        Icons.straight,
                        size: 20,
                        color: Color(0xFF153448),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 4.0,
                    children: List<Widget>.generate(sizes.length, (int index) {
                      bool isSelected = selectSize == sizes[index];
                      return ChoiceChip(
                        label: Text(
                          sizes[index],
                          style: GoogleFonts.roboto(
                            color: isSelected ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: const Color(0xFF4F7ED9),
                        onSelected: (bool selected) {
                          if (selected) {
                            ref
                                .read(selectSizeProvider(
                                        widget.productDetail['productId'])
                                    .notifier)
                                .selectSize(sizes[index]);
                          } else {
                            ref
                                .read(selectSizeProvider(
                                        widget.productDetail['productId'])
                                    .notifier)
                                .selectSize("");
                          }
                        },
                        backgroundColor: isSelected
                            ? const Color(0xFF4F7ED9)
                            : const Color(0xFFE0E0E0),
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                              color:
                                  isSelected ? Colors.transparent : Colors.grey,
                              width: 1),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Color',
                        style: sizeTextStyle,
                      ),
                      const SizedBox(
                        width: 6.0,
                      ),
                      const Icon(
                        Icons.color_lens_sharp,
                        size: 20,
                        color: Color(0xFF153448),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  Wrap(
                    spacing: 5.0,
                    runSpacing: 4.0,
                    children: List<Widget>.generate(colors.length, (int index) {
                      bool isSelectedColor = selectColor == colors[index];
                      return ChoiceChip(
                        label: Text(
                          colors[index],
                          style: GoogleFonts.roboto(
                            color:
                                isSelectedColor ? Colors.white : Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelectedColor,
                        selectedColor: const Color(0xFF4F7ED9),
                        onSelected: (bool selectedColor) {
                          if (selectedColor) {
                            ref
                                .read(selectColorProvider(
                                        widget.productDetail['productId'])
                                    .notifier)
                                .selectColor(colors[index]);
                          } else {
                            ref
                                .read(selectColorProvider(
                                        widget.productDetail['productId'])
                                    .notifier)
                                .selectColor("");
                          }
                        },
                        backgroundColor: isSelectedColor
                            ? const Color(0xFF4F7ED9)
                            : const Color(0xFFE0E0E0),
                        elevation: 1,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(
                              color: isSelectedColor
                                  ? Colors.transparent
                                  : Colors.grey,
                              width: 1),
                        ),
                      );
                    }),
                  )
                ],
              ),
            ),

            // descrip header
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Row(
                children: [
                  Text(
                    'Description',
                    style: descriptionSubTextStyle,
                  ),
                  const SizedBox(
                    width: 6.0,
                  ),
                  const Icon(
                    Icons.info,
                    size: 20,
                    color: Color(0xFF153448),
                  )
                ],
              ),
            ),
            // description text
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Text(
                description,
                style: descriptionTextStyle.copyWith(
                  height: 1.2,
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.justify,
              ),
            ),
            // review product
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
              child: Row(
                children: [
                  Text(
                    'Reviews ($totalReviews)',
                    style: reviewSubTextStyle,
                  ),
                  const Spacer(),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(
                    width: 2,
                  ),
                  Text(
                    '$averageRating',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return RatingReviewScreen(
                              productId: widget.productDetail['productId']);
                        },
                      ));
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // store detail
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF0C2D57),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: ClipOval(
                      child: Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          storeImage,
                          width: 45,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              storeName,
                              style: storeNameTextStyle,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 15,
                            )
                          ],
                        ),
                        Text(
                          "View Store",
                          style: GoogleFonts.roboto(
                              color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var storeName = widget.productDetail['storeName'];
                      var storeImage = widget.productDetail['storeImage'];
                      if (storeName != null && storeImage != null) {
                        // Prepare the store data map
                        Map<String, dynamic> storeData = {
                          'storeName': storeName,
                          'storeImage': storeImage
                        };

                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return StoreProductScreen(storeData: storeData);
                        }));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Store details are not available."),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // chat button
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.shopping_cart),
                  label: Text(
                    "Add to Cart",
                    style: addAndChatTextStyle,
                  ),
                  onPressed: () {
                    // Check if size is selected
                    if (selectSize.isEmpty) {
                      Get.snackbar(
                        'Size Required',
                        'Please select a size.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(5),
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    // Check if color is selected
                    if (selectColor.isEmpty) {
                      Get.snackbar(
                        'Color Required',
                        'Please select a color.',
                        snackPosition: SnackPosition.TOP,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(5),
                        duration: const Duration(seconds: 2),
                      );
                      return;
                    }

                    _cartProvider.addProductToCart(
                      userId: userId,
                      productName: widget.productDetail['productName'],
                      productPrice: widget.productDetail['productPrice'],
                      imageUrlList: List<String>.from(
                          widget.productDetail['imageUrlList']),
                      productQuantity: 1,
                      productSize: selectSize,
                      productColor: selectColor,
                      productDisPrice: widget.productDetail['productDisPrice'],
                      productDescription:
                          widget.productDetail['productDescription'],
                      productId: widget.productDetail['productId'],
                      shippingFees: widget.productDetail['shippingFees'],
                    );

                    Get.snackbar(
                      'Product',
                      'Added Successfully',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      borderRadius: 10,
                      margin: const EdgeInsets.all(5),
                      duration: const Duration(seconds: 2),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0C2D57),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.message),
                  label: Text("Chat with Store", style: addAndChatTextStyle),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return ChatScreen(
                          vendorId: widget.productDetail['vendorId'],
                          buyerId: FirebaseAuth.instance.currentUser!.uid,
                          productId: widget.productDetail['productId'],
                          productName: widget.productDetail['productName'],
                        );
                      },
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A9418),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
