import 'package:imis/performance_governance_system/roles/models/roles.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_with_roles.g.dart';

@JsonSerializable(explicitToJson: true)
class UserWithRoles {
  final String userId;
  final String userName;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final List<Roles> roles;

  UserWithRoles({
    required this.userId,
    required this.userName,
    this.firstName,
    this.middleName,
    this.lastName,
    required this.roles,
  });

  factory UserWithRoles.fromJson(Map<String, dynamic> json) =>
      _$UserWithRolesFromJson(json);

  Map<String, dynamic> toJson() => _$UserWithRolesToJson(this);
}