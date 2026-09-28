// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_roadmap_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatRoadmapDeliverables _$IsatRoadmapDeliverablesFromJson(
  Map<String, dynamic> json,
) => IsatRoadmapDeliverables(
  (json['id'] as num).toInt(),
  json['deliverableDescription'] as String,
  (json['year'] as num).toInt(),
);

Map<String, dynamic> _$IsatRoadmapDeliverablesToJson(
  IsatRoadmapDeliverables instance,
) => <String, dynamic>{
  'id': instance.id,
  'deliverableDescription': instance.deliverableDescription,
  'year': instance.year,
};

IsatPgsDeliverables _$IsatPgsDeliverablesFromJson(Map<String, dynamic> json) =>
    IsatPgsDeliverables(
      (json['id'] as num).toInt(),
      json['deliverableName'] as String,
    );

Map<String, dynamic> _$IsatPgsDeliverablesToJson(
  IsatPgsDeliverables instance,
) => <String, dynamic>{
  'id': instance.id,
  'deliverableName': instance.deliverableName,
};
