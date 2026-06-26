// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pvt_signatories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PvtSignatories _$PvtSignatoriesFromJson(Map<String, dynamic> json) =>
    PvtSignatories(
      (json['id'] as num?)?.toInt(),
      (json['performanceValidationToolId'] as num?)?.toInt(),
      (json['performanceValidationToolSignatoryTemplateId'] as num?)?.toInt(),
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

Map<String, dynamic> _$PvtSignatoriesToJson(PvtSignatories instance) =>
    <String, dynamic>{
      'id': instance.id,
      'performanceValidationToolId': instance.performanceValidationToolId,
      'performanceValidationToolSignatoryTemplateId':
          instance.performanceValidationToolSignatoryTemplateId,
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
