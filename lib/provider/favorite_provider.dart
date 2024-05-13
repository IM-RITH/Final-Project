import 'package:easyshop/models/favorite_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});
  bool _hasViewedFavorite = false;

  void addToFavorite(
    String productName,
    double productPrice,
    List imageUrlList,
    double productDisPrice,
    String productId,
    // String productDescription,
    // int productQuantity,
    // String productSize,
    // String productColor,
  ) {
    state[productId] = FavoriteModel(
      productName: productName,
      productPrice: productPrice,
      imageUrlList: imageUrlList,
      productDisPrice: productDisPrice,
      productId: productId,
      // productDescription: productDescription,
      // productSize: productSize,
      // productColor: productColor
    );
    state = {...state};
    _hasViewedFavorite = false;
  }

  void setViewedFavorite(bool viewed) {
    _hasViewedFavorite = viewed;
  }

  bool get hasViewedFavorite => _hasViewedFavorite;
  // remove favorite product

  void removeFavorite(String productId) {
    state.remove(productId);
    state = {...state};
  }

  // remove all favorite from screen
  void clearAllFromScreen() {
    state.clear();
    state = {...state};
  }

  // get favorite item
  Map<String, FavoriteModel> get getFavoriteItem => state;
}
