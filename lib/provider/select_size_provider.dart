import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectSizeProvider =
    StateNotifierProvider.family<SelectSizeNotifier, String, String>(
        (ref, productId) {
  return SelectSizeNotifier();
});

class SelectSizeNotifier extends StateNotifier<String> {
  SelectSizeNotifier() : super("");

  void selectSize(String size) {
    state = size;
  }
}
