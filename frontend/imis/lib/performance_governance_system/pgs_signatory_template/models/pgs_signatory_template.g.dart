// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_signatory_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsSignatoryTemplate _$PgsSignatoryTemplateFromJson(
  Map<String, dynamic> json,
) => PgsSignatoryTemplate(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  json['status'] as String,
  (json['orderLevel'] as num).toInt(),
  json['defaultSignatoryId'] as String,
  json['isActive'] as bool,
  rowVersion: json['rowVersion'] as String?,
  signatoryLabel: json['signatoryLabel'] as String?,
);

Map<String, dynamic> _$PgsSignatoryTemplateToJson(
  PgsSignatoryTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'status': instance.status,
  'orderLevel': instance.orderLevel,
  'defaultSignatoryId': instance.defaultSignatoryId,
  'isActive': instance.isActive,
  'rowVersion': instance.rowVersion,
  'signatoryLabel': instance.signatoryLabel,
};
