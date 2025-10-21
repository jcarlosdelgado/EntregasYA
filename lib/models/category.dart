import 'sub_categoria.dart';

class Category {
  final int id;
  final String title;
  final String imageUrl;
  final List<SubCategoria> subcategorias;

  const Category({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subcategorias = const [],
  });

  factory Category.fromJson(Map<String, dynamic> json, {List<SubCategoria> subcategorias = const []}) {
    return Category(
      id: json['id'],
      title: json['title'],
      imageUrl: json['imageUrl'] ?? '',
      subcategorias: subcategorias,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'subcategorias': subcategorias.map((s) => s.toJson()).toList(),
    };
  }
}
