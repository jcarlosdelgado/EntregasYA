class ProductCategory {
  final int id;
  final String title;
  const ProductCategory({required this.id, required this.title});

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      title: json['title'],
    );
  }
}

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final double oldPrice;
  final String currency;
  final String unit;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String badge;
  final ProductCategory category;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.oldPrice,
    required this.currency,
    required this.unit,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.badge,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['oldPrice'] as num).toDouble(),
      currency: json['currency'],
      unit: json['unit'],
      rating: (json['rating'] as num).toDouble(),
      reviews: json['reviews'],
      imageUrl: json['imageUrl'],
      badge: json['badge'],
      category: ProductCategory.fromJson(json['category']),
    );
  }

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
  String get formattedOldPrice => oldPrice > 0 ? '$currency ${oldPrice.toStringAsFixed(2)}' : '';
  bool get hasDiscount => oldPrice > 0;
}
