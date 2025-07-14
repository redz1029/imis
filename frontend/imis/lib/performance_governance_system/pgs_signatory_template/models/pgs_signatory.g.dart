// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_signatory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsSignatory _$PgsSignatoryFromJson(Map<String, dynamic> json) => PgsSignatory(
  (json['id'] as num?)?.toInt(),
  (json['pgsId'] as num?)?.toInt(),
  (json['pgsSignatoryTemplateId'] as num?)?.toInt(),
  json['signatoryName'] as String?,
  json['signatoryId'] as String?,
  json['label'] as String?,
  json['status'] as String?,
  json['isNextStatus'] as bool?,
  (json['orderLevel'] as num?)?.toInt(),
  const DateTimeConverter().fromJson(json['dateSigned'] as String),
  json['isDeleted'] as bool,
  json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsSignatoryToJson(PgsSignatory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pgsId': instance.pgsId,
      'pgsSignatoryTemplateId': instance.pgsSignatoryTemplateId,
      'signatoryName': instance.signatoryName,
      'signatoryId': instance.signatoryId,
      'label': instance.label,
      'status': instance.status,
      'isNextStatus': instance.isNextStatus,
      'orderLevel': instance.orderLevel,
      'dateSigned': const DateTimeConverter().toJson(instance.dateSigned),
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
