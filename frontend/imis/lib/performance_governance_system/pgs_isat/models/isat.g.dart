// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Isat _$IsatFromJson(Map<String, dynamic> json) => Isat(
  (json['id'] as num).toInt(),
  (json['isatPeriodId'] as num).toInt(),
  json['employeeUserId'] as String,
  (json['officeId'] as num).toInt(),
  (json['isatStrategicObjectiveSupported'] as List<dynamic>)
      .map(
        (e) =>
            IsatStrategicObjectiveSupported.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  (json['isatAnnualPerformanceCommitments'] as List<dynamic>)
      .map(
        (e) => IsatAnnualPerformanceCommitments.fromJson(
          e as Map<String, dynamic>,
        ),
      )
      .toList(),
  (json['isatStrategyContribution'] as List<dynamic>)
      .map((e) => IsatStrategicContribution.fromJson(e as Map<String, dynamic>))
      .toList(),
  _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  json['isDraft'] as bool?,
  json['isDeleted'] as bool,
  (json['isatSignatories'] as List<dynamic>?)
      ?.map((e) => IsatSignatory.fromJson(e as Map<String, dynamic>))
      .toList(),
  rowVersion: json['rowVersion'] as String?,
  office:
      json['office'] == null
          ? null
          : Office.fromJson(json['office'] as Map<String, dynamic>),
  isatPeriod:
      json['isatPeriod'] == null
          ? null
          : PgsPeriod.fromJson(json['isatPeriod'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IsatToJson(Isat instance) => <String, dynamic>{
  'id': instance.id,
  'isatPeriodId': instance.isatPeriodId,
  'isatPeriod': instance.isatPeriod,
  'office': instance.office,
  'employeeUserId': instance.employeeUserId,
  'officeId': instance.officeId,
  'isatStrategicObjectiveSupported': instance.isatStrategicObjectiveSupported,
  'isatStrategyContribution': instance.isatStrategyContribution,
  'isatAnnualPerformanceCommitments': instance.isatAnnualPerformanceCommitments,
  'postingDate': _$JsonConverterToJson<String, DateTime>(
    instance.postingDate,
    const DateTimeConverter().toJson,
  ),
  'isDeleted': instance.isDeleted,
  'isDraft': instance.isDraft,
  'isatSignatories': instance.isatSignatories,
  'rowVersion': instance.rowVersion,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
