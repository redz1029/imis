// import 'package:flutter/material.dart';
// import 'package:imis/utils/permission_service.dart';

// final permissionService = PermissionService();

// class PermissionWidget extends StatelessWidget {
//   final String? permission;
//   final List<String>? allowedRoles;
//   final Widget child;
//   final bool ignorePermission;

//   const PermissionWidget({
//     super.key,
//     this.permission,
//     this.allowedRoles,
//     required this.child,
//     this.ignorePermission = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     if (ignorePermission) return child;

//     final hasPermission =
//         permission != null
//             ? permissionService.hasPermission(
//               permission!,
//               allowedRoles: allowedRoles,
//             )
//             : (allowedRoles != null
//                 ? allowedRoles!.contains(permissionService.currentRole)
//                 : true);

//     return hasPermission ? child : const SizedBox.shrink();
//   }
// }
import 'package:flutter/material.dart';
import 'package:imis/utils/permission_service.dart';

final permissionService = PermissionService();

class PermissionWidget extends StatelessWidget {
  final String? permission;
  final List<String>? allowedRoles;
  final Widget child;
  final Widget? fallback;
  final bool ignorePermission;

  const PermissionWidget({
    super.key,
    this.permission,
    this.allowedRoles,
    required this.child,
    this.fallback,
    this.ignorePermission = false,
  });

  @override
  Widget build(BuildContext context) {
    if (ignorePermission) return child;

    final hasPermission =
        permission != null
            ? permissionService.hasPermission(
              permission!,
              allowedRoles: allowedRoles,
            )
            : (allowedRoles != null
                ? allowedRoles!.contains(permissionService.currentRole)
                : true);

    return hasPermission ? child : (fallback ?? const SizedBox.shrink());
  }
}
