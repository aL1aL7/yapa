import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/filter_state.dart';
import '../providers/documents_provider.dart';
import '../widgets/tag_chip.dart';

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
                  DropdownButtonFormField<String?>(
                    initialValue: _filter.customFieldId,
                    decoration: InputDecoration(
                      labelText: l10n?.filterFieldLabel ?? 'Feld',
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n?.filterNone ?? 'Keines')),
                      ...provider.customFields.map((f) =>
                          DropdownMenuItem(value: f.id.toString(), child: Text(f.name))),
                    ],
                    onChanged: (v) => setState(() =>
                        _filter = _filter.copyWith(customFieldId: v, customFieldValue: null)),
                  ),
                  if (_filter.customFieldId != null) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      initialValue: _filter.customFieldValue,
                      decoration: InputDecoration(
                        labelText: l10n?.filterValueContains ?? 'Wert enthält',
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (v) => setState(() =>
                          _filter = _filter.copyWith(customFieldValue: v.isEmpty ? null : v)),
                    ),
                  ],
                  const SizedBox(height: 20),
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
