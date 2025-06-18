import 'package:flutter/material.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;

  PermissionService._internal();

  Set<String> _permissions = {};
  bool _initialized = false;

  void loadPermissions(List<String> permissions) {
    _permissions = Set.unmodifiable(permissions);
    _initialized = true;
  }

  bool hasPermission(String permission) {
    if (!_initialized) {
      debugPrint('PermissionService not initialized yet!');
      return false; // or true if you want fail-open behavior
    }
    return _permissions.contains(permission);
  }
}
