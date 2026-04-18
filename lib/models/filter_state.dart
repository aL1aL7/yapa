import 'dart:convert';
import 'package:intl/intl.dart';

enum CustomFieldCondition { present, isNull, equals }

enum OwnerFilter { none, mine, sharedWithMe, sharedByMe, noOwner, specificUser }

class CustomFieldFilter {
  final int fieldId;
  final String fieldName;
  final String fieldDataType;
  final CustomFieldCondition condition;
  final String? value;

  const CustomFieldFilter({
    required this.fieldId,
    required this.fieldName,
    required this.fieldDataType,
    required this.condition,
    this.value,
  });

  CustomFieldFilter withField(int id, String dataType, String name) =>
      CustomFieldFilter(
        fieldId: id,
        fieldName: name,
        fieldDataType: dataType,
        condition: condition,
        value: null,
      );

  CustomFieldFilter withCondition(CustomFieldCondition c) => CustomFieldFilter(
        fieldId: fieldId,
        fieldName: fieldName,
        fieldDataType: fieldDataType,
        condition: c,
        value: c == CustomFieldCondition.equals ? value : null,
      );

  CustomFieldFilter withValue(String? v) => CustomFieldFilter(
        fieldId: fieldId,
        fieldName: fieldName,
        fieldDataType: fieldDataType,
        condition: condition,
        value: v,
      );

  bool get isComplete =>
      condition == CustomFieldCondition.present ||
      condition == CustomFieldCondition.isNull ||
      (condition == CustomFieldCondition.equals &&
          value != null &&
          value!.isNotEmpty);
}

class FilterState {
  final String query;
  final List<int> tagIds;
  final int? correspondentId;
  final int? documentTypeId;
  final int? storagePathId;
  final DateTime? createdDateFrom;
  final DateTime? createdDateTo;
  final DateTime? addedDateFrom;
  final DateTime? addedDateTo;
  final OwnerFilter ownerFilter;
  final int? ownerUserId;
  final List<CustomFieldFilter> customFieldFilters;
  final String ordering;

  const FilterState({
    this.query = '',
    this.tagIds = const [],
    this.correspondentId,
    this.documentTypeId,
    this.storagePathId,
    this.createdDateFrom,
    this.createdDateTo,
    this.addedDateFrom,
    this.addedDateTo,
    this.ownerFilter = OwnerFilter.none,
    this.ownerUserId,
    this.customFieldFilters = const [],
    this.ordering = '-created',
  });

  FilterState copyWith({
    String? query,
    List<int>? tagIds,
    Object? correspondentId = _sentinel,
    Object? documentTypeId = _sentinel,
    Object? storagePathId = _sentinel,
    Object? createdDateFrom = _sentinel,
    Object? createdDateTo = _sentinel,
    Object? addedDateFrom = _sentinel,
    Object? addedDateTo = _sentinel,
    OwnerFilter? ownerFilter,
    Object? ownerUserId = _sentinel,
    List<CustomFieldFilter>? customFieldFilters,
    String? ordering,
  }) => FilterState(
    query: query ?? this.query,
    tagIds: tagIds ?? this.tagIds,
    correspondentId: correspondentId == _sentinel ? this.correspondentId : correspondentId as int?,
    documentTypeId: documentTypeId == _sentinel ? this.documentTypeId : documentTypeId as int?,
    storagePathId: storagePathId == _sentinel ? this.storagePathId : storagePathId as int?,
    createdDateFrom: createdDateFrom == _sentinel ? this.createdDateFrom : createdDateFrom as DateTime?,
    createdDateTo: createdDateTo == _sentinel ? this.createdDateTo : createdDateTo as DateTime?,
    addedDateFrom: addedDateFrom == _sentinel ? this.addedDateFrom : addedDateFrom as DateTime?,
    addedDateTo: addedDateTo == _sentinel ? this.addedDateTo : addedDateTo as DateTime?,
    ownerFilter: ownerFilter ?? this.ownerFilter,
    ownerUserId: ownerUserId == _sentinel ? this.ownerUserId : ownerUserId as int?,
    customFieldFilters: customFieldFilters ?? this.customFieldFilters,
    ordering: ordering ?? this.ordering,
  );

