import 'package:easyshop/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({}) {
    _loadCart();
  }

  bool _hasViewedCart = false;

  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('cart');
    if (cartData != null) {
      final Map<String, dynamic> decodedCart = jsonDecode(cartData);
      state = decodedCart.map((key, value) => MapEntry(
            key,
            CartModel.fromJson(value),
          ));
    }
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = state.map((key, value) => MapEntry(
          key,
          value.toJson(),
        ));
    prefs.setString('cart', jsonEncode(cartData));
  }

  void addProductToCart({
    required String productName,
    required double productPrice,
    required List imageUrlList,
    required int productQuantity,
    required String productSize,
    required String productColor,
    required double productDisPrice,
    required String productDescription,
    // required String storeName,
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
          // storeName: state[productId]!.storeName,
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
          // storeName: storeName,
          productId: productId,
        ),
      };
    }
    _hasViewedCart = false;
    _saveCart();
  }

  void setViewedCart(bool viewed) {
    _hasViewedCart = viewed;
  }

  bool get hasViewedCart => _hasViewedCart;

  void removeItem(String productId) {
    state.remove(productId);
    state = {...state};
    _saveCart();
  }

  void increseProductCount(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.productQuantity++;
    }
    state = {...state};
    _saveCart();
  }

  void decreseProductCount(String productId) {
    if (state.containsKey(productId)) {
      int count = state[productId]!.productQuantity;
      if (count > 1) {
        state[productId]!.productQuantity--;
      }
    }
    state = {...state};
    _saveCart();
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
