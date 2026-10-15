// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_programme_objective.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditProgrammeObjective _$AuditProgrammeObjectiveFromJson(
  Map<String, dynamic> json,
) => AuditProgrammeObjective(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
  auditProgrammeId: (json['auditProgrammeId'] as num?)?.toInt() ?? 0,
  sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
  description: json['description'] as String? ?? "",
);

Map<String, dynamic> _$AuditProgrammeObjectiveToJson(
  AuditProgrammeObjective instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'auditProgrammeId': instance.auditProgrammeId,
  'sortOrder': instance.sortOrder,
  'description': instance.description,
};
