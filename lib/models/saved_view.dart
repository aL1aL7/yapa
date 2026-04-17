class SavedView {
  final int id;
  final String name;
  final bool showOnDashboard;
  final bool showInSidebar;
  final String sortField;
  final bool sortReverse;
  final List<Map<String, dynamic>> filterRules;

  const SavedView({
    required this.id,
    required this.name,
    required this.showOnDashboard,
    required this.showInSidebar,
    required this.sortField,
    required this.sortReverse,
    required this.filterRules,
  });

  factory SavedView.fromJson(Map<String, dynamic> json) => SavedView(
        id: json['id'] as int,
        name: json['name'] as String,
        showOnDashboard: json['show_on_dashboard'] as bool? ?? false,
        showInSidebar: json['show_in_sidebar'] as bool? ?? false,
        sortField: json['sort_field'] as String? ?? 'created',
        sortReverse: json['sort_reverse'] as bool? ?? true,
        filterRules: (json['filter_rules'] as List<dynamic>?)
                ?.map((e) => e as Map<String, dynamic>)
                .toList() ??
            [],
      );

  String get ordering => sortReverse ? '-$sortField' : sortField;

  // Maps paperless-ngx filter_rule rule_type integers to API query params.
  // Reference: paperless-ngx source documents/bulk_edit.py and filterrules.
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    final tagIds = <String>[];
    final noTagIds = <String>[];

    for (final rule in filterRules) {
      final ruleType = rule['rule_type'] as int? ?? -1;
      final value = rule['value']?.toString();

      switch (ruleType) {
        case 0: // title contains
          params['title__icontains'] = value;
        case 1: // content contains
          params['content__icontains'] = value;
        case 2: // ASN is
          params['archive_serial_number__icontains'] = value;
        case 3: // correspondent is
          params['correspondent__id'] = value;
        case 4: // document type is
          params['document_type__id'] = value;
        case 5: // is in inbox
          params['is_in_inbox'] = true;
        case 6: // has tag
          if (value != null) tagIds.add(value);
        case 7: // does not have tag
          if (value != null) noTagIds.add(value);
        case 8: // correspondent is not
          params['correspondent__id__none'] = value;
        case 9: // document type is not
          params['document_type__id__none'] = value;
        case 10: // created before
          params['created__date__lt'] = value;
        case 11: // created after
          params['created__date__gt'] = value;
        case 15: // added before
          params['added__date__lt'] = value;
        case 16: // added after
          params['added__date__gt'] = value;
        case 17: // title or content contains
          params['query'] = value;
        case 18: // fulltext query
          params['query'] = value;
        case 20: // has any of these tags
          if (value != null) tagIds.add(value);
      }
    }

    if (tagIds.isNotEmpty) params['tags__id__all'] = tagIds.join(',');
    if (noTagIds.isNotEmpty) params['tags__id__none'] = noTagIds.join(',');
    params['ordering'] = ordering;

    return params;
  }
}
