import 'package:flutter/material.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;

  PermissionService._internal();

  final ValueNotifier<Set<String>> _permissions = ValueNotifier<Set<String>>(
    {},
  );

  bool _initialized = false;

  void loadPermissions(List<String> permissions) {
    debugPrint('Loading permissions: $permissions');
    _permissions.value = Set.unmodifiable(permissions);
    _initialized = true;
  }

  bool hasPermission(String permission) {
    if (!_initialized) {
      debugPrint(
        'PermissionService not initialized yet! Checking for: $permission',
      );
      return false;
    }
    final hasPerm = _permissions.value.contains(permission);
    debugPrint('Checking permission $permission: $hasPerm');
    return hasPerm;
  }

  ValueNotifier<Set<String>> get permissionsNotifier => _permissions;
}
