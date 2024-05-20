import 'package:easyshop/views/screens/SeeAllScreen/all_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyshop/views/screens/fetchChat/fetch_chat.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            child: GestureDetector(
              onTap: () {
                Get.to(() => const AllProductScreen());
              },
              child: Container(
                height: 45,
                decoration: searchBoxDecoration,
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 50.0, bottom: 3.0),
                      child: Text(
                        'Search product ...',
                        style: hintStyle,
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
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.to(() => const FetchChat());
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
