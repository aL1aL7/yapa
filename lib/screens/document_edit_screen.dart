import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/document.dart';
import '../models/custom_field.dart';
import '../providers/app_settings_provider.dart';
import '../providers/documents_provider.dart';
import '../services/api_service.dart';
import '../widgets/tag_chip.dart';
import '../widgets/tag_multiselect_field.dart';

class DocumentEditScreen extends StatefulWidget {
  final Document document;

  const DocumentEditScreen({super.key, required this.document});

  @override
  State<DocumentEditScreen> createState() => _DocumentEditScreenState();
}

class _DocumentEditScreenState extends State<DocumentEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late DateTime _created;
  int? _correspondent;
  int? _documentType;
  int? _storagePath;
  late Set<int> _tags;
  late Map<int, TextEditingController> _customFieldControllers;
  late Map<int, bool> _customFieldBools;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final doc = widget.document;
    _titleController = TextEditingController(text: doc.title);
    _created = doc.created;
    _correspondent = doc.correspondent;
    _documentType = doc.documentType;
    _storagePath = doc.storagePath;
    _tags = Set.from(doc.tags);

    final provider = context.read<DocumentsProvider>();
    _customFieldControllers = {};
    _customFieldBools = {};
    for (final cf in provider.customFields) {
      final existing = doc.customFields
          .where((e) => e['field'] == cf.id)
          .firstOrNull;
      final value = existing?['value'];
      if (cf.dataType == 'boolean') {
        _customFieldBools[cf.id] = value == true || value == 'true';
      } else {
        _customFieldControllers[cf.id] =
            TextEditingController(text: value?.toString() ?? '');
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    for (final c in _customFieldControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _created,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _created = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final provider = context.read<DocumentsProvider>();
    final customFields = <Map<String, dynamic>>[];
    for (final cf in provider.customFields) {
      if (cf.dataType == 'boolean') {
        customFields.add({'field': cf.id, 'value': _customFieldBools[cf.id] ?? false});
      } else {
        final text = _customFieldControllers[cf.id]?.text.trim() ?? '';
        if (text.isNotEmpty) {
          customFields.add({'field': cf.id, 'value': text});
        }
      }
    }

    try {
      await provider.updateDocument(widget.document.id, {
        'title': _titleController.text.trim(),
        'created': DateFormat('yyyy-MM-dd').format(_created),
        'correspondent': _correspondent,
        'document_type': _documentType,
        'storage_path': _storagePath,
        'tags': _tags.toList(),
        'custom_fields': customFields,
      });
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      final msg = e is ApiException
          ? e.message
          : (AppLocalizations.of(context)?.editSaveError ?? 'Fehler beim Speichern.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DocumentsProvider>();
    final theme = Theme.of(context);
    final dateFormat = DateFormat('dd.MM.yyyy');

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.editTitle ?? 'Bearbeiten'),
        actions: [
          if (_saving)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
              ),
            )
          else
            FilledButton.icon(
              onPressed: _save,
              icon: const Icon(Icons.save_outlined, size: 18),
              label: Text(l10n?.actionSave ?? 'Speichern'),
              style: FilledButton.styleFrom(
                visualDensity: VisualDensity.compact,
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n?.editFieldTitle ?? 'Titel',
                prefixIcon: const Icon(Icons.title),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),

            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n?.editFieldCreatedDate ?? 'Erstelldatum',
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  border: const OutlineInputBorder(),
                  suffixIcon: const Icon(Icons.edit_calendar_outlined),
                ),
                child: Text(dateFormat.format(_created)),
              ),
            ),
            const SizedBox(height: 12),

            _buildDropdown<int>(
              label: l10n?.editFieldCorrespondent ?? 'Korrespondent',
              icon: Icons.person_outline,
              value: _correspondent,
              items: provider.correspondents
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _correspondent = v),
              l10n: l10n,
            ),
            const SizedBox(height: 12),

            _buildDropdown<int>(
              label: l10n?.editFieldDocumentType ?? 'Dokumenttyp',
              icon: Icons.description_outlined,
              value: _documentType,
              items: provider.documentTypes
                  .map((d) => DropdownMenuItem(value: d.id, child: Text(d.name)))
                  .toList(),
              onChanged: (v) => setState(() => _documentType = v),
              l10n: l10n,
            ),
            const SizedBox(height: 12),

            _buildDropdown<int>(
              label: l10n?.editFieldStoragePath ?? 'Speicherpfad',
              icon: Icons.folder_outlined,
              value: _storagePath,
              items: provider.storagePaths
                  .map((s) => DropdownMenuItem(value: s.id, child: Text(s.name)))
                  .toList(),
              onChanged: (v) => setState(() => _storagePath = v),
              l10n: l10n,
            ),
            const SizedBox(height: 16),

            if (provider.tags.isNotEmpty) ...[
              if (context.watch<AppSettingsProvider>().tagsAsDropdown)
                TagMultiSelectField(
                  tags: provider.tags,
                  selectedIds: _tags,
                  l10n: l10n,
                  onChanged: (ids) => setState(() {
                    _tags
                      ..clear()
                      ..addAll(ids);
                  }),
                )
              else ...[
                Text(l10n?.detailSectionTags ?? 'Tags', style: theme.textTheme.labelLarge),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: provider.tags.map((tag) {
                    final selected = _tags.contains(tag.id);
                    return TagChip(
                      tag: tag,
                      selected: selected,
                      onTap: () => setState(() {
                        if (selected) {
                          _tags.remove(tag.id);
                        } else {
                          _tags.add(tag.id);
                        }
                      }),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: 16),
            ],

            if (provider.customFields.isNotEmpty) ...[
              Text(l10n?.detailSectionCustomFields ?? 'Benutzerdefinierte Felder', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              ...provider.customFields.map((cf) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCustomField(cf),
                  )),
            ],

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required IconData icon,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    AppLocalizations? l10n,
  }) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      items: [
        DropdownMenuItem<T>(
          value: null,
          child: Text(l10n?.editDropdownNone(label) ?? '— Kein $label —'),
        ),
        ...items,
      ],
      onChanged: onChanged,
    );
  }

  Widget _buildCustomField(CustomField cf) {
    switch (cf.dataType) {
      case 'boolean':
        return SwitchListTile(
          title: Text(cf.name),
          value: _customFieldBools[cf.id] ?? false,
          onChanged: (v) => setState(() => _customFieldBools[cf.id] = v),
          contentPadding: EdgeInsets.zero,
        );
      case 'date':
        return _CustomDateField(
          label: cf.name,
          controller: _customFieldControllers[cf.id]!,
        );
      case 'integer':
        return TextFormField(
          controller: _customFieldControllers[cf.id],
          decoration: InputDecoration(
            labelText: cf.name,
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        );
      case 'float':
      case 'monetary':
        return TextFormField(
          controller: _customFieldControllers[cf.id],
          decoration: InputDecoration(
            labelText: cf.name,
            border: const OutlineInputBorder(),
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        );
      case 'url':
        return TextFormField(
          controller: _customFieldControllers[cf.id],
          decoration: InputDecoration(
            labelText: cf.name,
            prefixIcon: const Icon(Icons.link),
            border: const OutlineInputBorder(),
          ),
          keyboardType: TextInputType.url,
        );
      default:
        return TextFormField(
          controller: _customFieldControllers[cf.id],
          decoration: InputDecoration(
            labelText: cf.name,
            border: const OutlineInputBorder(),
          ),
        );
    }
  }
}

class _CustomDateField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _CustomDateField({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.edit_calendar_outlined),
      ),
      onTap: () async {
        DateTime initial = DateTime.now();
        if (controller.text.isNotEmpty) {
          try {
            initial = DateTime.parse(controller.text);
          } catch (_) {}
        }
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(picked);
        }
      },
    );
  }
}
