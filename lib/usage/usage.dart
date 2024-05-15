import 'package:easyshop/provider/cart_provider.dart';
import 'package:easyshop/provider/favorite_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// fetch user id to manage cart screen (each user has each screen cart)
void someFunction(WidgetRef ref) {
  final cartNotifier = ref.read(cartProvider.notifier);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    cartNotifier.addProductToCart(
      userId: userId,
      productName: 'Example Product',
      productPrice: 100.0,
      imageUrlList: ['url1', 'url2'],
      productQuantity: 1,
      productSize: 'M',
      productColor: 'Red',
      productDisPrice: 80.0,
      productDescription: 'Example Description',
      productId: '12345',
    );
  }
}

void loadUserCart(WidgetRef ref) {
  final cartNotifier = ref.read(cartProvider.notifier);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    cartNotifier.loadCart(userId);
  }
}

// Add the functions to manage the favorite screen for each user
void addProductToFavorites(WidgetRef ref) {
  final favoriteNotifier = ref.read(favoriteProvider.notifier);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    favoriteNotifier.addToFavorite(
      userId,
      'Example Product',
      100.0,
      ['url1', 'url2'],
      80.0,
      '12345',
    );
  }
}

void loadUserFavorites(WidgetRef ref) {
  final favoriteNotifier = ref.read(favoriteProvider.notifier);
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    favoriteNotifier.loadFavorites(userId);
  }
}
