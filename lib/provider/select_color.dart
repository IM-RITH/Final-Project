import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectColorProvider =
    StateNotifierProvider.family<SelectColorNotifier, String, String>(
        (ref, productId) {
  return SelectColorNotifier();
});

class SelectColorNotifier extends StateNotifier<String> {
  SelectColorNotifier() : super("");

  void selectColor(String color) {
    state = color;
  }
}
