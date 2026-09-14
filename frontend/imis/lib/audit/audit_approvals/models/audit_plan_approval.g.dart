// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_plan_approval.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditPlanApproval _$AuditPlanApprovalFromJson(Map<String, dynamic> json) =>
    AuditPlanApproval(
      id: (json['id'] as num?)?.toInt(),
      auditPlanId: (json['auditPlanId'] as num).toInt(),
      approverId: json['aproverId'] as String,
      action: json['action'] as String?,
      timestamp:
          json['timestamp'] == null
              ? null
              : DateTime.parse(json['timestamp'] as String),
      comments: json['comments'] as String?,
      isDeleted: json['isDeleted'] as bool? ?? false,
      rowVersion: json['rowVersion'] as String?,
    );

Map<String, dynamic> _$AuditPlanApprovalToJson(AuditPlanApproval instance) =>
    <String, dynamic>{
      'id': instance.id,
      'auditPlanId': instance.auditPlanId,
      'aproverId': instance.approverId,
      'action': instance.action,
      'timestamp': instance.timestamp.toIso8601String(),
      'comments': instance.comments,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
    };
