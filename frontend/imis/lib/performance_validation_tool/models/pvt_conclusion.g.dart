// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pvt_conclusion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PvtConclusion _$PvtConclusionFromJson(Map<String, dynamic> json) =>
    PvtConclusion(
      (json['id'] as num).toInt(),
      (json['performanceValidationToolId'] as num).toInt(),
      const DateTimeConverter().fromJson(json['postingDate'] as String),
      json['isDeleted'] as bool,
      isCompliant: json['isCompliant'] as bool?,
      isImprovement: json['isImprovement'] as bool?,
      isPartial: json['isPartial'] as bool?,
      isCritical: json['isCritical'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$PvtConclusionToJson(PvtConclusion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'performanceValidationToolId': instance.performanceValidationToolId,
      'isCompliant': instance.isCompliant,
      'isImprovement': instance.isImprovement,
      'isPartial': instance.isPartial,
      'isCritical': instance.isCritical,
      'postingDate': const DateTimeConverter().toJson(instance.postingDate),
    };
