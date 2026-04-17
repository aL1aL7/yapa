class StoragePath {
  final int id;
  final String name;

  const StoragePath({required this.id, required this.name});

  factory StoragePath.fromJson(Map<String, dynamic> json) => StoragePath(
        id: json['id'] as int,
        name: json['name'] as String,
      );
}
