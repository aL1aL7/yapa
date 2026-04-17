class FilterState {
  final String query;
  final List<int> tagIds;
  final int? correspondentId;
  final int? documentTypeId;
  final String? customFieldId;
  final String? customFieldValue;
  final String ordering;

  const FilterState({
    this.query = '',
    this.tagIds = const [],
    this.correspondentId,
    this.documentTypeId,
    this.customFieldId,
    this.customFieldValue,
    this.ordering = '-created',
  });

  FilterState copyWith({
    String? query,
    List<int>? tagIds,
    Object? correspondentId = _sentinel,
    Object? documentTypeId = _sentinel,
    Object? customFieldId = _sentinel,
    Object? customFieldValue = _sentinel,
    String? ordering,
  }) =>
      FilterState(
        query: query ?? this.query,
        tagIds: tagIds ?? this.tagIds,
        correspondentId: correspondentId == _sentinel
            ? this.correspondentId
            : correspondentId as int?,
        documentTypeId: documentTypeId == _sentinel
            ? this.documentTypeId
            : documentTypeId as int?,
        customFieldId: customFieldId == _sentinel
            ? this.customFieldId
            : customFieldId as String?,
        customFieldValue: customFieldValue == _sentinel
            ? this.customFieldValue
            : customFieldValue as String?,
        ordering: ordering ?? this.ordering,
      );

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      tagIds.isNotEmpty ||
      correspondentId != null ||
      documentTypeId != null ||
      (customFieldId != null && customFieldValue != null);

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (query.isNotEmpty) params['query'] = query;
    if (tagIds.isNotEmpty) {
      params['tags__id__all'] = tagIds.join(',');
    }
    if (correspondentId != null) params['correspondent__id'] = correspondentId;
    if (documentTypeId != null) params['document_type__id'] = documentTypeId;
    if (customFieldId != null && customFieldValue != null) {
      params['custom_fields__field__id'] = customFieldId;
      params['custom_fields__value__icontains'] = customFieldValue;
    }
    params['ordering'] = ordering;
    return params;
  }
}

const _sentinel = Object();
