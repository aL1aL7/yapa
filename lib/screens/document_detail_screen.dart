import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/document.dart';
import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../widgets/tag_chip.dart';

class DocumentDetailScreen extends StatefulWidget {
  final int documentId;

  const DocumentDetailScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailScreen> createState() => _DocumentDetailScreenState();
}

class _DocumentDetailScreenState extends State<DocumentDetailScreen> {
  Document? _document;
  bool _loading = true;
  String? _error;

  Future<Uint8List>? _pdfBytesFuture;
  Uint8List? _pdfBytes;
  bool _downloading = false;

  @override
  void initState() {
    super.initState();
    _loadDocument();
  }

  Future<void> _loadDocument() async {
    final api = context.read<AuthProvider>().api!;
    try {
      final doc = await api.getDocument(widget.documentId);
      if (mounted) {
        setState(() {
          _document = doc;
          _loading = false;
          _pdfBytesFuture = _fetchPdfBytes(api, doc.id);
        });
      }
    } on ApiException catch (e) {
      if (mounted) setState(() { _error = e.message; _loading = false; });
    }
  }

  Future<Uint8List> _fetchPdfBytes(ApiService api, int docId) async {
    final allowSelfSigned =
        await StorageService().getAllowSelfSigned().catchError((_) => false);

    final dio = Dio(BaseOptions(
      headers: {'Authorization': api.authHeader},
      responseType: ResponseType.bytes,
      receiveTimeout: const Duration(minutes: 2),
    ));

    if (allowSelfSigned) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      };
    }

    final response = await dio.get(api.getDocumentPreviewUrl(docId));
    final bytes = Uint8List.fromList(response.data as List<int>);
    // Cache bytes for download reuse
    if (mounted) setState(() => _pdfBytes = bytes);
    return bytes;
  }

  Future<void> _downloadDocument() async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      final bytes = _pdfBytes ?? await _pdfBytesFuture;
      if (bytes == null) throw Exception('Keine Daten verfügbar');

      final dir = await getApplicationDocumentsDirectory();
      final fileName = _document!.originalFileName.isNotEmpty
          ? _document!.originalFileName
          : 'dokument_${_document!.id}.pdf';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gespeichert: ${file.path}'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download fehlgeschlagen: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  void _openDetails() {
    final provider = context.read<DocumentsProvider>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: _DocumentDetailsScreen(document: _document!),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error!)),
      );
    }

    final doc = _document!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          doc.title.isNotEmpty ? doc.title : doc.originalFileName,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          PopupMenuButton<_MenuAction>(
            onSelected: (action) {
              switch (action) {
                case _MenuAction.details:
                  _openDetails();
                case _MenuAction.download:
                  _downloadDocument();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: _MenuAction.details,
                child: ListTile(
                  leading: Icon(Icons.info_outline),
                  title: Text('Details'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: _MenuAction.download,
                child: ListTile(
                  leading: _downloading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.download_outlined),
                  title: const Text('Herunterladen'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _PdfViewer(pdfFuture: _pdfBytesFuture),
    );
  }
}

enum _MenuAction { details, download }

class _PdfViewer extends StatelessWidget {
  final Future<Uint8List>? pdfFuture;

  const _PdfViewer({this.pdfFuture});

  @override
  Widget build(BuildContext context) {
    if (pdfFuture == null) return const Center(child: CircularProgressIndicator());

    return FutureBuilder<Uint8List>(
      future: pdfFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Dokument wird geladen...'),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Dokument konnte nicht geladen werden:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return SfPdfViewer.memory(
          snapshot.data!,
          canShowScrollHead: true,
          canShowScrollStatus: true,
          pageLayoutMode: PdfPageLayoutMode.continuous,
        );
      },
    );
  }
}

class _DocumentDetailsScreen extends StatelessWidget {
  final Document document;

  const _DocumentDetailsScreen({required this.document});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentsProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: _DetailsContent(document: document, provider: provider),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final Document document;
  final DocumentsProvider provider;

  const _DetailsContent({required this.document, required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy HH:mm');
    final correspondent = document.correspondent != null
        ? provider.correspondentById(document.correspondent!)
        : null;
    final docType = document.documentType != null
        ? provider.documentTypeById(document.documentType!)
        : null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _DetailTile(
          icon: Icons.title,
          label: 'Titel',
          value: document.title.isNotEmpty ? document.title : '—',
        ),
        _DetailTile(
          icon: Icons.calendar_today_outlined,
          label: 'Erstellt',
          value: dateFormat.format(document.created),
        ),
        _DetailTile(
          icon: Icons.update,
          label: 'Geändert',
          value: dateFormat.format(document.modified),
        ),
        _DetailTile(
          icon: Icons.add_circle_outline,
          label: 'Hinzugefügt',
          value: dateFormat.format(document.added),
        ),
        if (correspondent != null)
          _DetailTile(
            icon: Icons.person_outline,
            label: 'Korrespondent',
            value: correspondent.name,
          ),
        if (docType != null)
          _DetailTile(
            icon: Icons.description_outlined,
            label: 'Dokumenttyp',
            value: docType.name,
          ),
        if (document.archiveSerialNumber.isNotEmpty)
          _DetailTile(
            icon: Icons.tag,
            label: 'Archivnummer',
            value: document.archiveSerialNumber,
          ),
        _DetailTile(
          icon: Icons.insert_drive_file_outlined,
          label: 'Originaldatei',
          value: document.originalFileName,
        ),
        if (document.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text('Tags', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: document.tags.map((tagId) {
              final tag = provider.tagById(tagId);
              if (tag == null) return const SizedBox.shrink();
              return TagChip(tag: tag);
            }).toList(),
          ),
        ],
        if (document.customFields.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Benutzerdefinierte Felder', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          ...document.customFields.map((cf) {
            final fieldId = cf['field'] as int?;
            final value = cf['value'];
            if (fieldId == null || value == null) return const SizedBox.shrink();
            final field =
                provider.customFields.where((f) => f.id == fieldId).firstOrNull;
            return _DetailTile(
              icon: Icons.edit_note,
              label: field?.name ?? 'Feld $fieldId',
              value: value.toString(),
            );
          }),
        ],
        if (document.content != null && document.content!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Inhalt (OCR)', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          SelectableText(
            document.content!,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

class _DetailTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.outline),
                ),
                const SizedBox(height: 2),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
