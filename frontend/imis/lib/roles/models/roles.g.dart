// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles(
  json['id'] as String,
  json['name'] as String,
  json['normalizedName'] as String,
  json['concurrencyStamp'] as String?,
);

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'normalizedName': instance.normalizedName,
  'concurrencyStamp': instance.concurrencyStamp,
};
