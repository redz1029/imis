// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iso_auditor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsoAuditor _$IsoAuditorFromJson(Map<String, dynamic> json) => IsoAuditor(
  id: (json['id'] as num).toInt(),
  teamId: (json['teamId'] as num).toInt(),
  team: json['team'] == null
      ? null
      : Team.fromJson(json['team'] as Map<String, dynamic>),
  auditorId: (json['auditorId'] as num?)?.toInt(),
  auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt(),
);

Map<String, dynamic> _$IsoAuditorToJson(IsoAuditor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'team': instance.team?.toJson(),
      'auditorId': instance.auditorId,
      'auditPlanEntryId': instance.auditPlanEntryId,
    };
