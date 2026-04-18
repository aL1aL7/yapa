import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/tag.dart';

class TagMultiSelectField extends StatelessWidget {
  final List<Tag> tags;
  final Set<int> selectedIds;
  final ValueChanged<Set<int>> onChanged;
  final AppLocalizations? l10n;

  const TagMultiSelectField({
    super.key,
    required this.tags,
    required this.selectedIds,
    required this.onChanged,
    this.l10n,
  });

  String _buildLabel() {
    if (selectedIds.isEmpty) return l10n?.tagPickerNone ?? 'Keine Tags ausgewählt';
    final names =
        tags.where((t) => selectedIds.contains(t.id)).map((t) => t.name).toList();
    if (names.length <= 3) return names.join(', ');
    return l10n?.tagPickerCount(names.length) ?? '${names.length} Tags ausgewählt';
  }

  Future<void> _openPicker(BuildContext context) async {
    final result = await showDialog<Set<int>>(
      context: context,
      builder: (ctx) => _TagPickerDialog(
        tags: tags,
        initialSelected: selectedIds,
        l10n: l10n,
      ),
    );
    if (result != null) onChanged(result);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _openPicker(context),
      borderRadius: BorderRadius.circular(4),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: l10n?.detailSectionTags ?? 'Tags',
          prefixIcon: const Icon(Icons.label_outline),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.arrow_drop_down),
        ),
        child: Text(
          _buildLabel(),
          style: selectedIds.isEmpty
              ? TextStyle(color: theme.colorScheme.outline)
              : null,
        ),
      ),
    );
  }
}

class _TagPickerDialog extends StatefulWidget {
  final List<Tag> tags;
  final Set<int> initialSelected;
  final AppLocalizations? l10n;

  const _TagPickerDialog({
    required this.tags,
    required this.initialSelected,
    this.l10n,
  });

  @override
  State<_TagPickerDialog> createState() => _TagPickerDialogState();
}

class _TagPickerDialogState extends State<_TagPickerDialog> {
  late Set<int> _selected;

  @override
  void initState() {
    super.initState();
    _selected = Set.from(widget.initialSelected);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    return AlertDialog(
      title: Text(l10n?.tagPickerTitle ?? 'Tags auswählen'),
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: widget.tags.length,
          itemBuilder: (ctx, i) {
            final tag = widget.tags[i];
            return CheckboxListTile(
              value: _selected.contains(tag.id),
              title: Text(tag.name),
              dense: true,
              onChanged: (v) => setState(() {
                if (v == true) {
                  _selected.add(tag.id);
                } else {
                  _selected.remove(tag.id);
                }
              }),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n?.actionCancel ?? 'Abbrechen'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _selected),
          child: Text(l10n?.actionSave ?? 'Speichern'),
        ),
      ],
    );
  }
}
