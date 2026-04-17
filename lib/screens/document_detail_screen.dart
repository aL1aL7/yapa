import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import '../models/document.dart';
import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
import '../services/api_service.dart';
import '../widgets/tag_chip.dart';
import 'document_edit_screen.dart';

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
    final bytes = await api.fetchDocumentPreview(docId);
    if (mounted) setState(() => _pdfBytes = bytes);
    return bytes;
  }

  static String _sanitizeFileName(String name) {
    // Strip path separators and traversal sequences to prevent path traversal
    return name
        .replaceAll(RegExp(r'[/\\]'), '_')
        .replaceAll(RegExp(r'\.\.+'), '_')
        .replaceAll(RegExp(r'[<>:"|?*\x00-\x1F]'), '_')
        .trim();
  }

  Future<void> _downloadDocument() async {
    if (_downloading) return;
    setState(() => _downloading = true);

    try {
      final bytes = _pdfBytes ?? await _pdfBytesFuture;
      if (bytes == null) throw Exception('Keine Daten verfügbar');

      final rawName = _document!.originalFileName.isNotEmpty
          ? _document!.originalFileName
          : 'dokument_${_document!.id}.pdf';
      final fileName = _sanitizeFileName(rawName);

      final savedPath = await FilePicker.saveFile(
        dialogTitle: 'Dokument speichern',
        fileName: fileName,
        bytes: bytes,
      );

      if (!mounted) return;

      if (savedPath != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gespeichert: $savedPath'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      // savedPath == null bedeutet: Nutzer hat abgebrochen → kein Feedback nötig
    } catch (e) {
      if (mounted) {
        final msg = e is ApiException ? e.message : 'Download fehlgeschlagen.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
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
                case _MenuAction.delete:
                  _confirmDelete();
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
              PopupMenuItem(
                value: _MenuAction.delete,
                child: ListTile(
                  leading: Icon(Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error),
                  title: Text('Löschen',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error)),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: _PdfViewer(pdfFuture: _pdfBytesFuture),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: FilledButton.icon(
            onPressed: _openEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Bearbeiten'),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dokument löschen'),
        content: const Text(
            'Das Dokument wird dauerhaft gelöscht. Dieser Vorgang kann nicht rückgängig gemacht werden.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      await context.read<DocumentsProvider>().deleteDocument(widget.documentId);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException ? e.message : 'Löschen fehlgeschlagen.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  void _openEdit() {
    final provider = context.read<DocumentsProvider>();
    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: DocumentEditScreen(document: _document!),
        ),
      ),
    ).then((updated) {
      if (updated == true) _loadDocument();
    });
  }
}

enum _MenuAction { details, download, delete }

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
                    snapshot.error is ApiException
                        ? 'Dokument konnte nicht geladen werden:\n${snapshot.error}'
                        : 'Dokument konnte nicht geladen werden.',
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
    final storagePath = document.storagePath != null
        ? provider.storagePathById(document.storagePath!)
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
        if (storagePath != null)
          _DetailTile(
            icon: Icons.folder_outlined,
            label: 'Speicherpfad',
            value: storagePath.name,
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
