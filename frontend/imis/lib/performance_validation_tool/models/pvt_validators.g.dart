// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pvt_validators.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PvtValidators _$PvtValidatorsFromJson(Map<String, dynamic> json) =>
    PvtValidators(
      (json['id'] as num).toInt(),
      json['isDeleted'] as bool?,
      (json['performanceValidationToolId'] as num).toInt(),
      (json['auditorId'] as num).toInt(),
      DateTime.parse(json['postingDate'] as String),
      rowVersion: json['rowVersion'] as bool?,
    );

Map<String, dynamic> _$PvtValidatorsToJson(PvtValidators instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rowVersion': instance.rowVersion,
      'isDeleted': instance.isDeleted,
      'performanceValidationToolId': instance.performanceValidationToolId,
      'auditorId': instance.auditorId,
      'postingDate': instance.postingDate.toIso8601String(),
    };
