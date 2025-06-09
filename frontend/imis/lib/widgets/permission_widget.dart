import 'package:flutter/material.dart';

import '../utils/permission_service.dart';

class PermissionWidget extends StatelessWidget {
  final String permission;
  final Widget child;

  const PermissionWidget({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return PermissionService().hasPermission(permission)
        ? child
        : SizedBox.shrink();
  }
}
