import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserWithRoles {
  String userId;
  String userName;
  String firstName;
  String? middleName;
  String lastName;
  List<Role>? roles;

  UserWithRoles({
    required this.userId,
    required this.userName,
    required this.firstName,
    this.middleName,
    required this.lastName,
    required this.roles,
  });

  factory UserWithRoles.fromJson(Map<String, dynamic> json) =>
      _$UserWithRolesFromJson(json);
  Map<String, dynamic> toJson() => _$UserWithRolesToJson(this);
}

@JsonSerializable()
class Role {
  String roleId;
  String roleName;

  Role({required this.roleId, required this.roleName});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);
  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
