// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kpi_roadmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KpiRoadmap _$KpiRoadmapFromJson(Map<String, dynamic> json) => KpiRoadmap(
  id: (json['id'] as num).toInt(),
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
  kpiDescription: json['kpiDescription'] as String?,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => KpiRoadmapItem.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$KpiRoadmapToJson(KpiRoadmap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'kpiDescription': instance.kpiDescription,
      'items': instance.items?.map((e) => e.toJson()).toList(),
    };

KpiRoadmapItem _$KpiRoadmapItemFromJson(Map<String, dynamic> json) =>
    KpiRoadmapItem(
      id: (json['id'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
      kraRoadMapId: (json['kraRoadMapId'] as num?)?.toInt(),
      kpiDescription: json['kpiDescription'] as String?,
      target: json['target'] as String?,
      baseLine: json['baseLine'] as String?,
      year: (json['year'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KpiRoadmapItemToJson(KpiRoadmapItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'kraRoadMapId': instance.kraRoadMapId,
      'kpiDescription': instance.kpiDescription,
      'target': instance.target,
      'baseLine': instance.baseLine,
      'year': instance.year,
    };
