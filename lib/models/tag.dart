class Tag {
  final int id;
  final String name;
  final String slug;
  final String color;
  final int documentCount;

  const Tag({
    required this.id,
    required this.name,
    required this.slug,
    required this.color,
    required this.documentCount,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json['id'] as int,
        name: json['name'] as String,
        slug: json['slug'] as String? ?? '',
        color: json['color'] as String? ?? '#a6cee3',
        documentCount: json['document_count'] as int? ?? 0,
      );
}
