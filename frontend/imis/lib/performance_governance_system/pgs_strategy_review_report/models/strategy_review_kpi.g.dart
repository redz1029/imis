// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'strategy_review_kpi.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrategyReviewKpiItem _$StrategyReviewKpiItemFromJson(
  Map<String, dynamic> json,
) => StrategyReviewKpiItem(
  json['startDate'] as String,
  json['endDate'] as String,
  (json['kpiDeliverable'] as List<dynamic>)
      .map((e) => StrategyReviewKpi.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$StrategyReviewKpiItemToJson(
  StrategyReviewKpiItem instance,
) => <String, dynamic>{
  'startDate': instance.startDate,
  'endDate': instance.endDate,
  'kpiDeliverable': instance.kpiDeliverable,
};

StrategyReviewKpi _$StrategyReviewKpiFromJson(Map<String, dynamic> json) =>
    StrategyReviewKpi(
      (json['id'] as num).toInt(),
      kpiDescription: json['kpiDescription'] as String?,
      target: json['target'] as String?,
      measure: json['measure'] as String?,
      baseLine: json['baseLine'] as String?,
      kraRoadMapId: (json['kraRoadMapId'] as num?)?.toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$StrategyReviewKpiToJson(StrategyReviewKpi instance) =>
    <String, dynamic>{
      'kpiDescription': instance.kpiDescription,
      'target': instance.target,
      'measure': instance.measure,
      'baseLine': instance.baseLine,
      'kraRoadMapId': instance.kraRoadMapId,
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
