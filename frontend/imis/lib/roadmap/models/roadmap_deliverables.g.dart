// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapDeliverables _$RoadmapDeliverablesFromJson(Map<String, dynamic> json) =>
    RoadmapDeliverables(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String,
      year: (json['year'] as num).toInt(),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$RoadmapDeliverablesToJson(
  RoadmapDeliverables instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'description': instance.description,
  'year': instance.year,
};
