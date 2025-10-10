// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorTeam _$AuditorTeamFromJson(Map<String, dynamic> json) => AuditorTeam(
  (json['id'] as num).toInt(),
  (json['teamId'] as num).toInt(),
  (json['auditors'] as List<dynamic>)
      .map((e) => Auditor.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['isActive'] as bool,
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool?,
);

Map<String, dynamic> _$AuditorTeamToJson(AuditorTeam instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'auditors': instance.auditors,
      'isActive': instance.isActive,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
    };
