// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan_process.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlanProcess _$AuditPlanProcessFromJson(Map<String, dynamic> json) =>
    AuditPlanProcess(
      id: (json['id'] as num).toInt(),
      officeId: (json['officeId'] as num?)?.toInt(),
      office: json['office'] == null
          ? null
          : Office.fromJson(json['office'] as Map<String, dynamic>),
      processName: json['processName'] as String?,
      auditPlanEntryId: (json['auditPlanEntryId'] as num).toInt(),
    );

Map<String, dynamic> _$AuditPlanProcessToJson(AuditPlanProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'officeId': instance.officeId,
      'office': instance.office?.toJson(),
      'processName': instance.processName,
      'auditPlanEntryId': instance.auditPlanEntryId,
    };
