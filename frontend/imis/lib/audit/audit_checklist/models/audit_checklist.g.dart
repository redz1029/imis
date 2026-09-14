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
      criteria: json['criteria'] as String?,
      itemsAndQuestions: json['itemsAndQuestions'] as String?,
      officeProcess: json['officeProcess'] as String?,
      auditScope: json['auditScope'] as String?,
      auditTeamName: json['auditTeamName'] as String?,
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
      'criteria': instance.criteria,
      'itemsAndQuestions': instance.itemsAndQuestions,
      'officeProcess': instance.officeProcess,
      'auditScope': instance.auditScope,
      'auditTeamName': instance.auditTeamName,
      'auditees': instance.auditees,
    };
