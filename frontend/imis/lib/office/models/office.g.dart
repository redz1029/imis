// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'office.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Office _$OfficeFromJson(Map<String, dynamic> json) => Office(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['isActive'] as bool,
  json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$OfficeToJson(Office instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
