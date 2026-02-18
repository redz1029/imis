// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditor _$AuditorFromJson(Map<String, dynamic> json) => Auditor(
  id: (json['id'] as num?)?.toInt(),
  isDeleted: json['isDeleted'] as bool? ?? false,
  rowVersion: json['rowVersion'] as String?,
  isActive: json['isActive'] as bool? ?? true,
  userId: json['userId'] as String?,
);

Map<String, dynamic> _$AuditorToJson(Auditor instance) => <String, dynamic>{
  'id': instance.id,
  'isDeleted': instance.isDeleted,
  'rowVersion': instance.rowVersion,
  'isActive': instance.isActive,
  'userId': instance.userId,
};
