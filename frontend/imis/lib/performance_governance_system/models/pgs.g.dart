// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pgs _$PgsFromJson(Map<String, dynamic> json) => Pgs(
  (json['id'] as num).toInt(),
  PgsPeriod.fromJson(json['pgsPeriod'] as Map<String, dynamic>),
  Office.fromJson(json['office'] as Map<String, dynamic>),
  PgsReadiness.fromJson(json['pgsReadinessRating'] as Map<String, dynamic>),
  json['isDeleted'] as bool,
  remarks: json['remarks'] as String? ?? '',
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsToJson(Pgs instance) => <String, dynamic>{
  'id': instance.id,
  'office': instance.office,
  'pgsPeriod': instance.pgsPeriod,
  'remarks': instance.remarks,
  'pgsReadinessRating': instance.pgsReadinessRating,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};
