class PaperlessUser {
  final int id;
  final String username;
  final String firstName;
  final String lastName;

  const PaperlessUser({required this.id, required this.username, required this.firstName, required this.lastName});

  String get displayName {
    final full = '$firstName $lastName'.trim();
    return full.isNotEmpty ? full : username;
  }

  factory PaperlessUser.fromJson(Map<String, dynamic> json) => PaperlessUser(
    id: json['id'] as int,
    username: json['username'] as String? ?? '',
    firstName: json['first_name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
  );
}
