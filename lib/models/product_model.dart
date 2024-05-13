class ProductModel {
  final String productName;
  final double productPrice;
  final List imageUrlList;
  int productQuantity;
  final String productSize;
  final String productColor;
  final String productDescription;
  final double productDisPrice;
  final String productId;

  ProductModel(
      {required this.productName,
      required this.productPrice,
      required this.imageUrlList,
      required this.productQuantity,
      required this.productSize,
      required this.productColor,
      required this.productDescription,
      required this.productDisPrice,
      required this.productId});
}
