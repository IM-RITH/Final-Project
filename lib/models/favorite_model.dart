class FavoriteModel {
  final String productName;
  final double productPrice;
  final List imageUrlList;
  final double productDisPrice;
  final String productId;
  // final String vendorId;

  FavoriteModel({
    required this.productName,
    required this.productPrice,
    required this.imageUrlList,
    required this.productDisPrice,
    required this.productId,
    // required this.vendorId,
  });

  Map<String, dynamic> toJson() => {
        'productName': productName,
        'productPrice': productPrice,
        'imageUrlList': imageUrlList,
        'productDisPrice': productDisPrice,
        'productId': productId,
        // 'vendorId': vendorId,
      };

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        productName: json['productName'],
        productPrice: json['productPrice'],
        imageUrlList: List<String>.from(json['imageUrlList']),
        productDisPrice: json['productDisPrice'],
        productId: json['productId'],
        // vendorId: json['vendorId'],
      );
}
