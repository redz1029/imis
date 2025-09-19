// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_summary_narrative.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsSummaryNarrative _$PgsSummaryNarrativeFromJson(Map<String, dynamic> json) =>
    PgsSummaryNarrative(
      (json['id'] as num).toInt(),
      (json['pgsPeriodId'] as num).toInt(),
      json['findings'] as String?,
      json['recommendation'] as String?,
      json['conclusion'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$PgsSummaryNarrativeToJson(
  PgsSummaryNarrative instance,
) => <String, dynamic>{
  'id': instance.id,
  'pgsPeriodId': instance.pgsPeriodId,
  'findings': instance.findings,
  'recommendation': instance.recommendation,
  'conclusion': instance.conclusion,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
