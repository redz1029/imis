// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_programme.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditProgramme _$AuditProgrammeFromJson(Map<String, dynamic> json) =>
    AuditProgramme(
      id: (json['id'] as num?)?.toInt() ?? 0,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String? ?? '',
      year: (json['year'] as num?)?.toInt() ?? 0,
      forUser: json['for'] as String? ?? '',
      fromUser: json['from'] as String? ?? '',
      purpose: json['purpose'] as String? ?? '',
      objectives:
          (json['objectives'] as List<dynamic>?)
              ?.map(
                (e) =>
                    AuditProgrammeObjective.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      scopeAndFreqAudit: json['scopeAndFreqAudit'] as String? ?? '',
      internalAuditSched: json['internalAuditSched'] as String? ?? '',
      auditPlanObjective: json['auditPlanObjective'] as String? ?? '',
      scopeOfAudit: json['scopeOfAudit'] as String? ?? '',
      auditCriteria: json['auditCriteria'] as String? ?? '',
      auditMethodology: json['auditMethodology'] as String? ?? '',
      selectionAndEvaluationOfAuditors:
          json['selectionAndEvaluationOfAuditors'] as String? ?? '',
      reporting: json['reporting'] as String? ?? '',
      verificationOfPreviousNonconformities:
          json['verificationOfPreviousNonconformities'] as String? ?? '',
      auditLimitations: json['auditLimitations'] as String? ?? '',
      auditPlans:
          (json['auditPlan'] as List<dynamic>?)
              ?.map((e) => AuditPlan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$AuditProgrammeToJson(
  AuditProgramme instance,
) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'year': instance.year,
  'for': instance.forUser,
  'from': instance.fromUser,
  'purpose': instance.purpose,
  'objectives': instance.objectives.map((e) => e.toJson()).toList(),
  'scopeAndFreqAudit': instance.scopeAndFreqAudit,
  'internalAuditSched': instance.internalAuditSched,
  'auditPlanObjective': instance.auditPlanObjective,
  'scopeOfAudit': instance.scopeOfAudit,
  'auditCriteria': instance.auditCriteria,
  'auditMethodology': instance.auditMethodology,
  'selectionAndEvaluationOfAuditors': instance.selectionAndEvaluationOfAuditors,
  'reporting': instance.reporting,
  'verificationOfPreviousNonconformities':
      instance.verificationOfPreviousNonconformities,
  'auditLimitations': instance.auditLimitations,
  'auditPlan': instance.auditPlans.map((e) => e.toJson()).toList(),
};
