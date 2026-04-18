import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../l10n/global_l10n.dart';
import '../models/document.dart';
import '../models/tag.dart';
import '../models/custom_field.dart';
import '../models/correspondent.dart';
import '../models/document_type.dart';
import '../models/filter_state.dart';
import '../models/saved_view.dart';
import '../models/storage_path.dart';
import '../models/task_notification.dart';
import '../models/paperless_user.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  late final Dio _dio;
  final String baseUrl;
  final bool allowSelfSigned;

  /// SHA-256 of the DER-encoded server certificate that the user has previously
  /// accepted (pinned). When set, any self-signed cert presented by the server
  /// must match this fingerprint — otherwise the TLS handshake is rejected.
  final String? pinnedCertSha256;

  /// Populated by [badCertificateCallback] on a successful TOFU (trust-on-first-use)
  /// acceptance of a self-signed certificate. Callers can read this after the first
  /// request and persist it as the new pin.
  String? _lastSeenCertSha256;
  String? get lastSeenCertSha256 => _lastSeenCertSha256;

  ApiService({
    required this.baseUrl,
    required String token,
    this.allowSelfSigned = false,
    this.pinnedCertSha256,
  }) {
    if (!baseUrl.startsWith('https://')) {
      throw ApiException(currentL10n?.apiErrorHttpsOnly ?? 'Nur HTTPS-Verbindungen erlaubt.');
    }
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl.endsWith('/') ? baseUrl : '$baseUrl/',
      headers: {
        'Authorization': 'Token $token',
        'Accept': 'application/json; version=9',
      },
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 30),
    ));

    if (allowSelfSigned) {
      final expectedHost = Uri.parse(baseUrl).host;
      final pinned = pinnedCertSha256;
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          if (host != expectedHost) return false;
          final fp = _certSha256(cert);
          if (pinned != null) {
            // Pinned mode: only accept the exact cert previously trusted.
            return fp == pinned;
          }
          // TOFU mode: accept and remember so the caller can pin it.
          _lastSeenCertSha256 = fp;
          return true;
        };
        return client;
      };
    }
  }

  static String _certSha256(X509Certificate cert) {
    return sha256.convert(cert.der).toString();
  }

  /// Result of a successful username/password authentication.
  ///
  /// [certSha256] is populated when self-signed certs are allowed and a cert
  /// was accepted during the handshake. Callers should persist it as the pin
  /// for subsequent sessions.
  static Future<({String token, String? certSha256})> authenticate({
    required String baseUrl,
    required String username,
    required String password,
    bool allowSelfSigned = false,
    String? pinnedCertSha256,
  }) async {
    if (!baseUrl.startsWith('https://')) {
      throw ApiException(currentL10n?.apiErrorHttpsOnly ?? 'Nur HTTPS-Verbindungen erlaubt.');
    }
    final url = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    String? seenFingerprint;
    if (allowSelfSigned) {
      final expectedHost = Uri.parse(baseUrl).host;
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) {
          if (host != expectedHost) return false;
          final fp = _certSha256(cert);
          if (pinnedCertSha256 != null) {
            return fp == pinnedCertSha256;
          }
          seenFingerprint = fp;
          return true;
        };
        return client;
      };
    }

    try {
      final response = await dio.post(
        'api/token/',
        data: {'username': username, 'password': password},
      );
      final token = response.data['token'] as String?;
      if (token == null) throw ApiException(currentL10n?.apiErrorNoToken ?? 'Kein Token in Serverantwort');
      return (token: token, certSha256: seenFingerprint);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<DocumentPage> getDocuments({
    required FilterState filter,
    SavedView? savedView,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final baseParams = savedView != null
          ? {
              ...savedView.toQueryParams(),
              // Merge additional filter params on top; ordering stays from saved view
              if (filter.query.isNotEmpty) 'query': filter.query,
              if (filter.tagIds.isNotEmpty)
                'tags__id__all': filter.tagIds.join(','),
              if (filter.correspondentId != null)
                'correspondent__id': filter.correspondentId,
              if (filter.documentTypeId != null)
                'document_type__id': filter.documentTypeId,
              ...filter.customFieldQueryParams(),
            }
          : filter.toQueryParams();
      final params = {
        ...baseParams,
        'page': page,
        'page_size': pageSize,
        'truncate_content': true,
      };
      final response = await _dio.get('api/documents/', queryParameters: params);
      return DocumentPage.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<SavedView>> getSavedViews() async {
    try {
      final response = await _dio.get('api/saved_views/', queryParameters: {'page_size': 100});
      final results = response.data['results'] as List<dynamic>;
      return results.map((e) => SavedView.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Document> getDocument(int id) async {
    try {
      final response = await _dio.get('api/documents/$id/');
      return Document.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<Tag>> getTags() async {
    try {
      final response = await _dio.get('api/tags/', queryParameters: {'page_size': 500});
      final results = (response.data['results'] as List<dynamic>);
      return results.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<Correspondent>> getCorrespondents() async {
    try {
      final response = await _dio.get('api/correspondents/', queryParameters: {'page_size': 500});
      final results = (response.data['results'] as List<dynamic>);
      return results.map((e) => Correspondent.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<DocumentType>> getDocumentTypes() async {
    try {
      final response = await _dio.get('api/document_types/', queryParameters: {'page_size': 500});
      final results = (response.data['results'] as List<dynamic>);
      return results.map((e) => DocumentType.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<CustomField>> getCustomFields() async {
    try {
      final response = await _dio.get('api/custom_fields/', queryParameters: {'page_size': 500});
      final results = (response.data['results'] as List<dynamic>);
      return results.map((e) => CustomField.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<StoragePath>> getStoragePaths() async {
    try {
      final response = await _dio.get('api/storage_paths/', queryParameters: {'page_size': 500});
      final results = response.data['results'] as List<dynamic>;
      return results.map((e) => StoragePath.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<PaperlessUser>> getUsers() async {
    try {
      final response = await _dio.get('api/users/', queryParameters: {'page_size': 500});
      final results = response.data['results'] as List<dynamic>;
      return results.map((e) => PaperlessUser.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> uploadDocument({
    required List<int> bytes,
    required String fileName,
    String? title,
    int? correspondent,
    int? documentType,
    int? storagePath,
    List<int> tagIds = const [],
  }) async {
    try {
      final formData = FormData.fromMap({
        'document': MultipartFile.fromBytes(bytes, filename: fileName),
        if (title != null && title.isNotEmpty) 'title': title,
        if (correspondent != null) 'correspondent': correspondent.toString(),
        if (documentType != null) 'document_type': documentType.toString(),
        if (storagePath != null) 'storage_path': storagePath.toString(),
      });
      for (final id in tagIds) {
        formData.fields.add(MapEntry('tags', id.toString()));
      }
      await _dio.post('api/documents/post_document/', data: formData);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Document> updateDocument(int id, Map<String, dynamic> data) async {
    try {
      final response = await _dio.patch('api/documents/$id/', data: data);
      return Document.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> deleteDocument(int id) async {
    try {
      await _dio.delete('api/documents/$id/');
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<List<TaskNotification>> getTasks() async {
    try {
      final response = await _dio.get('api/tasks/');
      final results = response.data as List<dynamic>;
      return results
          .map((e) => TaskNotification.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<void> acknowledgeTasks(List<int> ids) async {
    try {
      // Send without versioned Accept header — acknowledge_tasks ignores versioning
      await _dio.post(
        'api/tasks/acknowledge/',
        data: {'tasks': ids},
        options: Options(
          contentType: Headers.jsonContentType,
          headers: {'Accept': 'application/json'},
        ),
      );
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<Uint8List> fetchDocumentPreview(int id) async {
    try {
      final response = await _dio.get(
        'api/documents/$id/preview/',
        options: Options(responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data as List<int>);
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  String getDocumentPreviewUrl(int id) => '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}api/documents/$id/preview/';

  String getDocumentThumbUrl(int id) => '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}api/documents/$id/thumb/';

  String? get authHeader {
    return _dio.options.headers['Authorization'] as String?;
  }

  static ApiException _mapDioError(DioException e) {
    final l = currentL10n;
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(l?.apiErrorTimeout ?? 'Verbindungs-Timeout. Bitte Server-URL prüfen.');
    }
    if (e.type == DioExceptionType.connectionError) {
      final isSSL = e.error.toString().contains('HandshakeException') ||
          e.error.toString().contains('certificate');
      return ApiException(
        isSSL
            ? (l?.apiErrorSsl ?? 'SSL-Zertifikatsfehler. Selbst-signierte Zertifikate in den Einstellungen erlauben.')
            : (l?.apiErrorConnection ?? 'Verbindungsfehler. Bitte Server-URL und Netzwerk prüfen.'),
      );
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401) {
      return ApiException(l?.apiErrorUnauthorized ?? 'Ungültige Anmeldedaten.', statusCode: statusCode);
    }
    if (statusCode == 403) {
      return ApiException(l?.apiErrorForbidden ?? 'Zugriff verweigert.', statusCode: statusCode);
    }
    if (statusCode == 404) {
      return ApiException(l?.apiErrorNotFound ?? 'Ressource nicht gefunden.', statusCode: statusCode);
    }
    if (statusCode == 400) {
      // Only expose field names, never raw server values (could leak paths,
      // OCR snippets, stack traces). User still gets an actionable hint
      // about which field is the problem.
      final body = e.response?.data;
      final fields = body is Map
          ? body.keys.map((k) => k.toString()).where((k) => k.isNotEmpty).toList()
          : const <String>[];
      final suffix = fields.isNotEmpty ? ' (${fields.join(', ')})' : '';
      return ApiException(
        '${l?.apiErrorServer('400') ?? 'Serverfehler (HTTP 400)'}$suffix',
        statusCode: 400,
      );
    }
    return ApiException(
      l?.apiErrorServer('${statusCode ?? 'unbekannt'}') ?? 'Serverfehler (HTTP ${statusCode ?? 'unbekannt'})',
      statusCode: statusCode,
    );
  }
}
