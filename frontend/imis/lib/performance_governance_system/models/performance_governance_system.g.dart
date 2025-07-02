// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'performance_governance_system.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PerformanceGovernanceSystem _$PerformanceGovernanceSystemFromJson(
  Map<String, dynamic> json,
) => PerformanceGovernanceSystem(
  id: (json['id'] as num).toInt(),
  office: Office.fromJson(json['office'] as Map<String, dynamic>),
  pgsPeriod: PgsPeriod.fromJson(json['pgsPeriod'] as Map<String, dynamic>),
  pgsDeliverables:
      (json['pgsDeliverables'] as List<dynamic>?)
          ?.map((e) => PgsDeliverables.fromJson(e as Map<String, dynamic>))
          .toList(),
  pgsReadinessRating: PgsReadiness.fromJson(
    json['pgsReadinessRating'] as Map<String, dynamic>,
  ),
  pgsSignatories:
      (json['pgsSignatories'] as List<dynamic>?)
          ?.map((e) => PgsSignatory.fromJson(e as Map<String, dynamic>))
          .toList(),
  isDeleted: json['isDeleted'] as bool,
  remarks: json['remarks'] as String? ?? '',
  rowVersion: json['rowVersion'] as String?,
  percentDeliverables: (json['percentDeliverables'] as num).toDouble(),
  pgsStatus: json['pgsStatus'] as String?,
  forSignature: json['forSignature'] as bool,
);

Map<String, dynamic> _$PerformanceGovernanceSystemToJson(
  PerformanceGovernanceSystem instance,
) => <String, dynamic>{
  'id': instance.id,
  'office': instance.office,
  'pgsPeriod': instance.pgsPeriod,
  'remarks': instance.remarks,
  'pgsDeliverables': instance.pgsDeliverables,
  'pgsReadinessRating': instance.pgsReadinessRating,
  'pgsSignatories': instance.pgsSignatories,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'percentDeliverables': instance.percentDeliverables,
  'pgsStatus': instance.pgsStatus,
  'forSignature': instance.forSignature,
};
