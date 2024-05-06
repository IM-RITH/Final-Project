import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easyshop/models/store__model.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  RxList<StoreModel> stores = <StoreModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchStore();
  }

  void _fetchStore() {
    firestore.collection('vendors').snapshots().listen(
      (QuerySnapshot querysnaphshot) {
        stores.assignAll(
          querysnaphshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return StoreModel(
                storeName: data['storeName'], storeImage: data['storeImage']);
          }).toList(),
        );
      },
    );
  }
}
