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
  (json['status'] as num?)?.toInt(),
  (json['percentAccomplished'] as num?)?.toInt(),
  json['remarks'] as String?,
  json['attachmentPath'] as String?,
  json['deliverableName'] as String?,
  json['pgsStatus'] as String?,
  json['auditorRemarks'] as String?,
  byWhen:
      json['byWhen'] == null ? null : DateTime.parse(json['byWhen'] as String),
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
  'status': instance.status,
  'byWhen': instance.byWhen?.toIso8601String(),
  'percentAccomplished': instance.percentAccomplished,
  'remarks': instance.remarks,
  'attachmentPath': instance.attachmentPath,
  'deliverableName': instance.deliverableName,
  'pgsStatus': instance.pgsStatus,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditorRemarks': instance.auditorRemarks,
};
