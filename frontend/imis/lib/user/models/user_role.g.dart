// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserRoles _$UserRolesFromJson(Map<String, dynamic> json) => UserRoles(
  userId: json['userId'] as String,
  roleId: json['roleId'] as String,
);

Map<String, dynamic> _$UserRolesToJson(UserRoles instance) => <String, dynamic>{
  'userId': instance.userId,
  'roleId': instance.roleId,
};

UserRolesGet _$UserRolesGetFromJson(Map<String, dynamic> json) => UserRolesGet(
  json['userId'] as String,
  json['userName'] as String,
  json['firstName'] as String,
  json['lastName'] as String,
  (json['roles'] as List<dynamic>?)
      ?.map((e) => Roles.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UserRolesGetToJson(UserRolesGet instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'roles': instance.roles,
    };
