// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kra_roadmap_filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KraRoadmapFilter _$KraRoadmapFilterFromJson(Map<String, dynamic> json) =>
    KraRoadmapFilter(
      id: (json['id'] as num?)?.toInt(),
      kraId: (json['kraId'] as num).toInt(),
      kraRoadMapId: (json['kraRoadMapId'] as num?)?.toInt(),
      kraDescription: json['kraDescription'] as String,
      year: (json['year'] as num).toInt(),
      deliverableDescription: json['deliverableDescription'] as String?,
      isDirect: json['isDirect'] as bool,
    );

Map<String, dynamic> _$KraRoadmapFilterToJson(KraRoadmapFilter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kraId': instance.kraId,
      'kraRoadMapId': instance.kraRoadMapId,
      'kraDescription': instance.kraDescription,
      'year': instance.year,
      'deliverableDescription': instance.deliverableDescription,
      'isDirect': instance.isDirect,
    };
