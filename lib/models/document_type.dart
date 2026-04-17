class DocumentType {
  final int id;
  final String name;
  final int documentCount;

  const DocumentType({
    required this.id,
    required this.name,
    required this.documentCount,
  });

  factory DocumentType.fromJson(Map<String, dynamic> json) => DocumentType(
        id: json['id'] as int,
        name: json['name'] as String,
        documentCount: json['document_count'] as int? ?? 0,
      );
}
