// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_checklist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditChecklist _$AuditChecklistFromJson(Map<String, dynamic> json) =>
    AuditChecklist(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
      conforming: json['conforming'] as bool?,
      findingAndRemarks: json['findingAndRemarks'] as String?,
      auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt() ?? 0,
      auditChecklistQNAId: (json['auditChecklistQNAId'] as num?)?.toInt() ?? 0,
      auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
      auditeeId: (json['auditeeId'] as num?)?.toInt(),
      auditeeName: json['auditeeName'] as String?,
      criteria: json['criteria'] as String?,
      itemsAndQuestions: json['itemsAndQuestions'] as String?,
      officeProcess: json['officeProcess'] as String?,
      teamName: json['teamName'] as String?,
      teamId: (json['teamId'] as num?)?.toInt(),
      auditorNames: json['auditorNames'] as String?,
      auditScope: json['auditScope'] as String?,
      auditees: json['auditees'] as String?,
    );

Map<String, dynamic> _$AuditChecklistToJson(AuditChecklist instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'conforming': instance.conforming,
      'findingAndRemarks': instance.findingAndRemarks,
      'auditPlanEntryId': instance.auditPlanEntryId,
      'auditChecklistQNAId': instance.auditChecklistQNAId,
      'auditScheduleId': instance.auditScheduleId,
      'auditeeId': instance.auditeeId,
      'auditeeName': instance.auditeeName,
      'criteria': instance.criteria,
      'itemsAndQuestions': instance.itemsAndQuestions,
      'officeProcess': instance.officeProcess,
      'teamName': instance.teamName,
      'teamId': instance.teamId,
      'auditorNames': instance.auditorNames,
      'auditScope': instance.auditScope,
      'auditees': instance.auditees,
    };

AuditChecklistSummary _$AuditChecklistSummaryFromJson(
  Map<String, dynamic> json,
) => AuditChecklistSummary(
  auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
  teamId: (json['teamId'] as num?)?.toInt(),
  teamName: json['teamName'] as String?,
  officeProcess: json['officeProcess'] as String?,
  auditScope: json['auditScope'] as String?,
  auditorNames: json['auditorNames'] as String?,
  auditees: json['auditees'] as String?,
  clauseCount: (json['clauseCount'] as num?)?.toInt() ?? 0,
  statusName: json['statusName'] as String?,
);

Map<String, dynamic> _$AuditChecklistSummaryToJson(
  AuditChecklistSummary instance,
) => <String, dynamic>{
  'auditScheduleId': instance.auditScheduleId,
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'officeProcess': instance.officeProcess,
  'auditScope': instance.auditScope,
  'auditorNames': instance.auditorNames,
  'auditees': instance.auditees,
  'clauseCount': instance.clauseCount,
  'statusName': instance.statusName,
};
