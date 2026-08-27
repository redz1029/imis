// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pvt_objectives.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PvtObjectives _$PvtObjectivesFromJson(Map<String, dynamic> json) =>
    PvtObjectives(
      (json['id'] as num).toInt(),
      (json['performanceValidationToolId'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      isAssessmentCompliant: json['isAssessmentCompliant'] as bool?,
      isImplementationVerified: json['isImplementationVerified'] as bool?,
      isDeliverableProgressMonitored:
          json['isDeliverableProgressMonitored'] as bool?,
      hasOpportunitiesForImprovement:
          json['hasOpportunitiesForImprovement'] as bool?,
      isValidated: json['isValidated'] as bool?,
      postingDate: _$JsonConverterFromJson<String, DateTime>(
        json['postingDate'],
        const DateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$PvtObjectivesToJson(PvtObjectives instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'performanceValidationToolId': instance.performanceValidationToolId,
      'isAssessmentCompliant': instance.isAssessmentCompliant,
      'isImplementationVerified': instance.isImplementationVerified,
      'isDeliverableProgressMonitored': instance.isDeliverableProgressMonitored,
      'hasOpportunitiesForImprovement': instance.hasOpportunitiesForImprovement,
      'isValidated': instance.isValidated,
      'postingDate': _$JsonConverterToJson<String, DateTime>(
        instance.postingDate,
        const DateTimeConverter().toJson,
      ),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
