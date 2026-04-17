class Correspondent {
  final int id;
  final String name;
  final int documentCount;

  const Correspondent({
    required this.id,
    required this.name,
    required this.documentCount,
  });

  factory Correspondent.fromJson(Map<String, dynamic> json) => Correspondent(
        id: json['id'] as int,
        name: json['name'] as String,
        documentCount: json['document_count'] as int? ?? 0,
      );
}
