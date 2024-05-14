import 'package:easyshop/models/favorite_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({}) {
    _loadFavorites();
  }

  bool _hasViewedFavorite = false;

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getString('favorites');
    if (favoriteData != null) {
      final Map<String, dynamic> decodedFavorites = jsonDecode(favoriteData);
      state = decodedFavorites.map((key, value) => MapEntry(
            key,
            FavoriteModel.fromJson(value),
          ));
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = state.map((key, value) => MapEntry(
          key,
          value.toJson(),
        ));
    prefs.setString('favorites', jsonEncode(favoriteData));
  }

  void addToFavorite(
    String productName,
    double productPrice,
    List imageUrlList,
    double productDisPrice,
    String productId,
    // String vendorId,
  ) {
    state[productId] = FavoriteModel(
      productName: productName,
      productPrice: productPrice,
      imageUrlList: imageUrlList,
      productDisPrice: productDisPrice,
      productId: productId,
      // vendorId: vendorId,
    );
    state = {...state};
    _hasViewedFavorite = false;
    _saveFavorites();
  }

  void setViewedFavorite(bool viewed) {
    _hasViewedFavorite = viewed;
  }

  bool get hasViewedFavorite => _hasViewedFavorite;

  void removeFavorite(String productId) {
    state.remove(productId);
    state = {...state};
    _saveFavorites();
  }

  void clearAllFromScreen() {
    state.clear();
    state = {...state};
    _saveFavorites();
  }

  Map<String, FavoriteModel> get getFavoriteItem => state;
}
