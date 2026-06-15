// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_validation_tool_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceValidationToolPeriod _$PerformanceValidationToolPeriodFromJson(
  Map<String, dynamic> json,
) => PerformanceValidationToolPeriod(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  const DateTimeConverter().fromJson(json['startDate'] as String),
  const DateTimeConverter().fromJson(json['endDate'] as String),
  period: json['period'] as String?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PerformanceValidationToolPeriodToJson(
  PerformanceValidationToolPeriod instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'period': instance.period,
  'rowVersion': instance.rowVersion,
};
