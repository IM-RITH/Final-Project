import 'package:easyshop/provider/provider_home.dart';
import 'package:easyshop/views/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import "package:google_fonts/google_fonts.dart";

class SearchWidget extends ConsumerWidget {
  const SearchWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buyerId = ref.watch(buyerIdProvider);
    final productIdsAsyncValue = ref.watch(productIdsProvider);

    final BoxDecoration searchBoxDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 7,
          offset: const Offset(0, 3),
        ),
      ],
    );
    TextStyle hintStyle = GoogleFonts.roboto(
      color: Colors.grey,
      fontWeight: FontWeight.w500,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              decoration: searchBoxDecoration,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  TextField(
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      hintText: 'Search product ...',
                      hintStyle: hintStyle,
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.only(left: 50.0, bottom: 5.0),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    child: Icon(Icons.search, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              productIdsAsyncValue.when(
                data: (productIds) {
                  if (productIds.isNotEmpty) {
                    final productId = productIds
                        .first;
                    final vendorIdAsyncValue =
                        ref.watch(vendorIdProvider(productId));
                    final productNameAsyncValue =
                        ref.watch(productProvider(productId));

                    vendorIdAsyncValue.when(
                      data: (vendorId) {
                        productNameAsyncValue.when(
                          data: (product) {
                            Get.to(
                              () => ChatScreen(
                                vendorId: vendorId,
                                buyerId: buyerId,
                                productId: productId,
                                productName: product['storeName'],
                              ),
                            );
                          },
                          loading: () => print(
                              'Loading product name'), 
                          error: (e, _) =>
                              print('Error loading product name: $e'),
                        );
                      },
                      loading: () => print(
                          'Loading vendor ID'), 
                      error: (e, _) => print('Error loading vendor ID: $e'),
                    );
                  } else {
                    print(
                        'No products found'); 
                  }
                },
                loading: () => print(
                    'Loading product IDs'), 
                error: (e, _) => print('Error loading product IDs: $e'),
              );
            },
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.chat, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
