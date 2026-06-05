class EducationalProduct {
  final int? productId;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;

  EducationalProduct({
    this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
    };
  }

  factory EducationalProduct.fromMap(Map<String, dynamic> map) {
    return EducationalProduct(
      productId: map['productId'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'],
    );
  }
}
