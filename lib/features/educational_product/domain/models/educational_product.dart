class EducationalProduct {
  final String productId;
  final String name;
  final String description;
  final double price;
  final int stockQuantity;
  final DateTime updatedAt;
  final bool isSynced;

  EducationalProduct({
    required this.productId,
    required this.name,
    required this.description,
    required this.price,
    required this.stockQuantity,
    required this.updatedAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'description': description,
      'price': price,
      'stockQuantity': stockQuantity,
      'updatedAt': updatedAt.toIso8601String(),
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory EducationalProduct.fromMap(Map<String, dynamic> map) {
    return EducationalProduct(
      productId: map['productId'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      stockQuantity: map['stockQuantity'],
      updatedAt: DateTime.parse(map['updatedAt']),
      isSynced: map['isSynced'] == 1,
    );
  }

  EducationalProduct copyWith({
    String? name,
    String? description,
    double? price,
    int? stockQuantity,
    DateTime? updatedAt,
    bool? isSynced,
  }) {
    return EducationalProduct(
      productId: productId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      updatedAt: updatedAt ?? this.updatedAt,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
