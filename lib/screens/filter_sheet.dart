import 'package:flutter/material.dart';
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
                Text('Filter', style: theme.textTheme.titleLarge),
                const Spacer(),
                if (_filter.hasActiveFilters)
                  TextButton(
                    onPressed: () {
                      setState(() => _filter = const FilterState());
                    },
                    child: const Text('Zurücksetzen'),
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
                  _SectionTitle('Tags'),
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
                  _SectionTitle('Korrespondent'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    initialValue: _filter.correspondentId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Alle')),
                      ...provider.correspondents.map((c) =>
                          DropdownMenuItem(value: c.id, child: Text(c.name))),
                    ],
                    onChanged: (v) => setState(() =>
                        _filter = _filter.copyWith(correspondentId: v)),
                  ),
                  const SizedBox(height: 20),
                ],
                if (provider.documentTypes.isNotEmpty) ...[
                  _SectionTitle('Dokumenttyp'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<int?>(
                    initialValue: _filter.documentTypeId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Alle')),
                      ...provider.documentTypes.map((d) =>
                          DropdownMenuItem(value: d.id, child: Text(d.name))),
                    ],
                    onChanged: (v) => setState(() =>
                        _filter = _filter.copyWith(documentTypeId: v)),
                  ),
                  const SizedBox(height: 20),
                ],
                if (provider.customFields.isNotEmpty) ...[
                  _SectionTitle('Benutzerdefiniertes Feld'),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: _filter.customFieldId,
                    decoration: const InputDecoration(
                      labelText: 'Feld',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('Keines')),
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
                      decoration: const InputDecoration(
                        labelText: 'Wert enthält',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (v) => setState(() =>
                          _filter = _filter.copyWith(customFieldValue: v.isEmpty ? null : v)),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
                _SectionTitle('Sortierung'),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _filter.ordering,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: const [
                    DropdownMenuItem(value: '-created', child: Text('Erstellt (neueste zuerst)')),
                    DropdownMenuItem(value: 'created', child: Text('Erstellt (älteste zuerst)')),
                    DropdownMenuItem(value: '-modified', child: Text('Geändert (neueste zuerst)')),
                    DropdownMenuItem(value: 'title', child: Text('Titel (A-Z)')),
                    DropdownMenuItem(value: '-title', child: Text('Titel (Z-A)')),
                    DropdownMenuItem(value: '-added', child: Text('Hinzugefügt (neueste zuerst)')),
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
              child: const Text('Filter anwenden'),
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
