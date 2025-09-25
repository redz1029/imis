// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_deliverable_accomplishment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsDeliverableAccomplishment _$PgsDeliverableAccomplishmentFromJson(
  Map<String, dynamic> json,
) => PgsDeliverableAccomplishment(
  (json['id'] as num).toInt(),
  (json['pgsDeliverableId'] as num?)?.toInt(),
  const DateTimeConverter().fromJson(json['postingDate'] as String),
  json['userId'] as String?,
  (json['percentAccomplished'] as num?)?.toInt(),
  json['remarks'] as String?,
  json['attachmentPath'] as String?,
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsDeliverableAccomplishmentToJson(
  PgsDeliverableAccomplishment instance,
) => <String, dynamic>{
  'id': instance.id,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'postingDate': const DateTimeConverter().toJson(instance.postingDate),
  'userId': instance.userId,
  'percentAccomplished': instance.percentAccomplished,
  'remarks': instance.remarks,
  'attachmentPath': instance.attachmentPath,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