  bool get hasActiveFilters =>
      query.isNotEmpty ||
      tagIds.isNotEmpty ||
      correspondentId != null ||
      documentTypeId != null ||
      storagePathId != null ||
      createdDateFrom != null ||
      createdDateTo != null ||
      addedDateFrom != null ||
      addedDateTo != null ||
      ownerFilter != OwnerFilter.none ||
      customFieldFilters.any((f) => f.isComplete);

  Map<String, dynamic> customFieldQueryParams() {
    final params = <String, dynamic>{};
    final conditions = <dynamic>[];

    for (final f in customFieldFilters.where((f) => f.isComplete)) {
      switch (f.condition) {
        case CustomFieldCondition.present:
          conditions.add([f.fieldName, 'exists', true]);
        case CustomFieldCondition.isNull:
          conditions.add([
            'OR',
            [
              [f.fieldName, 'isnull', true],
              [f.fieldName, 'exact', ''],
            ]
          ]);
        case CustomFieldCondition.equals:
          conditions.add([f.fieldName, 'exact', _parseValue(f.fieldDataType, f.value!)]);
      }
    }

    if (conditions.length == 1) {
      params['custom_field_query'] = jsonEncode(conditions.first);
    } else if (conditions.length > 1) {
      params['custom_field_query'] = jsonEncode(['AND', conditions]);
    }

    return params;
  }

  static dynamic _parseValue(String dataType, String value) {
    switch (dataType) {
      case 'integer':
        return int.tryParse(value) ?? value;
      case 'float':
      case 'monetary':
        return double.tryParse(value) ?? value;
      case 'boolean':
        return value == 'true';
      default:
        return value;
    }
  }

  Map<String, dynamic> toQueryParams() {
    final params = <String, dynamic>{};
    if (query.isNotEmpty) params['query'] = query;
    if (tagIds.isNotEmpty) params['tags__id__all'] = tagIds.join(',');
    if (correspondentId != null) params['correspondent__id'] = correspondentId;
    if (documentTypeId != null) params['document_type__id'] = documentTypeId;
    if (storagePathId != null) params['storage_path__id'] = storagePathId;
    final dateFmt = DateFormat('yyyy-MM-dd');
    if (createdDateFrom != null) params['created__date__gte'] = dateFmt.format(createdDateFrom!);
    if (createdDateTo != null) params['created__date__lte'] = dateFmt.format(createdDateTo!);
    if (addedDateFrom != null) params['added__date__gte'] = dateFmt.format(addedDateFrom!);
    if (addedDateTo != null) params['added__date__lte'] = dateFmt.format(addedDateTo!);
    switch (ownerFilter) {
      case OwnerFilter.mine:
      case OwnerFilter.specificUser:
        if (ownerUserId != null) params['owner__id'] = ownerUserId;
      case OwnerFilter.sharedWithMe:
        // Documents NOT owned by me but visible to me = shared with me.
        // owner__id__none excludes my documents; owner__isnull=false excludes
        // ownerless documents so only explicitly-shared docs remain.
        if (ownerUserId != null) {
          params['owner__id__none'] = ownerUserId;
          params['owner__isnull'] = 'false';
        }
      case OwnerFilter.sharedByMe:
        // Documents owned by me that have been shared with at least one other
        // user or group (Paperless-ngx shared_by__id filter).
        if (ownerUserId != null) params['shared_by__id'] = ownerUserId;
      case OwnerFilter.noOwner:
        params['owner__isnull'] = 'true';
      case OwnerFilter.none:
        break;
    }
    params.addAll(customFieldQueryParams());
    params['ordering'] = ordering;
    return params;
  }
}

const _sentinel = Object();
