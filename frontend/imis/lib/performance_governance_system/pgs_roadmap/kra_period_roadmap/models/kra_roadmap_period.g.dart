// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kra_roadmap_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KraRoadmapPeriod _$KraRoadmapPeriodFromJson(Map<String, dynamic> json) =>
    KraRoadmapPeriod(
      (json['id'] as num).toInt(),
      const DateTimeConverter().fromJson(json['startYear'] as String),
      const DateTimeConverter().fromJson(json['endYear'] as String),
      isDeleted: json['isDeleted'] as bool?,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$KraRoadmapPeriodToJson(KraRoadmapPeriod instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startYear': const DateTimeConverter().toJson(instance.startYear),
      'endYear': const DateTimeConverter().toJson(instance.endYear),
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
