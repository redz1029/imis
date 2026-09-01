// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlanEntry _$AuditPlanEntryFromJson(Map<String, dynamic> json) =>
    AuditPlanEntry(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String? ?? "",
      auditPlanId: (json['auditPlanId'] as num).toInt(),
      auditPlan: json['auditPlan'] == null
          ? null
          : AuditPlan.fromJson(json['auditPlan'] as Map<String, dynamic>),
      dayNumber: (json['dayNumber'] as num).toInt(),
      time: const DateTimeConverter().fromJson(json['time'] as String),
      isoAuditProcesses: (json['isoAuditProcesses'] as List<dynamic>?)
          ?.map((e) => IsoAuditProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
      responsiblePersons: (json['responsiblePersons'] as List<dynamic>?)
          ?.map(
            (e) =>
                AuditPlanPersonResponsible.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      isoAuditors: (json['isoAuditors'] as List<dynamic>?)
          ?.map((e) => IsoAuditor.fromJson(e as Map<String, dynamic>))
          .toList(),
      isoStandardAuditPlans: (json['isoStandardAuditPlans'] as List<dynamic>?)
          ?.map((e) => IsoStandardAuditPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      auditPlanProcesses: (json['auditPlanProcesses'] as List<dynamic>?)
          ?.map((e) => AuditPlanProcess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AuditPlanEntryToJson(AuditPlanEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'auditPlanId': instance.auditPlanId,
      'auditPlan': instance.auditPlan?.toJson(),
      'dayNumber': instance.dayNumber,
      'time': const DateTimeConverter().toJson(instance.time),
      'isoAuditProcesses': instance.isoAuditProcesses
          ?.map((e) => e.toJson())
          .toList(),
      'responsiblePersons': instance.responsiblePersons
          ?.map((e) => e.toJson())
          .toList(),
      'isoAuditors': instance.isoAuditors?.map((e) => e.toJson()).toList(),
      'isoStandardAuditPlans': instance.isoStandardAuditPlans
          ?.map((e) => e.toJson())
          .toList(),
      'auditPlanProcesses': instance.auditPlanProcesses
          ?.map((e) => e.toJson())
          .toList(),
    };

IsoAuditProcess _$IsoAuditProcessFromJson(Map<String, dynamic> json) =>
    IsoAuditProcess(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] as String?,
      isActive: json['isActive'] as bool?,
    );

Map<String, dynamic> _$IsoAuditProcessToJson(IsoAuditProcess instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'isActive': instance.isActive,
    };

AuditPlanPersonResponsible _$AuditPlanPersonResponsibleFromJson(
  Map<String, dynamic> json,
) => AuditPlanPersonResponsible(
  id: (json['id'] as num?)?.toInt() ?? 0,
  auditPlanEntryId: (json['auditPlanEntryId'] as num?)?.toInt(),
  personResponsibleId: json['personResponsibleId'] as String?,
);

Map<String, dynamic> _$AuditPlanPersonResponsibleToJson(
  AuditPlanPersonResponsible instance,
) => <String, dynamic>{
  'id': instance.id,
  'auditPlanEntryId': instance.auditPlanEntryId,
  'personResponsibleId': instance.personResponsibleId,
};

IsoAuditor _$IsoAuditorFromJson(Map<String, dynamic> json) => IsoAuditor(
  id: (json['id'] as num?)?.toInt() ?? 0,
  teamId: (json['teamId'] as num?)?.toInt(),
  auditorId: json['auditorId'] as String?,
);

Map<String, dynamic> _$IsoAuditorToJson(IsoAuditor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'auditorId': instance.auditorId,
    };

IsoStandardAuditPlan _$IsoStandardAuditPlanFromJson(
  Map<String, dynamic> json,
) => IsoStandardAuditPlan(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isoStandardId: (json['isoStandardId'] as num?)?.toInt(),
);

Map<String, dynamic> _$IsoStandardAuditPlanToJson(
  IsoStandardAuditPlan instance,
) => <String, dynamic>{
  'id': instance.id,
  'isoStandardId': instance.isoStandardId,
};
