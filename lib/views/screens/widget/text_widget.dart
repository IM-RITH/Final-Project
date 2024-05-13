import 'package:easyshop/views/screens/SeeAllScreen/all_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidget extends StatefulWidget {
  const TextWidget({super.key});

  @override
  State<TextWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle =
        GoogleFonts.roboto(fontSize: 19, fontWeight: FontWeight.bold);
    TextStyle seeAllStyle = GoogleFonts.roboto(
      fontSize: 19,
      fontWeight: FontWeight.bold,
      color: const Color(0xFF4F7ED9),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12.0, right: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Latest Product', style: headerStyle),
              GestureDetector(
                onTap: () {
                  Get.to(() => const AllProductScreen());
                },
                child: Text('See all', style: seeAllStyle),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
