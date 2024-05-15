import 'package:easyshop/models/favorite_model.dart';
import 'package:easyshop/provider/favorite_provider.dart';
import 'package:easyshop/views/screens/SeeAllScreen/all_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookMarkScreen extends ConsumerStatefulWidget {
  const BookMarkScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BookMarkScreenState();
}

class _BookMarkScreenState extends ConsumerState<BookMarkScreen> {
  @override
  Widget build(BuildContext context) {
    final _favoriteProvider = ref.read(favoriteProvider.notifier);
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      // Handle the case where userId is null, possibly show an error or redirect to login
      return const Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    final Map<String, FavoriteModel> wishListItems =
        ref.watch(favoriteProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Wishlist",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            IconButton(
              onPressed: () {
                _favoriteProvider.clearAllFromScreen(userId);
              },
              icon: const Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0C2D57),
        elevation: 10,
      ),
      body: wishListItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 100,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Your wishlist is empty",
                    style: GoogleFonts.roboto(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Get.to(
                        () => const AllProductScreen(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Browse Products",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: wishListItems.length,
              itemBuilder: (context, index) {
                final wishListData = wishListItems.values.toList()[index];
                return Dismissible(
                  key: Key(wishListData.productId),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    _favoriteProvider.removeFavorite(
                        userId, wishListData.productId);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child:
                        const Icon(Icons.delete, color: Colors.white, size: 24),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Card(
                      color: const Color(0xFF102C57),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.network(
                            wishListData.imageUrlList[0],
                            width: 60,
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        title: Text(
                          wishListData.productName,
                          style: GoogleFonts.roboto(
                            textStyle: const TextStyle(color: Colors.white),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            Text(
                              'Price: \$${wishListData.productDisPrice.toString()}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              '\$${wishListData.productPrice}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: Colors.white54,
                                textStyle: const TextStyle(
                                    fontWeight: FontWeight.w600),
                                decoration: TextDecoration.lineThrough,
                              ),
                            )
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.white),
                          onPressed: () {
                            _favoriteProvider.removeFavorite(
                                userId, wishListData.productId);
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        onTap: () {
                          // Handle the onTap event, e.g., navigate to product details
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
