import 'package:easyshop/models/favorite_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  void addToFavorite(
    String productName,
    double productPrice,
    List imageUrlList,
    double productDisPrice,
    String productId,
  ) {
    state[productId] = FavoriteModel(
      productName: productName,
      productPrice: productPrice,
      imageUrlList: imageUrlList,
      productDisPrice: productDisPrice,
      productId: productId,
    );
    state = {...state};
  }

  // remove favorite product

  void removeFavorite(String productId) {
    state.remove(productId);
    state = {...state};
  }

  // get favorite item
  Map<String, FavoriteModel> get getFavoriteItem => state;
}
