import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/custom_field.dart';
import '../models/filter_state.dart';
import '../providers/app_settings_provider.dart';
import '../providers/documents_provider.dart';
import '../widgets/tag_chip.dart';
import '../widgets/tag_multiselect_field.dart';

class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key});

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late FilterState _filter;

  @override
  void initState() {
    super.initState();
    _filter = context.read<DocumentsProvider>().filter;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = context.watch<DocumentsProvider>();
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.95,
      minChildSize: 0.4,
      expand: false,
      builder: (context, scrollController) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
            child: Row(
              children: [
                Text(l10n?.filterTitle ?? 'Filter', style: theme.textTheme.titleLarge),
                const Spacer(),
                if (_filter.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      setState(() => _filter = const FilterState());
                    },
                    child: Text(l10n?.filterReset ?? 'Zurücksetzen'),
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              children: [
                if (provider.tags.isNotEmpty) ...[
                  _SectionTitle(l10n?.filterSectionTags ?? 'Tags'),
                  const SizedBox(height: 8),
                  if (context.watch<AppSettingsProvider>().tagsAsDropdown)
                    TagMultiSelectField(
                      tags: provider.tags,
                      selectedIds: Set<int>.from(_filter.tagIds),
                      l10n: l10n,
                      onChanged: (ids) =>
                          setState(() => _filter = _filter.copyWith(tagIds: ids.toList())),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: provider.tags.map((tag) {
                        final selected = _filter.tagIds.contains(tag.id);
                        return TagChip(
                          tag: tag,
                          selected: selected,
                          onTap: () => setState(() {
                            final ids = List<int>.from(_filter.tagIds);
                            if (selected) {
                              ids.remove(tag.id);
                            } else {
                              ids.add(tag.id);
                            }
                            _filter = _filter.copyWith(tagIds: ids);
                          }),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 20),
                ],
                if (provider.correspondents.isNotEmpty) ...[
                  _SectionTitle(l10n?.filterSectionCorrespondent ?? 'Korrespondent'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    initialValue: _filter.correspondentId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n?.filterAll ?? 'Alle')),
                      ...provider.correspondents.map((c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.name))),
                    ],
                    onChanged: (v) => setState(() =>
                        _filter = _filter.copyWith(correspondentId: v)),
                  ),
                  const SizedBox(height: 20),
                ],
                if (provider.documentTypes.isNotEmpty) ...[
                  _SectionTitle(l10n?.filterSectionDocumentType ?? 'Dokumenttyp'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    initialValue: _filter.documentTypeId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n?.filterAll ?? 'Alle')),
                      ...provider.documentTypes.map((d) =>
                          DropdownMenuItem(value: d.id, child: Text(d.name))),
                    ],
                    onChanged: (v) => setState(() =>
                        _filter = _filter.copyWith(documentTypeId: v)),
                  ),
                  const SizedBox(height: 20),
                ],
                if (provider.customFields.isNotEmpty) ...[
                  _SectionTitle(l10n?.filterSectionCustomField ?? 'Benutzerdefiniertes Feld'),
                  const SizedBox(height: 8),
                  ...List.generate(_filter.customFieldFilters.length, (i) {
                    final cf = _filter.customFieldFilters[i];
                    final field = provider.customFields.firstWhere(
                      (f) => f.id == cf.fieldId,
                      orElse: () => provider.customFields.first,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CustomFieldFilterRow(
                        cfFilter: cf,
                        field: field,
                        customFields: provider.customFields,
                        l10n: l10n,
                        onChanged: (updated) => setState(() {
                          final list = List<CustomFieldFilter>.from(
                              _filter.customFieldFilters);
                          list[i] = updated;
                          _filter = _filter.copyWith(customFieldFilters: list);
                        }),
                        onRemove: () => setState(() {
                          final list = List<CustomFieldFilter>.from(
                              _filter.customFieldFilters);
                          list.removeAt(i);
                          _filter = _filter.copyWith(customFieldFilters: list);
                        }),
                      ),
                    );
                  }),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l10n?.filterAddCustomField ??
                        'Weiteres Feld hinzufügen'),
                    onPressed: () => setState(() {
                      final first = provider.customFields.first;
                      final list = List<CustomFieldFilter>.from(
                          _filter.customFieldFilters);
                      list.add(CustomFieldFilter(
                        fieldId: first.id,
                        fieldName: first.name,
                        fieldDataType: first.dataType,
                        condition: CustomFieldCondition.present,
                      ));
                      _filter = _filter.copyWith(customFieldFilters: list);
                    }),
                  ),
                  const SizedBox(height: 12),
                ],
                _SectionTitle(l10n?.filterSectionSorting ?? 'Sortierung'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _filter.ordering,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: [
                    DropdownMenuItem(value: '-created', child: Text(l10n?.filterSortCreatedNewest ?? 'Erstellt (neueste zuerst)')),
                    DropdownMenuItem(value: 'created', child: Text(l10n?.filterSortCreatedOldest ?? 'Erstellt (älteste zuerst)')),
                    DropdownMenuItem(value: '-modified', child: Text(l10n?.filterSortModifiedNewest ?? 'Geändert (neueste zuerst)')),
                    DropdownMenuItem(value: 'title', child: Text(l10n?.filterSortTitleAZ ?? 'Titel (A-Z)')),
                    DropdownMenuItem(value: '-title', child: Text(l10n?.filterSortTitleZA ?? 'Titel (Z-A)')),
                    DropdownMenuItem(value: '-added', child: Text(l10n?.filterSortAddedNewest ?? 'Hinzugefügt (neueste zuerst)')),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => _filter = _filter.copyWith(ordering: v));
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 8, 16, MediaQuery.of(context).viewPadding.bottom + 8),
            child: FilledButton(
              onPressed: () {
                context.read<DocumentsProvider>().updateFilter(_filter);
                Navigator.pop(context);
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text(l10n?.filterApply ?? 'Filter anwenden'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomFieldFilterRow extends StatelessWidget {
  final CustomFieldFilter cfFilter;
  final CustomField field;
  final List<CustomField> customFields;
  final AppLocalizations? l10n;
  final ValueChanged<CustomFieldFilter> onChanged;
  final VoidCallback onRemove;

  const _CustomFieldFilterRow({
    required this.cfFilter,
    required this.field,
    required this.customFields,
    required this.l10n,
    required this.onChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: cfFilter.fieldId,
                decoration: InputDecoration(
                  labelText: l10n?.filterFieldLabel ?? 'Feld',
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: customFields
                    .map((f) =>
                        DropdownMenuItem(value: f.id, child: Text(f.name)))
                    .toList(),
                onChanged: (v) {
                  if (v == null) return;
                  final newField = customFields.firstWhere((f) => f.id == v);
                  onChanged(cfFilter.withField(v, newField.dataType, newField.name));
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n?.actionDelete ?? 'Löschen',
              onPressed: onRemove,
            ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<CustomFieldCondition>(
          value: cfFilter.condition,
          decoration: InputDecoration(
            labelText: l10n?.filterCondition ?? 'Bedingung',
            border: const OutlineInputBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            DropdownMenuItem(
              value: CustomFieldCondition.present,
              child: Text(l10n?.filterConditionPresent ?? 'Feld vorhanden'),
            ),
            DropdownMenuItem(
              value: CustomFieldCondition.isNull,
              child: Text(l10n?.filterConditionIsNull ?? 'Feld ist leer'),
            ),
            DropdownMenuItem(
              value: CustomFieldCondition.equals,
              child: Text(l10n?.filterConditionEquals ?? 'Wert ist gleich'),
            ),
          ],
          onChanged: (v) {
            if (v != null) onChanged(cfFilter.withCondition(v));
          },
        ),
        if (cfFilter.condition == CustomFieldCondition.equals) ...[
          const SizedBox(height: 8),
          _buildValueInput(),
        ],
      ],
    );
  }

  Widget _buildValueInput() {
    final dt = field.dataType;

    if (dt == 'select' && field.selectOptions.isNotEmpty) {
      final currentValue =
          field.selectOptions.contains(cfFilter.value) ? cfFilter.value : null;
      return DropdownButtonFormField<String>(
        value: currentValue,
        decoration: InputDecoration(
          labelText: l10n?.filterValueEquals ?? 'Wert',
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: field.selectOptions
            .map((opt) => DropdownMenuItem(value: opt, child: Text(opt)))
            .toList(),
        onChanged: (v) => onChanged(cfFilter.withValue(v)),
      );
    }

    if (dt == 'boolean') {
      return DropdownButtonFormField<String>(
        value: cfFilter.value,
        decoration: InputDecoration(
          labelText: l10n?.filterValueEquals ?? 'Wert',
          border: const OutlineInputBorder(),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        items: [
          DropdownMenuItem(
              value: 'true', child: Text(l10n?.filterBoolYes ?? 'Ja')),
          DropdownMenuItem(
              value: 'false', child: Text(l10n?.filterBoolNo ?? 'Nein')),
        ],
        onChanged: (v) => onChanged(cfFilter.withValue(v)),
      );
    }

    TextInputType keyboardType = TextInputType.text;
    List<TextInputFormatter> formatters = [];
    if (dt == 'integer') {
      keyboardType = TextInputType.number;
      formatters = [FilteringTextInputFormatter.digitsOnly];
    } else if (dt == 'float' || dt == 'monetary') {
      keyboardType =
          const TextInputType.numberWithOptions(decimal: true, signed: false);
      formatters = [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))];
    }

    return TextFormField(
      key: ValueKey('cf_${cfFilter.fieldId}_value'),
      initialValue: cfFilter.value,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: l10n?.filterValueEquals ?? 'Wert',
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: (v) => onChanged(cfFilter.withValue(v.isEmpty ? null : v)),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      );
}
