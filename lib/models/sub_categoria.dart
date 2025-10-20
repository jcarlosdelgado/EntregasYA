class SubCategoria {
  final int id;
  final String title;
  final int categoryId;

  const SubCategoria({
    required this.id,
    required this.title,
    required this.categoryId,
  });

  factory SubCategoria.fromJson(Map<String, dynamic> json) {
    return SubCategoria(
      id: json['id'],
      title: json['title'],
      categoryId: json['categoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'categoryId': categoryId,
    };
  }
}
