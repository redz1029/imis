// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_strategic_contribution.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatStrategicContribution _$IsatStrategicContributionFromJson(
  Map<String, dynamic> json,
) => IsatStrategicContribution(
  (json['id'] as num).toInt(),
  json['isDeleted'] as bool,
  (json['isatId'] as num).toInt(),
  (json['pgsDeliverableId'] as num).toInt(),
  _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  json['pgsDeliverableName'] as String?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$IsatStrategicContributionToJson(
  IsatStrategicContribution instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'isatId': instance.isatId,
  'pgsDeliverableId': instance.pgsDeliverableId,
  'pgsDeliverableName': instance.pgsDeliverableName,
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
