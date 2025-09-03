// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverable_score_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverableScoreHistory _$PgsDeliverableScoreHistoryFromJson(
  Map<String, dynamic> json,
) => PgsDeliverableScoreHistory(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  (json['pgsDeliverableId'] as num).toInt(),
  DateTime.parse(json['date'] as String),
  (json['score'] as num).toInt(),
  PgsDeliverableScoreHistory._statusFromJson((json['status'] as num).toInt()),
  remarks: json['remarks'] as String?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsDeliverableScoreHistoryToJson(
  PgsDeliverableScoreHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'date': instance.date.toIso8601String(),
  'status': PgsDeliverableScoreHistory._statusToJson(instance.status),
  'remarks': instance.remarks,
  'score': instance.score,
};
