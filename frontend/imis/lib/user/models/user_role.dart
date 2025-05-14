import 'package:imis/roles/models/roles.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRoles {
  final String userId;
  final String roleId;

  UserRoles({required this.userId, required this.roleId});

  factory UserRoles.fromJson(Map<String, dynamic> json) =>
      _$UserRolesFromJson(json);
  Map<String, dynamic> toJson() => _$UserRolesToJson(this);
}

@JsonSerializable()
class UserRolesGet {
  String userId;
  String userName;
  String firstName;
  String lastName;
  List<Roles>? roles;

  UserRolesGet(
    this.userId,
    this.userName,
    this.firstName,
    this.lastName,
    this.roles,
  );

  factory UserRolesGet.fromJson(Map<String, dynamic> json) =>
      _$UserRolesGetFromJson(json);
  Map<String, dynamic> toJson() => _$UserRolesGetToJson(this);
}
