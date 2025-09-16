// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roles_permissions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RolesPermissions _$RolesPermissionsFromJson(Map<String, dynamic> json) =>
    RolesPermissions(
      id: json['id'] as String,
      name: json['name'] as String,
      permissions:
          (json['permissions'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$RolesPermissionsToJson(RolesPermissions instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'permissions': instance.permissions,
    };
