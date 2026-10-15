// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_annual_performance_commitments.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatAnnualPerformanceCommitments _$IsatAnnualPerformanceCommitmentsFromJson(
  Map<String, dynamic> json,
) => IsatAnnualPerformanceCommitments(
  (json['id'] as num).toInt(),
  (json['isatId'] as num).toInt(),
  json['deliverable'] as String?,
  json['target'] as String?,
  json['accomplishment'] as String?,
  json['isDeleted'] as bool,
  _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  rowVersion: json['rowVersion'] as String?,
  kraId: (json['kraId'] as num?)?.toInt(),
  kraMName: json['kraMName'] as String?,
  pgsDeliverableId: (json['pgsDeliverableId'] as num?)?.toInt(),
  deliverableMName: json['deliverableMName'] as String?,
);

Map<String, dynamic> _$IsatAnnualPerformanceCommitmentsToJson(
  IsatAnnualPerformanceCommitments instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'isatId': instance.isatId,
  'deliverable': instance.deliverable,
  'target': instance.target,
  'accomplishment': instance.accomplishment,
  'kraId': instance.kraId,
  'kraMName': instance.kraMName,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'deliverableMName': instance.deliverableMName,
  'postingDate': _$JsonConverterToJson<String, DateTime>(
    instance.postingDate,
    const DateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
