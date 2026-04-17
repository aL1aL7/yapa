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
  // Reference: src-ui/src/app/data/filter-rule-type.ts (paperless-ngx main branch)
  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    final tagsAll = <String>[];
    final tagsIn = <String>[];
    final tagsNone = <String>[];
    final correspondentsIn = <String>[];
    final correspondentsNone = <String>[];
    final docTypesIn = <String>[];
    final docTypesNone = <String>[];
    final storagePathsIn = <String>[];
    final storagePathsNone = <String>[];
    final customFieldsAll = <String>[];
    final customFieldsIn = <String>[];
    final customFieldsNone = <String>[];

    for (final rule in filterRules) {
      final ruleType = rule['rule_type'] as int? ?? -1;
      final value = rule['value']?.toString();

      switch (ruleType) {
        case 0: params['title__icontains'] = value;
        case 1: params['content__icontains'] = value;
        case 2: params['archive_serial_number'] = value;
        case 3: params['correspondent__id'] = value;
        case 4: params['document_type__id'] = value;
        case 5: params['is_in_inbox'] = true;
        case 6: if (value != null) tagsAll.add(value);
        case 7: if (value != null) tagsIn.add(value);
        case 8: params['created__date__lt'] = value;
        case 9: params['created__date__gt'] = value;
        case 10: params['created__year'] = value;
        case 11: params['created__month'] = value;
        case 12: params['created__day'] = value;
        case 13: params['added__date__lt'] = value;
        case 14: params['added__date__gt'] = value;
        case 15: params['modified__date__lt'] = value;
        case 16: params['modified__date__gt'] = value;
        case 17: if (value != null) tagsNone.add(value);
        case 18: params['archive_serial_number__isnull'] = true;
        case 19: params['title_content'] = value;
        case 20: params['query'] = value;
        case 21: params['more_like_id'] = value;
        case 22: if (value != null) tagsIn.add(value);
        case 23: params['archive_serial_number__gt'] = value;
        case 24: params['archive_serial_number__lt'] = value;
        case 25: params['storage_path__id'] = value;
        case 26: if (value != null) correspondentsIn.add(value);
        case 27: if (value != null) correspondentsNone.add(value);
        case 28: if (value != null) docTypesIn.add(value);
        case 29: if (value != null) docTypesNone.add(value);
        case 30: if (value != null) storagePathsIn.add(value);
        case 31: if (value != null) storagePathsNone.add(value);
        case 32: params['owner__id'] = value;
        case 34: params['owner__isnull'] = true;
        case 36: params['custom_fields__icontains'] = value;
        case 38: if (value != null) customFieldsAll.add(value);
        case 39: if (value != null) customFieldsIn.add(value);
        case 40: if (value != null) customFieldsNone.add(value);
        case 41: params['has_custom_fields'] = true;
        case 42: params['custom_field_query'] = value;
        case 43: params['created__date__lte'] = value;
        case 44: params['created__date__gte'] = value;
        case 45: params['added__date__lte'] = value;
        case 46: params['added__date__gte'] = value;
        case 47: params['mime_type'] = value;
      }
    }

    if (tagsAll.isNotEmpty) params['tags__id__all'] = tagsAll.join(',');
    if (tagsIn.isNotEmpty) params['tags__id__in'] = tagsIn.join(',');
    if (tagsNone.isNotEmpty) params['tags__id__none'] = tagsNone.join(',');
    if (correspondentsIn.isNotEmpty) params['correspondent__id__in'] = correspondentsIn.join(',');
    if (correspondentsNone.isNotEmpty) params['correspondent__id__none'] = correspondentsNone.join(',');
    if (docTypesIn.isNotEmpty) params['document_type__id__in'] = docTypesIn.join(',');
    if (docTypesNone.isNotEmpty) params['document_type__id__none'] = docTypesNone.join(',');
    if (storagePathsIn.isNotEmpty) params['storage_path__id__in'] = storagePathsIn.join(',');
    if (storagePathsNone.isNotEmpty) params['storage_path__id__none'] = storagePathsNone.join(',');
    if (customFieldsAll.isNotEmpty) params['custom_fields__id__all'] = customFieldsAll.join(',');
    if (customFieldsIn.isNotEmpty) params['custom_fields__id__in'] = customFieldsIn.join(',');
    if (customFieldsNone.isNotEmpty) params['custom_fields__id__none'] = customFieldsNone.join(',');

    params['ordering'] = ordering;

    return params;
  }
}
