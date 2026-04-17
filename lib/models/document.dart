class Document {
  final int id;
  final String title;
  final String? content;
  final DateTime created;
  final DateTime modified;
  final DateTime added;
  final List<int> tags;
  final int? correspondent;
  final int? documentType;
  final int? storagePath;
  final String archiveSerialNumber;
  final String originalFileName;
  final List<Map<String, dynamic>> customFields;

  const Document({
    required this.id,
    required this.title,
    this.content,
    required this.created,
    required this.modified,
    required this.added,
    required this.tags,
    this.correspondent,
    this.documentType,
    this.storagePath,
    required this.archiveSerialNumber,
    required this.originalFileName,
    required this.customFields,
  });

  factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json['id'] as int,
        title: json['title'] as String? ?? '',
        content: json['content'] as String?,
        created: DateTime.parse(json['created'] as String),
        modified: DateTime.parse(json['modified'] as String),
        added: DateTime.parse(json['added'] as String),
        tags: (json['tags'] as List<dynamic>?)?.map((e) => e as int).toList() ?? [],
        correspondent: json['correspondent'] as int?,
        documentType: json['document_type'] as int?,
        storagePath: json['storage_path'] as int?,
        archiveSerialNumber: json['archive_serial_number'] as String? ?? '',
        originalFileName: json['original_file_name'] as String? ?? '',
        customFields: (json['custom_fields'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
      );
}

class DocumentPage {
  final int count;
  final String? next;
  final String? previous;
  final List<Document> results;

  const DocumentPage({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DocumentPage.fromJson(Map<String, dynamic> json) => DocumentPage(
        count: json['count'] as int,
        next: json['next'] as String?,
        previous: json['previous'] as String?,
        results: (json['results'] as List<dynamic>)
            .map((e) => Document.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
