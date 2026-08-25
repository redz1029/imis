// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor_team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditorTeamMember _$AuditorTeamMemberFromJson(Map<String, dynamic> json) =>
    AuditorTeamMember(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      isActive: json['isActive'] as bool,
      isTeamLeader: json['isTeamLeader'] as bool,
      isOfficeHead: json['isOfficeHead'] as bool,
      userId: json['userId'] as String,
      isDeleted: json['isDeleted'] as bool,
    );

Map<String, dynamic> _$AuditorTeamMemberToJson(AuditorTeamMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
      'isTeamLeader': instance.isTeamLeader,
      'isOfficeHead': instance.isOfficeHead,
      'userId': instance.userId,
      'isDeleted': instance.isDeleted,
    };

AuditorTeamDetail _$AuditorTeamDetailFromJson(Map<String, dynamic> json) =>
    AuditorTeamDetail(
      id: (json['id'] as num).toInt(),
      teamId: (json['teamId'] as num).toInt(),
      isActive: json['isActive'] as bool,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      auditors:
          (json['auditors'] as List<dynamic>)
              .map((e) => AuditorTeamMember.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$AuditorTeamDetailToJson(AuditorTeamDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'isActive': instance.isActive,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'auditors': instance.auditors,
    };
