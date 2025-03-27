// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditor _$AuditorFromJson(Map<String, dynamic> json) => Auditor(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  json['name'] as String,
  json['isActive'] as bool,
  json['isTeamLeader'] as bool,
  json['isOfficeHead'] as bool,
);

Map<String, dynamic> _$AuditorToJson(Auditor instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'name': instance.name,
  'isActive': instance.isActive,
  'isTeamLeader': instance.isTeamLeader,
  'isOfficeHead': instance.isOfficeHead,
};
