import 'package:easyshop/models/cart_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, Map<String, CartModel>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<Map<String, CartModel>> {
  CartNotifier() : super({});
  bool _hasViewedCart = false;

  // add product to cart
  void addProductToCart({
    required String productName,
    required double productPrice,
    required List imageUrlList,
    required int productQuantity,
    required String productSize,
    required String productColor,
    // required String instock,
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
            // instock: state[productId]!.instock,
            productDisPrice: state[productId]!.productDisPrice,
            productDescription: state[productId]!.productDescription,
            productId: state[productId]!.productId)
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
            // instock: instock,
            productDisPrice: productDisPrice,
            productId: productId)
      };
    }
    _hasViewedCart = false;
  }

  void setViewedCart(bool viewed) {
    _hasViewedCart = viewed;
  }

  bool get hasViewedCart => _hasViewedCart;

  // remove item from cart screen
  void removeItem(String productId) {
    state.remove(productId);
    // notify listeners
    state = {...state};
  }

  // increase item on cart screen
  void increseProductCount(String productId) {
    if (state.containsKey(productId)) {
      state[productId]!.productQuantity++;
    }
    state = {...state};
  }

  // decrease item on cart screen
  void decreseProductCount(String productId) {
    if (state.containsKey(productId)) {
      int count = state[productId]!.productQuantity;
      if (count > 1) {
        state[productId]!.productQuantity--;
      } else {}
    }
    state = {...state};
  }

  // get cart item
  Map<String, CartModel> get getCartItem => state;
}
