// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'impact_strategic_goal_scorecard_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImpactStrategicGoalScorecardPeriod _$ImpactStrategicGoalScorecardPeriodFromJson(
  Map<String, dynamic> json,
) => ImpactStrategicGoalScorecardPeriod(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  const DateTimeConverter().fromJson(json['startDate'] as String),
  const DateTimeConverter().fromJson(json['endDate'] as String),
  json['remarks'] as String?,
  rowVersion: json['rowVersion'] as String?,
  isActive: json['isActive'] as bool?,
);

Map<String, dynamic> _$ImpactStrategicGoalScorecardPeriodToJson(
  ImpactStrategicGoalScorecardPeriod instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'rowVersion': instance.rowVersion,
  'remarks': instance.remarks,
  'isActive': instance.isActive,
};
