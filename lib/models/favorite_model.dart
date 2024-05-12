class FavoriteModel {
  final String productName;
  final double productPrice;
  final List imageUrlList;
  final double productDisPrice;
  final String productId;

  // final String productDescription;
  // int productQuantity;
  // final String productSize;
  // final String productColor;
  // final String vendorId;

  FavoriteModel({
    required this.productName,
    required this.productPrice,
    required this.imageUrlList,
    // required this.productDescription,
    required this.productDisPrice,
    required this.productId,
  });
}
