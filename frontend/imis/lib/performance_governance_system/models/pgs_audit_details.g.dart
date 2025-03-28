// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pgs_audit_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PgsAuditDetails _$PgsAuditDetailsFromJson(Map<String, dynamic> json) =>
    PgsAuditDetails(
      (json['id'] as num).toInt(),
      PgsPeriod.fromJson(json['pgsPeriod'] as Map<String, dynamic>),
      Office.fromJson(json['office'] as Map<String, dynamic>),
      (json['pgsDeliverables'] as List<dynamic>)
          .map((e) => PgsDeliverables.fromJson(e as Map<String, dynamic>))
          .toList(),
      PgsReadiness.fromJson(json['pgsReadinessRating'] as Map<String, dynamic>),
      json['isDeleted'] as bool,
      remarks: json['remarks'] as String? ?? '',
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$PgsAuditDetailsToJson(PgsAuditDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'office': instance.office,
      'pgsPeriod': instance.pgsPeriod,
      'remarks': instance.remarks,
      'pgsDeliverables': instance.pgsDeliverables,
      'pgsReadinessRating': instance.pgsReadinessRating,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
