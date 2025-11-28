import 'package:json_annotation/json_annotation.dart';

part 'user_permission.g.dart';

@JsonSerializable()
class UserPermission {
  final String id;
  final String userName;
  final List<String> permissions;

  UserPermission({
    required this.id,
    required this.userName,
    required this.permissions,
  });

  factory UserPermission.fromJson(Map<String, dynamic> json) =>
      _$UserPermissionFromJson(json);
  Map<String, dynamic> toJson() => _$UserPermissionToJson(this);
}
