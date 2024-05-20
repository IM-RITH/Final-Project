import 'package:easyshop/controller/category_controller.dart';
import 'package:easyshop/views/screens/SeeAllScreen/see_all_category.dart';
import 'package:easyshop/views/screens/innerscreen/category_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final CategoryController _categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    TextStyle cateName = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    );
    TextStyle headerStyle =
        GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.bold);
    TextStyle seeAllStyle = GoogleFonts.poppins(
      fontSize: 19,
      fontWeight: FontWeight.w600,
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
                Text('Category', style: headerStyle),
                GestureDetector(
                  onTap: () {
                    Get.to(
                      () => const SeeAllCategoryScreen(),
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
              itemCount: _categoryController.categories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      var category = _categoryController.categories[index];
                      return CategoryProductScreen(
                        categoryData: {'categoryName': category.categoryName},
                      );
                    }));
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
                                  _categoryController
                                      .categories[index].categoryImage,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _categoryController.categories[index].categoryName,
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
