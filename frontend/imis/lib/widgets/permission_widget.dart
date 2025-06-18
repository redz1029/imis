import 'package:flutter/material.dart';
import 'package:imis/utils/permission_service.dart';

class PermissionWidget extends StatefulWidget {
  final String permission;
  final Widget child;

  const PermissionWidget({
    super.key,
    required this.permission,
    required this.child,
  });

  @override
  State<PermissionWidget> createState() => _PermissionWidgetState();
}

class _PermissionWidgetState extends State<PermissionWidget> {
  @override
  Widget build(BuildContext context) {
    final hasPermission = PermissionService().hasPermission(widget.permission);

    return hasPermission ? widget.child : const SizedBox.shrink();
  }
}
