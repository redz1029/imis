// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsPeriod _$PgsPeriodFromJson(Map<String, dynamic> json) => PgsPeriod(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  const DateTimeConverter().fromJson(json['startDate'] as String),
  const DateTimeConverter().fromJson(json['endDate'] as String),
  json['remarks'] as String?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$PgsPeriodToJson(PgsPeriod instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'startDate': const DateTimeConverter().toJson(instance.startDate),
  'endDate': const DateTimeConverter().toJson(instance.endDate),
  'rowVersion': instance.rowVersion,
  'remarks': instance.remarks,
};
