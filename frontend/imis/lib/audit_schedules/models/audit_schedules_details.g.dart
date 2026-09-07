// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_schedules_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditScheduleDetails _$AuditScheduleDetailsFromJson(
  Map<String, dynamic> json,
) => AuditScheduleDetails(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
  auditScheduleId: (json['auditScheduleId'] as num?)?.toInt() ?? 0,
  startDateTime: _$JsonConverterFromJson<String, DateTime>(
    json['startDateTime'],
    const DateTimeConverter().fromJson,
  ),
  endDateTime: _$JsonConverterFromJson<String, DateTime>(
    json['endDateTime'],
    const DateTimeConverter().fromJson,
  ),
  teamId: (json['teamId'] as num?)?.toInt() ?? 0,
  teamName: json['teamName'] as String?,
  officeId: (json['officeId'] as num).toInt(),
  officeName: json['officeName'] as String?,
);

Map<String, dynamic> _$AuditScheduleDetailsToJson(
  AuditScheduleDetails instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditScheduleId': instance.auditScheduleId,
  'startDateTime': _$JsonConverterToJson<String, DateTime>(
    instance.startDateTime,
    const DateTimeConverter().toJson,
  ),
  'endDateTime': _$JsonConverterToJson<String, DateTime>(
    instance.endDateTime,
    const DateTimeConverter().toJson,
  ),
  'teamId': instance.teamId,
  'teamName': instance.teamName,
  'officeId': instance.officeId,
  'officeName': instance.officeName,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
