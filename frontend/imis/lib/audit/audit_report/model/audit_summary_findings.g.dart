// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_summary_findings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditSummaryFindings _$AuditSummaryFindingsFromJson(
  Map<String, dynamic> json,
) => AuditSummaryFindings(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
  no: (json['no'] as num).toInt(),
  findings: json['findings'] as String,
);

Map<String, dynamic> _$AuditSummaryFindingsToJson(
  AuditSummaryFindings instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'no': instance.no,
  'findings': instance.findings,
};
