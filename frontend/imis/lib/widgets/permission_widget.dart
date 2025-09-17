import 'package:flutter/material.dart';
import 'package:imis/utils/permission_service.dart';

class PermissionWidget extends StatelessWidget {
  final String? permission;
  final List<String>? allowedRoles;
  final Widget child;

  const PermissionWidget({
    super.key,
    this.permission,
    this.allowedRoles,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final hasPermission =
        permission != null
            ? permissionService.hasPermission(permission!)
            : true;

    final roleAllowed =
        allowedRoles != null
            ? permissionService.hasRoleIn(allowedRoles!)
            : true;

    return (hasPermission && roleAllowed) ? child : const SizedBox.shrink();
  }
}
