class CustomField {
  final int id;
  final String name;
  final String dataType;

  const CustomField({
    required this.id,
    required this.name,
    required this.dataType,
  });

  factory CustomField.fromJson(Map<String, dynamic> json) => CustomField(
        id: json['id'] as int,
        name: json['name'] as String,
        dataType: json['data_type'] as String? ?? 'string',
      );
}

class CustomFieldInstance {
  final int field;
  final String fieldName;
  final dynamic value;

  const CustomFieldInstance({
    required this.field,
    required this.fieldName,
    required this.value,
  });

  factory CustomFieldInstance.fromJson(
    Map<String, dynamic> json,
    List<CustomField> fields,
  ) {
    final fieldId = json['field'] as int;
    final name = fields.firstWhere((f) => f.id == fieldId,
        orElse: () => CustomField(id: fieldId, name: 'Feld $fieldId', dataType: 'string')).name;
    return CustomFieldInstance(
      field: fieldId,
      fieldName: name,
      value: json['value'],
    );
  }
}
