import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";

class SearchWidget extends StatelessWidget {
  const SearchWidget({super.key});

  // void _navigateToStoreScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) =>
  //             StoreScreen()), // Replace with your StoreScreen class
  //   );
  // }

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
            // onTap: () => _navigateToStoreScreen(context),
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
              child: const Icon(Icons.store, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
