import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRoles {
  String? userId;

  @JsonKey()
  List<RoleAssignment>? roles;
  UserRoles(this.userId, this.roles);

  factory UserRoles.fromJson(Map<String, dynamic> json) =>
      _$UserRolesFromJson(json);
  Map<String, dynamic> toJson() => _$UserRolesToJson(this);
}

@JsonSerializable()
class RoleAssignment {
  final String roleId;

  RoleAssignment({required this.roleId});

  factory RoleAssignment.fromJson(Map<String, dynamic> json) =>
      _$RoleAssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$RoleAssignmentToJson(this);
}
