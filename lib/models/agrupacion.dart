class Agrupacion {
  final int id;
  final String title;

  Agrupacion({
    required this.id,
    required this.title,
  });

  factory Agrupacion.fromJson(Map<String, dynamic> json) {
    return Agrupacion(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Agrupacion && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Agrupacion{id: $id, title: $title}';
  }
}
