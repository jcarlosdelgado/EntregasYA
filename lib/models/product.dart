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
  final String category;

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
      price: json['price'].toDouble(),
      oldPrice: json['oldPrice'].toDouble(),
      currency: json['currency'],
      unit: json['unit'],
      rating: json['rating'].toDouble(),
      reviews: json['reviews'],
      imageUrl: json['imageUrl'],
      badge: json['badge'],
      category: json['category'],
    );
  }

  String get formattedPrice => '$currency ${price.toStringAsFixed(2)}';
  String get formattedOldPrice => oldPrice > 0 ? '$currency ${oldPrice.toStringAsFixed(2)}' : '';
  bool get hasDiscount => oldPrice > 0;
}
