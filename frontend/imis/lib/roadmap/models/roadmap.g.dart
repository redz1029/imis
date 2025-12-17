// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roadmap _$RoadmapFromJson(Map<String, dynamic> json) => Roadmap(
  (json['id'] as num?)?.toInt(),
  (json['kraId'] as num?)?.toInt(),
  json['kra'] == null
      ? null
      : KeyResultArea.fromJson(json['kra'] as Map<String, dynamic>),
  (json['kraRoadMapPeriodId'] as num?)?.toInt(),
  json['kraRoadMapPeriod'] == null
      ? null
      : KraRoadmapPeriod.fromJson(
        json['kraRoadMapPeriod'] as Map<String, dynamic>,
      ),
  (json['deliverables'] as List<dynamic>?)
      ?.map((e) => DeliverableGroup.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['kpis'] as List<dynamic>?)
      ?.map((e) => KpiRoadmap.fromJson(e as Map<String, dynamic>))
      .toList(),
  rowVersion: json['rowVersion'] as String?,
  isDeleted: json['isDeleted'] as bool?,
);

Map<String, dynamic> _$RoadmapToJson(Roadmap instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'kraId': instance.kraId,
  'kra': instance.kra,
  'kraRoadMapPeriodId': instance.kraRoadMapPeriodId,
  'kraRoadMapPeriod': instance.kraRoadMapPeriod,
  'deliverables': instance.deliverables,
  'kpis': instance.kpis,
};
