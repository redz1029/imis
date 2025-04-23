// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditor _$AuditorFromJson(Map<String, dynamic> json) => Auditor(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
  name: json['name'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  isTeamLeader: json['isTeamLeader'] as bool? ?? false,
  isOfficeHead: json['isOfficeHead'] as bool? ?? false,
);

Map<String, dynamic> _$AuditorToJson(Auditor instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'name': instance.name,
  'isActive': instance.isActive,
  'isTeamLeader': instance.isTeamLeader,
  'isOfficeHead': instance.isOfficeHead,
};
