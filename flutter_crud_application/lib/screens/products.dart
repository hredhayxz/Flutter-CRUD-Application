class Product {
  final String productName;
  final String productCode;
  final String img;
  final String unitPrice;
  final String qty;
  final String totalPrice;

  Product({
    required this.productName,
    required this.productCode,
    required this.img,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productName: json['ProductName'],
      productCode: json['ProductCode'],
      img: json['Img'],
      unitPrice: json['UnitPrice'],
      qty: json['Qty'],
      totalPrice: json['TotalPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ProductName': productName,
      'ProductCode': productCode,
      'Img': img,
      'UnitPrice': unitPrice,
      'Qty': qty,
      'TotalPrice': totalPrice,
    };
  }
}