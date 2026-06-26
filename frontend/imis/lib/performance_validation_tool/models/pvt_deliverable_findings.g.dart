// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pvt_deliverable_findings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PvtDeliverableFindings _$PvtDeliverableFindingsFromJson(
  Map<String, dynamic> json,
) => PvtDeliverableFindings(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool?,
  (json['performanceValidationToolId'] as num).toInt(),
  (json['pgsDeliverableId'] as num).toInt(),
  rowVersion: json['rowVersion'] as String?,
  deliverableName: json['deliverableName'] as String?,
  findings: json['findings'] as String?,
  isNC: json['isNC'] as bool?,
  isOFI: json['isOFI'] as bool?,
  postingDate:
      json['postingDate'] == null
          ? null
          : DateTime.parse(json['postingDate'] as String),
);

Map<String, dynamic> _$PvtDeliverableFindingsToJson(
  PvtDeliverableFindings instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'performanceValidationToolId': instance.performanceValidationToolId,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'deliverableName': instance.deliverableName,
  'findings': instance.findings,
  'isNC': instance.isNC,
  'isOFI': instance.isOFI,
  'postingDate': instance.postingDate?.toIso8601String(),
};
