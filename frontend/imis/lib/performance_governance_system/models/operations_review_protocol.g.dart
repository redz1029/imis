// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operations_review_protocol.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationsReviewProtocol _$OperationsReviewProtocolFromJson(
  Map<String, dynamic> json,
) => OperationsReviewProtocol(
  (json['id'] as num).toInt(),
  (json['departmentId'] as num?)?.toInt(),
  (json['divisionId'] as num?)?.toInt(),
  json['userId'] as String?,
  json['deputy'] as String?,
  json['documenter'] as String?,
  (json['performanceGovernanceSystemId'] as num?)?.toInt(),
  json['venue'] as String?,
  json['scoreboardLocation'] as String?,
  json['scoreboardOIC'] as String?,
  json['actionPlan'] as String?,
  json['form1'] as String?,
  json['form2'] as String?,
  json['form3'] as String?,
  json['frequencySchedule'] as String?,
  json['frequencyUpdate'] as String?,
  json['frequency'] as String?,
  json['minutesAttachmentPath'] as String?,
  _$JsonConverterFromJson<String, DateTime>(
    json['postingDate'],
    const DateTimeConverter().fromJson,
  ),
  json['removeAttachment'] as bool?,
  isDeleted: json['isDeleted'] as bool?,
  rowVersion: json['rowVersion'] as String?,
);

Map<String, dynamic> _$OperationsReviewProtocolToJson(
  OperationsReviewProtocol instance,
) => <String, dynamic>{
  'id': instance.id,
  'departmentId': instance.departmentId,
  'divisionId': instance.divisionId,
  'userId': instance.userId,
  'deputy': instance.deputy,
  'documenter': instance.documenter,
  'performanceGovernanceSystemId': instance.performanceGovernanceSystemId,
  'venue': instance.venue,
  'scoreboardLocation': instance.scoreboardLocation,
  'scoreboardOIC': instance.scoreboardOIC,
  'actionPlan': instance.actionPlan,
  'form1': instance.form1,
  'form2': instance.form2,
  'form3': instance.form3,
  'frequencySchedule': instance.frequencySchedule,
  'frequencyUpdate': instance.frequencyUpdate,
  'frequency': instance.frequency,
  'minutesAttachmentPath': instance.minutesAttachmentPath,
  'postingDate': _$JsonConverterToJson<String, DateTime>(
    instance.postingDate,
    const DateTimeConverter().toJson,
  ),
  'removeAttachment': instance.removeAttachment,
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
