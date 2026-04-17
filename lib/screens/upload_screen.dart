import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/documents_provider.dart';
import '../services/api_service.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Uint8List? _fileBytes;
  String? _fileName;
  bool _uploading = false;

  int? _selectedCorrespondent;
  int? _selectedDocumentType;
  int? _selectedStoragePath;
  final Set<int> _selectedTags = {};

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'tiff', 'gif', 'webp'],
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;
    setState(() {
      _fileBytes = file.bytes;
      _fileName = file.name;
      if (_titleController.text.isEmpty) {
        _titleController.text = file.name.replaceAll(RegExp(r'\.[^.]+$'), '');
      }
    });
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (image == null) return;
    final bytes = await image.readAsBytes();
    final name = image.name.isNotEmpty ? image.name : 'foto_${DateTime.now().millisecondsSinceEpoch}.jpg';
    setState(() {
      _fileBytes = bytes;
      _fileName = name;
      if (_titleController.text.isEmpty) {
        _titleController.text = 'Foto ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}';
      }
    });
  }

  Future<void> _upload() async {
    if (_fileBytes == null || _fileName == null) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _uploading = true);
    try {
      final api = context.read<AuthProvider>().api!;
      await api.uploadDocument(
        bytes: _fileBytes!,
        fileName: _fileName!,
        title: _titleController.text.trim(),
        correspondent: _selectedCorrespondent,
        documentType: _selectedDocumentType,
        storagePath: _selectedStoragePath,
        tagIds: _selectedTags.toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dokument wird verarbeitet...'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is ApiException ? e.message : 'Upload fehlgeschlagen.'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DocumentsProvider>();
    final theme = Theme.of(context);
    final hasFile = _fileBytes != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dokument hochladen'),
        actions: [
          if (_uploading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            )
          else
            TextButton(
              onPressed: hasFile ? _upload : null,
              child: const Text('Hochladen'),
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // File selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Datei', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 12),
                    if (hasFile) ...[
                      Row(
                        children: [
                          Icon(Icons.insert_drive_file_outlined,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _fileName!,
                              style: theme.textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => setState(() {
                              _fileBytes = null;
                              _fileName = null;
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.folder_open),
                            label: const Text('Datei wählen'),
                            onPressed: _pickFile,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Foto aufnehmen'),
                            onPressed: _takePhoto,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Metadata
            Text('Metadaten', style: theme.textTheme.labelLarge),
            const SizedBox(height: 8),

            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titel',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            _DropdownField<int>(
              label: 'Korrespondent',
              icon: Icons.person_outline,
              value: _selectedCorrespondent,
              items: provider.correspondents
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCorrespondent = v),
            ),
            const SizedBox(height: 12),

            _DropdownField<int>(
              label: 'Dokumenttyp',
              icon: Icons.description_outlined,
              value: _selectedDocumentType,
              items: provider.documentTypes
                  .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedDocumentType = v),
            ),
            const SizedBox(height: 12),

            _DropdownField<int>(
              label: 'Speicherpfad',
              icon: Icons.folder_outlined,
              value: _selectedStoragePath,
              items: provider.storagePaths
                  .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedStoragePath = v),
            ),
            const SizedBox(height: 16),

            if (provider.tags.isNotEmpty) ...[
              Text('Tags', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: provider.tags.map((tag) {
                  final selected = _selectedTags.contains(tag.id);
                  return FilterChip(
                    label: Text(tag.name),
                    selected: selected,
                    onSelected: (v) => setState(() {
                      if (v) {
                        _selectedTags.add(tag.id);
                      } else {
                        _selectedTags.remove(tag.id);
                      }
                    }),
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  final String label;
  final IconData icon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const _DropdownField({
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem<T>(value: null, child: Text('— Kein $label —')),
        ...items,
      ],
      onChanged: onChanged,
    );
  }
}
