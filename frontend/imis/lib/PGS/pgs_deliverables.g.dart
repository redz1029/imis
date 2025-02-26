// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverables _$PgsDeliverablesFromJson(Map<String, dynamic> json) =>
    PgsDeliverables(
      (json['id'] as num).toInt(),
      KeyResultArea.fromJson(json['kra'] as Map<String, dynamic>),
      json['deliverableName'] as String,
      json['isDirect'] as bool,
      DateTime.parse(json['byWhen'] as String),
      (json['percentDeliverables'] as num).toDouble(),
      $enumDecode(_$PgsStatusEnumMap, json['status']),
      remarks: json['remarks'] as String?,
    );

Map<String, dynamic> _$PgsDeliverablesToJson(PgsDeliverables instance) =>
    <String, dynamic>{
      'id': instance.id,
      'kra': instance.keyResultArea,
      'isDirect': instance.isDirect,
      'deliverableName': instance.deliverableName,
      'byWhen': instance.byWhen.toIso8601String(),
      'percentDeliverables': instance.percentDeliverables,
      'status': _$PgsStatusEnumMap[instance.status]!,
      'remarks': instance.remarks,
    };

const _$PgsStatusEnumMap = {
  PgsStatus.notStarted: 'notStarted',
  PgsStatus.inProgress: 'inProgress',
  PgsStatus.onTrack: 'onTrack',
  PgsStatus.delayed: 'delayed',
  PgsStatus.needsImprovement: 'needsImprovement',
  PgsStatus.completed: 'completed',
  PgsStatus.exceeded: 'exceeded',
  PgsStatus.onHold: 'onHold',
  PgsStatus.cancelled: 'cancelled',
};
