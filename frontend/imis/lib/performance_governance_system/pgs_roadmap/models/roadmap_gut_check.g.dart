// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_gut_check.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapGutCheck _$RoadmapGutCheckFromJson(Map<String, dynamic> json) =>
    RoadmapGutCheck(
      (json['id'] as num).toInt(),
      json['isDeleted'] as bool,
      json['rowVersion'] as String?,
      (json['ownership'] as num).toDouble(),
      (json['alignment'] as num).toDouble(),
      (json['contribution'] as num).toDouble(),
      (json['measurement'] as num).toDouble(),
      (json['adaptability'] as num).toDouble(),
      (json['coherence'] as num).toDouble(),
      (json['commitment'] as num).toDouble(),
      (json['totalScore'] as num).toDouble(),
    );

Map<String, dynamic> _$RoadmapGutCheckToJson(RoadmapGutCheck instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'ownership': instance.ownership,
      'alignment': instance.alignment,
      'contribution': instance.contribution,
      'measurement': instance.measurement,
      'adaptability': instance.adaptability,
      'coherence': instance.coherence,
      'commitment': instance.commitment,
      'totalScore': instance.totalScore,
    };
