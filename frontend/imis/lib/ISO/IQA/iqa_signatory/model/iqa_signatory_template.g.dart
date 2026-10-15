// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'iqa_signatory_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IQASignatoryTemplate _$IQASignatoryTemplateFromJson(
  Map<String, dynamic> json,
) => IQASignatoryTemplate(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
  auditEntityType: json['auditEntityType'] as String? ?? '',
  status: json['status'] as String? ?? '',
  signatoryLabel: json['signatoryLabel'] as String? ?? '',
  orderLevel: (json['orderLevel'] as num?)?.toInt() ?? 0,
  defaultSignatoryId: json['defaultSignatoryId'] as String?,
  defaultSignatoryName: json['defaultSignatoryName'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  officeId: (json['officeId'] as num?)?.toInt() ?? 0,
  officeName: json['officeName'] as String?,
  position: json['position'] as String?,
);

Map<String, dynamic> _$IQASignatoryTemplateToJson(
  IQASignatoryTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditEntityType': instance.auditEntityType,
  'status': instance.status,
  'signatoryLabel': instance.signatoryLabel,
  'orderLevel': instance.orderLevel,
  'defaultSignatoryId': instance.defaultSignatoryId,
  'defaultSignatoryName': instance.defaultSignatoryName,
  'isActive': instance.isActive,
  'officeId': instance.officeId,
  'officeName': instance.officeName,
  'position': instance.position,
};
