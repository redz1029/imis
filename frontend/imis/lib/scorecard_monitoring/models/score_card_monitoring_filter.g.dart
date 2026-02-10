// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card_monitoring_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreCardMonitoringFilter _$ScoreCardMonitoringFilterFromJson(
  Map<String, dynamic> json,
) => ScoreCardMonitoringFilter(
  (json['kraid'] as num?)?.toInt(),
  (json['year'] as num?)?.toInt(),
);

Map<String, dynamic> _$ScoreCardMonitoringFilterToJson(
  ScoreCardMonitoringFilter instance,
) => <String, dynamic>{'kraid': instance.kraid, 'year': instance.year};
