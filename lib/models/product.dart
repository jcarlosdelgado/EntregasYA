class Product {
  final String name;
  final String description;
  final String priceBs;
  final String oldPriceBs;
  final double rating;
  final int reviews;
  final String imageUrl;
  final String badge;

  const Product({
    required this.name,
    required this.description,
    required this.priceBs,
    required this.oldPriceBs,
    required this.rating,
    required this.reviews,
    required this.imageUrl,
    required this.badge,
  });
}
