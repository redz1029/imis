class PermissionService {
  static final PermissionService _instance = PermissionService._internal();

  factory PermissionService() => _instance;

  PermissionService._internal();

  Set<String> _permissions = {};

  void loadPermissions(List<String> permissions) {
    _permissions = Set.unmodifiable(permissions);
  }

  bool hasPermission(String permission) => _permissions.contains(permission);

  bool hasAny(List<String> permissions) {
    return permissions.any(_permissions.contains);
  }
}
