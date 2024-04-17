import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/models/category_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchCategory();
  }

  void _fetchCategory() {
    firestore.collection('categories').snapshots().listen(
      (QuerySnapshot querysnaphshot) {
        categories.assignAll(
          querysnaphshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return CategoryModel(
                categoryName: data['categoryName'],
                categoryImage: data['image']);
          }).toList(),
        );
      },
    );
  }
}
