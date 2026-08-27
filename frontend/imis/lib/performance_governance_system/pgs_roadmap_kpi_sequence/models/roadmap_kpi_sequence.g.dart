// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roadmap_kpi_sequence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoadmapKpiSequence _$RoadmapKpiSequenceFromJson(Map<String, dynamic> json) =>
    RoadmapKpiSequence(
      (json['id'] as num).toInt(),
      json['sequenceCode'] as String,
      json['isDeleted'] as bool,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$RoadmapKpiSequenceToJson(RoadmapKpiSequence instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sequenceCode': instance.sequenceCode,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
