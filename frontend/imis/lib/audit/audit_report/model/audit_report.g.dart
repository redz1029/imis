// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditReport _$AuditReportFromJson(Map<String, dynamic> json) => AuditReport(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
  auditPurpose: json['auditPurpose'] as String,
  auditConclusions: json['auditConclusions'] as String,
  officeAuditedId: (json['officeAuditedId'] as num?)?.toInt(),
  officeAuditedName: json['officeAuditedName'] as String?,
  auditStandardISOId: (json['auditStandardISOId'] as num?)?.toInt(),
  auditStandardISOName: json['auditStandardISOName'] as String?,
  auditeeId: (json['auditeeId'] as num?)?.toInt(),
  auditeeName: json['auditeeName'] as String?,
  auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt(),
  auditPlanEntry:
      json['auditPlanEntry'] == null
          ? null
          : AuditPlanEntry.fromJson(
            json['auditPlanEntry'] as Map<String, dynamic>,
          ),
  auditComFindings:
      (json['auditComFindings'] as List<dynamic>?)
          ?.map((e) => AuditComFindings.fromJson(e as Map<String, dynamic>))
          .toList(),
  auditScope:
      (json['auditScope'] as List<dynamic>?)
          ?.map((e) => AuditScope.fromJson(e as Map<String, dynamic>))
          .toList(),
  auditSummaryFindings:
      (json['auditSummaryFindings'] as List<dynamic>?)
          ?.map((e) => AuditSummaryFindings.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$AuditReportToJson(AuditReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'auditPurpose': instance.auditPurpose,
      'auditConclusions': instance.auditConclusions,
      'officeAuditedId': instance.officeAuditedId,
      'officeAuditedName': instance.officeAuditedName,
      'auditStandardISOId': instance.auditStandardISOId,
      'auditStandardISOName': instance.auditStandardISOName,
      'auditeeId': instance.auditeeId,
      'auditeeName': instance.auditeeName,
      'auditPlanEntryId': instance.auditPlanEntryId,
      'auditPlanEntry': instance.auditPlanEntry?.toJson(),
      'auditComFindings':
          instance.auditComFindings?.map((e) => e.toJson()).toList(),
      'auditScope': instance.auditScope?.map((e) => e.toJson()).toList(),
      'auditSummaryFindings':
          instance.auditSummaryFindings?.map((e) => e.toJson()).toList(),
    };
