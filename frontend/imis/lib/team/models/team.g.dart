// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['isActive'] as bool,
  json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  improvementType: (json['improvementType'] as num?)?.toInt(),
  auditors: json['auditors'] as String?,
);

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'isActive': instance.isActive,
  'isDeleted': instance.isDeleted,
  'auditors': instance.auditors,
  'improvementType': instance.improvementType,
  'rowVersion': instance.rowVersion,
};
