// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditee.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditee _$AuditeeFromJson(Map<String, dynamic> json) => Auditee(
  id: (json['id'] as num?)?.toInt() ?? 0,
  name: json['name'] as String,
  userId: json['userId'] as String,
  userEmail: json['userEmail'] as String?,
  fullName: json['fullName'] as String?,
);

Map<String, dynamic> _$AuditeeToJson(Auditee instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'userId': instance.userId,
  'userEmail': instance.userEmail,
  'fullName': instance.fullName,
};
