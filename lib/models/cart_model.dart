class CartModel {
  final String productName;
  final double productPrice;
  final List imageUrlList;
  int productQuantity;
  final String productSize;
  final String productColor;
  final double productDisPrice;
  final String productDescription;
  // final String storeName;
  final String productId;

  CartModel({
    required this.productName,
    required this.productPrice,
    required this.imageUrlList,
    required this.productQuantity,
    required this.productSize,
    required this.productColor,
    required this.productDisPrice,
    required this.productDescription,
    // required this.storeName,
    required this.productId,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productPrice': productPrice,
        'imageUrlList': imageUrlList,
        'productQuantity': productQuantity,
        'productSize': productSize,
        'productColor': productColor,
        'productDisPrice': productDisPrice,
        'productDescription': productDescription,
        // 'storeName': storeName,
        'productId': productId,
      };

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        productName: json['productName'],
        productPrice: json['productPrice'],
        imageUrlList: List<String>.from(json['imageUrlList']),
        productQuantity: json['productQuantity'],
        productSize: json['productSize'],
        productColor: json['productColor'],
        productDisPrice: json['productDisPrice'],
        productDescription: json['productDescription'],
        // storeName: json['storeName'],
        productId: json['productId'],
      );
}
