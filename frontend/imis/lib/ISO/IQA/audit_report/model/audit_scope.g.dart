// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_scope.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuditScope _$AuditScopeFromJson(Map<String, dynamic> json) => AuditScope(
  id: (json['id'] as num?)?.toInt() ?? 0,
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String? ?? "",
  auditee: json['auditee'] as String,
);

Map<String, dynamic> _$AuditScopeToJson(AuditScope instance) =>
    <String, dynamic>{
      'id': instance.id,
      'isDeleted': instance.isDeleted,
      'rowVersion': instance.rowVersion,
      'auditee': instance.auditee,
    };
