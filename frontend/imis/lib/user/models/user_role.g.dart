// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoles _$UserRolesFromJson(Map<String, dynamic> json) => UserRoles(
  json['userId'] as String?,
  (json['roles'] as List<dynamic>?)
      ?.map((e) => RoleAssignment.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserRolesToJson(UserRoles instance) => <String, dynamic>{
  'userId': instance.userId,
  'roles': instance.roles,
};

RoleAssignment _$RoleAssignmentFromJson(Map<String, dynamic> json) =>
    RoleAssignment(roleId: json['roleId'] as String);

Map<String, dynamic> _$RoleAssignmentToJson(RoleAssignment instance) =>
    <String, dynamic>{'roleId': instance.roleId};
