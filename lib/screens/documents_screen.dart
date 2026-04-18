import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/filter_state.dart';
import '../providers/documents_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/document_card.dart';
import 'document_detail_screen.dart';
import 'filter_sheet.dart';
import 'upload_screen.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  bool _searchActive = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DocumentsProvider>().init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<DocumentsProvider>().loadMore();
    }
  }

  void _onSearchSubmit(String query) {
    final provider = context.read<DocumentsProvider>();
    provider.updateFilter(provider.filter.copyWith(query: query.trim()));
  }

  void _clearSearch() {
    _searchController.clear();
    final provider = context.read<DocumentsProvider>();
    provider.updateFilter(provider.filter.copyWith(query: ''));
    setState(() => _searchActive = false);
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<DocumentsProvider>(),
        child: const FilterSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthProvider>();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = context.read<DocumentsProvider>();
          final uploaded = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => ChangeNotifierProvider.value(
                value: provider,
                child: const UploadScreen(),
              ),
            ),
          );
          if (uploaded == true) provider.loadDocuments();
        },
        child: const Icon(Icons.upload_file),
      ),
      appBar: AppBar(
        leading: _searchActive
            ? null
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset('assets/icon/app_icon.png'),
              ),
        title: _searchActive
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n?.documentsSearch ?? 'Dokumente suchen...',
                  border: InputBorder.none,
                ),
                textInputAction: TextInputAction.search,
                onSubmitted: _onSearchSubmit,
              )
            : const Text('YAPA'),
        actions: [
          if (!_searchActive)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => setState(() => _searchActive = true),
            ),
          if (_searchActive)
            IconButton(icon: const Icon(Icons.close), onPressed: _clearSearch),
          Consumer<DocumentsProvider>(
            builder: (context, provider, _) => Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.tune),
                  onPressed: _showFilter,
                ),
                if (provider.filter.hasActiveFilters)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'logout') auth.logout();
              if (v == 'refresh') context.read<DocumentsProvider>().loadDocuments();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'refresh',
                child: Row(children: [
                  const Icon(Icons.refresh),
                  const SizedBox(width: 8),
                  Text(l10n?.actionRefresh ?? 'Aktualisieren'),
                ]),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Row(children: [
                  const Icon(Icons.logout),
                  const SizedBox(width: 8),
                  Text(l10n?.actionLogout ?? 'Abmelden'),
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<DocumentsProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              if (provider.savedViews.isNotEmpty)
                _ViewSelectorBar(provider: provider),

              if (provider.isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else if (provider.error != null)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.loadDocuments,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: _ErrorView(
                            error: provider.error!,
                            onRetry: provider.loadDocuments,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else if (provider.documents.isEmpty)
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.loadDocuments,
                    child: LayoutBuilder(
                      builder: (context, constraints) => SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: SizedBox(
                          height: constraints.maxHeight,
                          child: _EmptyView(
                            hasFilters: provider.hasActiveFilters,
                            onReset: provider.resetFilter,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else ...[
                if (provider.filter.hasActiveFilters)
                  _ActiveFilterBar(provider: provider),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Text(
                        l10n?.documentsCount(provider.totalCount) ??
                            '${provider.totalCount} Dokument${provider.totalCount != 1 ? 'e' : ''}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: provider.loadDocuments,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount:
                          provider.documents.length + (provider.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.documents.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final doc = provider.documents[index];
                        return DocumentCard(
                          document: doc,
                          provider: provider,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiProvider(
                                providers: [
                                  ChangeNotifierProvider.value(
                                      value: context.read<AuthProvider>()),
                                  ChangeNotifierProvider.value(value: provider),
                                ],
                                child: DocumentDetailScreen(documentId: doc.id),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ViewSelectorBar extends StatelessWidget {
  final DocumentsProvider provider;

  const _ViewSelectorBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final views = provider.savedViews;
    final selected = provider.selectedView;

    return Container(
      color: theme.colorScheme.surfaceContainerLow,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            _ViewChip(
              label: l10n?.documentsAll ?? 'Alle Dokumente',
              icon: Icons.folder_outlined,
              selected: selected == null,
              onTap: () => provider.selectView(null),
            ),
            const SizedBox(width: 8),
            ...views.map((view) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _ViewChip(
                    label: view.name,
                    icon: Icons.bookmark_outline,
                    selected: selected?.id == view.id,
                    onTap: () => provider.selectView(view),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _ViewChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ViewChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FilterChip(
      avatar: Icon(
        icon,
        size: 16,
        color: selected
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _ActiveFilterBar extends StatelessWidget {
  final DocumentsProvider provider;
  const _ActiveFilterBar({required this.provider});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final filter = provider.filter;
    final chips = <Widget>[];

    if (filter.query.isNotEmpty) {
      chips.add(_FilterChip(
        label: '"${filter.query}"',
        icon: Icons.search,
        onRemove: () => provider.updateFilter(filter.copyWith(query: '')),
      ));
    }

    for (final tagId in filter.tagIds) {
      final tag = provider.tagById(tagId);
      if (tag != null) {
        chips.add(_FilterChip(
          label: tag.name,
          icon: Icons.label_outline,
          onRemove: () {
            final ids = List<int>.from(filter.tagIds)..remove(tagId);
            provider.updateFilter(filter.copyWith(tagIds: ids));
          },
        ));
      }
    }

    if (filter.correspondentId != null) {
      final c = provider.correspondentById(filter.correspondentId!);
      if (c != null) {
        chips.add(_FilterChip(
          label: c.name,
          icon: Icons.person_outline,
          onRemove: () =>
              provider.updateFilter(filter.copyWith(correspondentId: null)),
        ));
      }
    }

    if (filter.documentTypeId != null) {
      final d = provider.documentTypeById(filter.documentTypeId!);
      if (d != null) {
        chips.add(_FilterChip(
          label: d.name,
          icon: Icons.description_outlined,
          onRemove: () =>
              provider.updateFilter(filter.copyWith(documentTypeId: null)),
        ));
      }
    }

    for (final cf in filter.customFieldFilters.where((f) => f.isComplete)) {
      final fieldName =
          provider.customFieldById(cf.fieldId)?.name ?? 'Feld ${cf.fieldId}';
      final String label;
      switch (cf.condition) {
        case CustomFieldCondition.present:
          label = fieldName;
        case CustomFieldCondition.isNull:
          label = '$fieldName: ${l10n?.filterConditionIsNull ?? 'leer'}';
        case CustomFieldCondition.equals:
          label = '$fieldName: ${cf.value}';
      }
      chips.add(_FilterChip(
        label: label,
        icon: Icons.tune,
        onRemove: () {
          final list = List<CustomFieldFilter>.from(filter.customFieldFilters)
            ..remove(cf);
          provider.updateFilter(filter.copyWith(customFieldFilters: list));
        },
      ));
    }

    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  children: chips
                      .map((c) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: c,
                          ))
                      .toList()),
            ),
          ),
          TextButton(
            onPressed: provider.resetFilter,
            child: Text(l10n?.actionClearAll ?? 'Alle löschen'),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onRemove;

  const _FilterChip(
      {required this.label, required this.icon, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 14),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      deleteIcon: const Icon(Icons.close, size: 14),
      onDeleted: onRemove,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;
  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off,
                size: 56, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 16),
            Text(error, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n?.actionRetry ?? 'Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final bool hasFilters;
  final VoidCallback onReset;
  const _EmptyView({required this.hasFilters, required this.onReset});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined,
                size: 56, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: 16),
            Text(
              hasFilters
                  ? (l10n?.documentsEmptyWithFilter ?? 'Keine Dokumente gefunden.\nFilter anpassen?')
                  : (l10n?.documentsEmpty ?? 'Keine Dokumente vorhanden.'),
              textAlign: TextAlign.center,
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                  onPressed: onReset,
                  child: Text(l10n?.documentsResetFilter ?? 'Filter zurücksetzen')),
            ],
          ],
        ),
      ),
    );
  }
}
