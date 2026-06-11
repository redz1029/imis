// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_review_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyReviewPeriod _$StrategyReviewPeriodFromJson(
  Map<String, dynamic> json,
) => StrategyReviewPeriod(
  (json['id'] as num).toInt(),
  const DateTimeConverter().fromJson(json['startDate'] as String),
  const DateTimeConverter().fromJson(json['endDate'] as String),
  json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
  quarter: json['quarter'] as String?,
);

Map<String, dynamic> _$StrategyReviewPeriodToJson(
  StrategyReviewPeriod instance,
) => <String, dynamic>{
  'id': instance.id,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'quarter': instance.quarter,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
