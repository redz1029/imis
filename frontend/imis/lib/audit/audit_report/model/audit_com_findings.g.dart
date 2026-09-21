// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_com_findings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditComFindings _$AuditComFindingsFromJson(Map<String, dynamic> json) =>
    AuditComFindings(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String? ?? "",
      commendableFindings: json['commendableFindings'] as String,
      area: json['area'] as String,
      areasId: (json['areasId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AuditComFindingsToJson(AuditComFindings instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'commendableFindings': instance.commendableFindings,
      'area': instance.area,
      'areasId': instance.areasId,
    };
