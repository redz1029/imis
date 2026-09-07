// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'score_card_monitoring_accomplishment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScoreCardMonitoringAccomplishment _$ScoreCardMonitoringAccomplishmentFromJson(
  Map<String, dynamic> json,
) => ScoreCardMonitoringAccomplishment(
  (json['id'] as num).toInt(),
  (json['kraRoadMapDeliverableId'] as num?)?.toInt(),
  const DateTimeConverter().fromJson(json['postingDate'] as String),
  json['userId'] as String?,
  (json['percentAccomplished'] as num?)?.toInt(),
  json['remarks'] as String?,
  json['attachmentPath'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$ScoreCardMonitoringAccomplishmentToJson(
  ScoreCardMonitoringAccomplishment instance,
) => <String, dynamic>{
  'id': instance.id,
  'kraRoadMapDeliverableId': instance.kraRoadMapDeliverableId,
  'postingDate': const DateTimeConverter().toJson(instance.postingDate),
  'userId': instance.userId,
  'percentAccomplished': instance.percentAccomplished,
  'remarks': instance.remarks,
  'attachmentPath': instance.attachmentPath,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
