// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_signatory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsSignatory _$PgsSignatoryFromJson(Map<String, dynamic> json) => PgsSignatory(
  const DateTimeConverter().fromJson(json['dateSigned'] as String),
  json['isDeleted'] as bool,
  json['rowVersion'] as String?,
  id: (json['id'] as num).toInt(),
  pgsId: (json['pgsId'] as num?)?.toInt(),
  pgsSignatoryTemplateId: (json['pgsSignatoryTemplateId'] as num?)?.toInt(),
  signatoryId: json['signatoryId'] as String?,
);

Map<String, dynamic> _$PgsSignatoryToJson(PgsSignatory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pgsId': instance.pgsId,
      'pgsSignatoryTemplateId': instance.pgsSignatoryTemplateId,
      'signatoryId': instance.signatoryId,
      'dateSigned': const DateTimeConverter().toJson(instance.dateSigned),
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
