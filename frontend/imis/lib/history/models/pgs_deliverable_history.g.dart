// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverable_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverableHistory _$PgsDeliverableHistoryFromJson(
  Map<String, dynamic> json,
) => PgsDeliverableHistory(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  (json['pgsDeliverableId'] as num).toInt(),
  DateTime.parse(json['date'] as String),
  (json['score'] as num).toInt(),
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsDeliverableHistoryToJson(
  PgsDeliverableHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'date': instance.date.toIso8601String(),
  'score': instance.score,
};
