// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_validation_tool.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceValidationTool _$PerformanceValidationToolFromJson(
  Map<String, dynamic> json,
) => PerformanceValidationTool(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  performanceValidationToolPeriodId:
      (json['performanceValidationToolPeriodId'] as num).toInt(),
  officeId: (json['officeId'] as num).toInt(),
  officeHeadUserId: json['officeHeadUserId'] as String?,
  validateDate: _$JsonConverterFromJson<String, DateTime>(
    json['validateDate'],
    const DateTimeConverter().fromJson,
  ),
  comment: json['comment'] as String?,
  postingDate: _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  validators:
      (json['validators'] as List<dynamic>?)
          ?.map((e) => PvtValidators.fromJson(e as Map<String, dynamic>))
          .toList(),
  objectives:
      json['objectives'] == null
          ? null
          : PvtObjectives.fromJson(json['objectives'] as Map<String, dynamic>),
  deliverableFindings:
      (json['deliverableFindings'] as List<dynamic>?)
          ?.map(
            (e) => PvtDeliverableFindings.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
  pvtSignatories:
      (json['pvtSignatories'] as List<dynamic>?)
          ?.map((e) => PvtSignatories.fromJson(e as Map<String, dynamic>))
          .toList(),
  isDraft: json['isDraft'] as bool?,
  performanceGovernanceSystemId:
      (json['performanceGovernanceSystemId'] as num).toInt(),
);

Map<String, dynamic> _$PerformanceValidationToolToJson(
  PerformanceValidationTool instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'performanceValidationToolPeriodId':
      instance.performanceValidationToolPeriodId,
  'officeId': instance.officeId,
  'officeHeadUserId': instance.officeHeadUserId,
  'validateDate': _$JsonConverterToJson<String, DateTime>(
    instance.validateDate,
    const DateTimeConverter().toJson,
  ),
  'comment': instance.comment,
  'postingDate': _$JsonConverterToJson<String, DateTime>(
    instance.postingDate,
    const DateTimeConverter().toJson,
  ),
  'validators': instance.validators,
  'objectives': instance.objectives,
  'deliverableFindings': instance.deliverableFindings,
  'pvtSignatories': instance.pvtSignatories,
  'isDraft': instance.isDraft,
  'performanceGovernanceSystemId': instance.performanceGovernanceSystemId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
