import 'package:imis/user/services/roles_permission_service.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  Map<String, bool> _permissions = {};
  String? _roleName;

  void loadPermissions(
    List<Map<String, dynamic>> permissions,
    String roleName,
  ) {
    _permissions = {
      for (var perm in permissions)
        perm['permission'] as String: perm['isAssigned'] as bool,
    };
    _roleName = roleName;
  }

  bool hasPermission(String permission, {List<String>? allowedRoles}) {
    final isAssigned = _permissions[permission] ?? false;
    if (allowedRoles != null && _roleName != null) {
      return isAssigned && allowedRoles.contains(_roleName);
    }
    return isAssigned;
  }

  String? get currentRole => _roleName;
}

final rolesPermissionsService = RolesPermissionsService();
final permissionService = PermissionService();

Future<void> loadUserPermissionss({
  required String userId,
  required String roleId,
}) async {
  try {
    final data = await rolesPermissionsService.fetchUserRolePermissions(
      userId,
      roleId,
    );

    if (data == null) {
      permissionService.loadPermissions([], "");
      return;
    }

    final List<dynamic> permissions = data['permissions'] ?? [];
    final String roleName = data['roleName'] ?? "";

    final permList =
        permissions
            .map<Map<String, dynamic>>(
              (perm) => {
                'permission': perm['permission'],
                'isAssigned': perm['isAssigned'],
              },
            )
            .toList();

    permissionService.loadPermissions(permList, roleName);
  } catch (e) {
    permissionService.loadPermissions([], "");
  }
}
