import 'package:easyshop/models/favorite_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final favoriteProvider =
    StateNotifierProvider<FavoriteNotifier, Map<String, FavoriteModel>>((ref) {
  return FavoriteNotifier();
});

class FavoriteNotifier extends StateNotifier<Map<String, FavoriteModel>> {
  FavoriteNotifier() : super({});

  bool _hasViewedFavorite = false;

  Future<void> loadFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = prefs.getString('favorites_$userId');
    if (favoriteData != null) {
      final Map<String, dynamic> decodedFavorites = jsonDecode(favoriteData);
      state = decodedFavorites.map((key, value) => MapEntry(
            key,
            FavoriteModel.fromJson(value),
          ));
    }
  }

  Future<void> saveFavorites(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteData = state.map((key, value) => MapEntry(
          key,
          value.toJson(),
        ));
    prefs.setString('favorites_$userId', jsonEncode(favoriteData));
  }

  void addToFavorite(
    String userId,
    String productName,
    double productPrice,
    List<String> imageUrlList,
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
    _hasViewedFavorite = false;
    saveFavorites(userId);
  }

  void setViewedFavorite(bool viewed) {
    _hasViewedFavorite = viewed;
  }

  bool get hasViewedFavorite => _hasViewedFavorite;

  void removeFavorite(String userId, String productId) {
    state.remove(productId);
    state = {...state};
    saveFavorites(userId);
  }

  void clearAllFromScreen(String userId) {
    state.clear();
    state = {...state};
    saveFavorites(userId);
  }

  Map<String, FavoriteModel> get getFavoriteItem => state;
}
