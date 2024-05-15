import 'package:easyshop/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});

  bool _hasViewedCart = false;

  Future<void> loadCart(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart_$userId');
    if (cartData != null) {
      final Map<String, dynamic> decodedCart = jsonDecode(cartData);
      state = decodedCart.map((key, value) => MapEntry(
            key,
            CartModel.fromJson(value),
          ));
    }
  }

  Future<void> saveCart(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = state.map((key, value) => MapEntry(
          key,
          value.toJson(),
        ));
    prefs.setString('cart_$userId', jsonEncode(cartData));
  }

  void addProductToCart({
    required String userId,
    required String productName,
    required double productPrice,
    required List<String> imageUrlList,
    required int productQuantity,
    required String productSize,
    required String productColor,
    required double productDisPrice,
    required String productDescription,
    required String productId,
  }) {
    if (state.containsKey(productId)) {
      state = {
        ...state,
        productId: CartModel(
          productName: state[productId]!.productName,
          productPrice: state[productId]!.productPrice,
          imageUrlList: state[productId]!.imageUrlList,
          productQuantity: state[productId]!.productQuantity + 1,
          productSize: state[productId]!.productSize,
          productColor: state[productId]!.productColor,
          productDisPrice: state[productId]!.productDisPrice,
          productDescription: state[productId]!.productDescription,
          productId: state[productId]!.productId,
        ),
      };
    } else {
      state = {
        ...state,
        productId: CartModel(
          productName: productName,
          productPrice: productPrice,
          imageUrlList: imageUrlList,
          productQuantity: productQuantity,
          productSize: productSize,
          productColor: productColor,
          productDescription: productDescription,
          productDisPrice: productDisPrice,
          productId: productId,
        ),
      };
    }
    _hasViewedCart = false;
    saveCart(userId);
  }

  void setViewedCart(bool viewed) {
    _hasViewedCart = viewed;
  }

  bool get hasViewedCart => _hasViewedCart;

  void removeItem(String userId, String productId) {
    state.remove(productId);
    state = {...state};
    saveCart(userId);
  }

  void increaseProductCount(String userId, String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.productQuantity++;
    }
    state = {...state};
    saveCart(userId);
  }

  void decreaseProductCount(String userId, String productId) {
    if (state.containsKey(productId)) {
      int count = state[productId]!.productQuantity;
      if (count > 1) {
        state[productId]!.productQuantity--;
      }
    }
    state = {...state};
    saveCart(userId);
  }

  double totalPrice() {
    double totalAmount = 0.0;
    state.forEach((productId, cartItem) {
      totalAmount += cartItem.productQuantity * cartItem.productDisPrice;
    });
    return totalAmount;
  }

  Map<String, CartModel> get getCartItem => state;
}
