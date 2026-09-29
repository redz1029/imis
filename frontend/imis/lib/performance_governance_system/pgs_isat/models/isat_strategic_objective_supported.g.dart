// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isat_strategic_objective_supported.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IsatStrategicObjectiveSupported _$IsatStrategicObjectiveSupportedFromJson(
  Map<String, dynamic> json,
) => IsatStrategicObjectiveSupported(
  (json['id'] as num).toInt(),
  (json['isatId'] as num).toInt(),
  (json['kraRoadMapId'] as num).toInt(),
  json['kraName'] as String,
  (json['kraRoadMapDeliverableId'] as num).toInt(),
  json['kraRoadMapDeliverableName'] as String,
  json['strategicObjective'] as String,
  _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  json['isDeleted'] as bool,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$IsatStrategicObjectiveSupportedToJson(
  IsatStrategicObjectiveSupported instance,
) => <String, dynamic>{
  'id': instance.id,
  'isatId': instance.isatId,
  'kraRoadMapId': instance.kraRoadMapId,
  'kraName': instance.kraName,
  'kraRoadMapDeliverableId': instance.kraRoadMapDeliverableId,
  'kraRoadMapDeliverableName': instance.kraRoadMapDeliverableName,
  'strategicObjective': instance.strategicObjective,
  'postingDate': _$JsonConverterToJson<String, DateTime>(
    instance.postingDate,
    const DateTimeConverter().toJson,
  ),
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
