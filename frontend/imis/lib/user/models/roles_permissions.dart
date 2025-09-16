import 'package:json_annotation/json_annotation.dart';

part 'roles_permissions.g.dart';

@JsonSerializable(explicitToJson: true)
class RolesPermissions {
  final String id;
  final String name;
  final List<String> permissions;

  RolesPermissions({
    required this.id,
    required this.name,
    required this.permissions,
  });

  factory RolesPermissions.fromJson(Map<String, dynamic> json) =>
      _$RolesPermissionsFromJson(json);
  Map<String, dynamic> toJson() => _$RolesPermissionsToJson(this);
}
