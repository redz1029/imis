// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi_roadmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KpiRoadmap _$KpiRoadmapFromJson(Map<String, dynamic> json) => KpiRoadmap(
  id: (json['id'] as num).toInt(),
  kpiDescription: json['kpiDescription'] as String?,
  target: json['target'] as String?,
  baseLine: json['baseLine'] as String?,
);

Map<String, dynamic> _$KpiRoadmapToJson(KpiRoadmap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kpiDescription': instance.kpiDescription,
      'target': instance.target,
      'baseLine': instance.baseLine,
    };
