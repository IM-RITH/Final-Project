import 'package:easyshop/controller/store_controller.dart';
import 'package:easyshop/views/screens/SeeAllScreen/see_all_store.dart';
import 'package:easyshop/views/screens/innerscreen/store_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreWidget extends StatefulWidget {
  const StoreWidget({super.key});

  @override
  State<StoreWidget> createState() => _StoreWidgetState();
}

class _StoreWidgetState extends State<StoreWidget> {
  final StoreController _storeController = Get.find<StoreController>();

  @override
  Widget build(BuildContext context) {
    TextStyle cateName = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    );
    TextStyle headerStyle =
        GoogleFonts.roboto(fontSize: 19, fontWeight: FontWeight.bold);
    TextStyle seeAllStyle = GoogleFonts.roboto(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF4F7ED9),
    );

    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Latest Store', style: headerStyle),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const SeeAllStoreScreen(),
                    );
                  },
                  child: Text('See all', style: seeAllStyle),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 90,
            child: ListView.builder(
              itemCount: _storeController.stores.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          var store = _storeController.stores[index];
                          return StoreProductScreen(
                            storeData: {
                              'storeName': store.storeName,
                              'storeImage': store.storeImage
                            },
                          );
                        },
                      ),
                    );
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 10, top: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: const Color(0xFF4F7ED9), width: 2),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Align(
                                alignment: Alignment.center,
                                child: Image.network(
                                  _storeController.stores[index].storeImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _storeController.stores[index].storeName,
                          style: cateName,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
