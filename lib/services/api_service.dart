import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import '../models/document.dart';
import '../models/tag.dart';
import '../models/custom_field.dart';
import '../models/correspondent.dart';
import '../models/document_type.dart';
import '../models/filter_state.dart';

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

  ApiService({required this.baseUrl, required String token, this.allowSelfSigned = false}) {
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
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }
  }

  static Future<String> authenticate({
    required String baseUrl,
    required String username,
    required String password,
    bool allowSelfSigned = false,
  }) async {
    final url = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final dio = Dio(BaseOptions(
      baseUrl: url,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));

    if (allowSelfSigned) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    try {
      final response = await dio.post(
        'api/token/',
        data: {'username': username, 'password': password},
      );
      final token = response.data['token'] as String?;
      if (token == null) throw const ApiException('Kein Token in Serverantwort');
      return token;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  Future<DocumentPage> getDocuments({
    required FilterState filter,
    int page = 1,
    int pageSize = 25,
  }) async {
    try {
      final params = {
        ...filter.toQueryParams(),
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

  String getDocumentPreviewUrl(int id) => '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}api/documents/$id/preview/';

  String getDocumentThumbUrl(int id) => '${baseUrl.endsWith('/') ? baseUrl : '$baseUrl/'}api/documents/$id/thumb/';

  String? get authHeader {
    return _dio.options.headers['Authorization'] as String?;
  }

  static ApiException _mapDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const ApiException('Verbindungs-Timeout. Bitte Server-URL prüfen.');
    }
    if (e.type == DioExceptionType.connectionError) {
      return ApiException(
        e.error.toString().contains('HandshakeException') || e.error.toString().contains('certificate')
            ? 'SSL-Zertifikatsfehler. Selbst-signierte Zertifikate in den Einstellungen erlauben.'
            : 'Verbindungsfehler. Bitte Server-URL und Netzwerk prüfen.',
      );
    }
    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return ApiException('Ungültige Anmeldedaten.', statusCode: statusCode);
    }
    if (statusCode == 404) {
      return ApiException('Ressource nicht gefunden.', statusCode: statusCode);
    }
    return ApiException(
      e.response?.data?.toString() ?? e.message ?? 'Unbekannter Fehler',
      statusCode: statusCode,
    );
  }
}
