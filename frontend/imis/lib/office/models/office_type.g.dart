// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfficeType _$OfficeTypeFromJson(Map<String, dynamic> json) => OfficeType(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isActive: json['isActive'] as bool? ?? true,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
);

Map<String, dynamic> _$OfficeTypeToJson(OfficeType instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
