import 'package:imis/user/services/roles_permission_service.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Set<String> _permissions = {};
  String? _roleName;

  void loadPermissions(List<String> permissions, String roleName) {
    _permissions = permissions.toSet();
    _roleName = roleName;
  }

  bool hasPermission(String permission, {List<String>? allowedRoles}) {
    if (allowedRoles != null) {
      return _permissions.contains(permission) &&
          allowedRoles.contains(_roleName);
    }
    return _permissions.contains(permission);
  }

  bool hasRoleIn(List<String> allowedRoles) {
    return _roleName != null && allowedRoles.contains(_roleName);
  }

  String? get currentRole => _roleName;
}

final rolesPermissionsService = RolesPermissionsService();
final permissionService = PermissionService();

Future<void> loadUserPermissions(String roleName) async {
  final roles = await rolesPermissionsService.fetchRolesPermissions();

  final role = roles.where((r) => r.name == roleName).toList();

  if (role.isNotEmpty) {
    permissionService.loadPermissions(role.first.permissions, role.first.name);
  } else {
    permissionService.loadPermissions([], roleName);
  }
}
