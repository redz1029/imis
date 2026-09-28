// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_roadmap.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatRoadmap _$IsatRoadmapFromJson(Map<String, dynamic> json) => IsatRoadmap(
  (json['id'] as num).toInt(),
  json['kraName'] as String,
  json['strategicObjective'] as String,
);

Map<String, dynamic> _$IsatRoadmapToJson(IsatRoadmap instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kraName': instance.kraName,
      'strategicObjective': instance.strategicObjective,
    };
