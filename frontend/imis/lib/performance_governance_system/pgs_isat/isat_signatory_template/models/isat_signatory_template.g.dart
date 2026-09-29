// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_signatory_template.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatSignatoryTemplate _$IsatSignatoryTemplateFromJson(
  Map<String, dynamic> json,
) => IsatSignatoryTemplate(
  (json['id'] as num).toInt(),
  json['signatoryLabel'] as String,
  json['defaultSignatoryId'] as String?,
  (json['officeId'] as num).toInt(),
  json['isDeleted'] as bool,
  isActive: json['isActive'] as bool?,
  status: json['status'] as String?,
  position: json['position'] as String?,
  rowVersion: json['rowVersion'] as String?,
  orderLevel: (json['orderLevel'] as num?)?.toInt(),
);

Map<String, dynamic> _$IsatSignatoryTemplateToJson(
  IsatSignatoryTemplate instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'status': instance.status,
  'signatoryLabel': instance.signatoryLabel,
  'defaultSignatoryId': instance.defaultSignatoryId,
  'isActive': instance.isActive,
  'officeId': instance.officeId,
  'position': instance.position,
  'orderLevel': instance.orderLevel,
};
