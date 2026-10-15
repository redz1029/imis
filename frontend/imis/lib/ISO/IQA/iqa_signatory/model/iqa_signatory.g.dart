// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iqa_signatory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IQASignatory _$IQASignatoryFromJson(Map<String, dynamic> json) => IQASignatory(
  id: (json['id'] as num?)?.toInt() ?? 0,
  auditEntityType: json['auditEntityType'] as String? ?? '',
  auditEntityId: (json['auditEntityId'] as num?)?.toInt() ?? 0,
  signatoryId: json['signatoryId'] as String?,
  signatoryName: json['signatoryName'] as String?,
  signatoryLabel: json['signatoryLabel'] as String?,
  position: json['position'] as String?,
  orderLevel: (json['orderLevel'] as num?)?.toInt(),
  dateSigned:
      json['dateSigned'] == null
          ? null
          : DateTime.parse(json['dateSigned'] as String),
  remarks: json['remarks'] as String?,
  approvalStatus: json['approvalStatus'] as String?,
);

Map<String, dynamic> _$IQASignatoryToJson(IQASignatory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auditEntityType': instance.auditEntityType,
      'auditEntityId': instance.auditEntityId,
      'signatoryId': instance.signatoryId,
      'signatoryName': instance.signatoryName,
      'signatoryLabel': instance.signatoryLabel,
      'position': instance.position,
      'orderLevel': instance.orderLevel,
      'dateSigned': instance.dateSigned?.toIso8601String(),
      'remarks': instance.remarks,
      'approvalStatus': instance.approvalStatus,
    };
