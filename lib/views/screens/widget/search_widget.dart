import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/views/screens/SeeAllScreen/all_product_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easyshop/views/screens/fetchChat/fetch_chat.dart';
import 'package:badges/badges.dart' as badges;

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
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chats')
                .where('isReadBuyer', isEqualTo: false)
                .where('buyerId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .where('senderId',
                    isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              int unreadCount = 0;
              if (snapshot.hasData) {
                unreadCount = snapshot.data!.docs.length;
              }
              return GestureDetector(
                onTap: () {
                  Get.to(() => const FetchChat());
                },
                child: badges.Badge(
                  badgeContent: Text(
                    '$unreadCount',
                    style: const TextStyle(color: Colors.white),
                  ),
                  showBadge: unreadCount > 0,
                  position: badges.BadgePosition.topEnd(top: -5, end: -5),
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
              );
            },
          ),
        ],
      ),
    );
  }
}
