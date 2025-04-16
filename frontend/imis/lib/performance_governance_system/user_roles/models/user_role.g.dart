// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserWithRoles _$UserWithRolesFromJson(Map<String, dynamic> json) =>
    UserWithRoles(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      firstName: json['firstName'] as String,
      middleName: json['middleName'] as String?,
      lastName: json['lastName'] as String,
      roles:
          (json['roles'] as List<dynamic>?)
              ?.map((e) => Role.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$UserWithRolesToJson(UserWithRoles instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'lastName': instance.lastName,
      'roles': instance.roles,
    };

Role _$RoleFromJson(Map<String, dynamic> json) => Role(
  roleId: json['roleId'] as String,
  roleName: json['roleName'] as String,
);

Map<String, dynamic> _$RoleToJson(Role instance) => <String, dynamic>{
  'roleId': instance.roleId,
  'roleName': instance.roleName,
};
