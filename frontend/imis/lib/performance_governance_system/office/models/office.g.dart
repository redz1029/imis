// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Office _$OfficeFromJson(Map<String, dynamic> json) => Office(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  isActive: json['isActive'] as bool? ?? true,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
);

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
