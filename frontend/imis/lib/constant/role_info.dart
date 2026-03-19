import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/utils/permission_string.dart';

RoleInfo getRoleInfo(String role) {
  switch (role) {
    case PermissionString.roleAdmin:
      return RoleInfo(
        icon: Icons.admin_panel_settings_outlined,
        iconColor: Colors.green,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Full system access with complete control over all features and settings",
      );
    case PermissionString.roleStandardUser:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.blue,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Personal workspace where you can create and manage your deliverables",
      );
    case PermissionString.pgsAuditor:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.deepOrange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Oversee deliverables and conduct evaluations through scoring and performance assessment.",
      );
    case PermissionString.serviceHead:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.deepPurple,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Responsible for reviewing progress and approving submitted deliverables.",
      );
    case PermissionString.coreTeam:
      return RoleInfo(
        icon: Icons.diversity_1_outlined,
        iconColor: Colors.teal,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Assist in managing deliverables and reviewing progress of assigned activities.",
      );
    case PermissionString.mcc:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.pink,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Responsible for reviewing progress and approving key deliverables.",
      );
    case PermissionString.osm:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.purpleAccent,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Responsible for reviewing progress and approving submitted deliverables.",
      );
    case PermissionString.headAuditor:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.indigoAccent,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Responsible for reviewing progress and approving submitted deliverables.",
      );
    case PermissionString.financeOfficer:
      return RoleInfo(
        icon: Icons.wallet_outlined,
        iconColor: Colors.orangeAccent,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the point person for financial stewardship, tracking budgets, and guiding the financial roadmap.",
      );
    case PermissionString.serviceOfficer:
      return RoleInfo(
        icon: Icons.volunteer_activism_outlined,
        iconColor: Colors.redAccent,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description: "Serve as the primary point person for service operations",
      );
    case PermissionString.trainingOfficer:
      return RoleInfo(
        icon: Icons.school_outlined,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Coordinate and oversee training programs, serving as the point person for all training activities.",
      );
    case PermissionString.hrOfficer:
      return RoleInfo(
        icon: Icons.work_outline,
        iconColor: Colors.lightGreen,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Main point person for human resource activities and personnel matters.",
      );
    case PermissionString.safetyOfficer:
      return RoleInfo(
        icon: Icons.shield_outlined,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the primary point of contact for safety, ensuring compliance with protocols and safe operations.",
      );
    case PermissionString.linkagesOfficer:
      return RoleInfo(
        icon: Icons.route,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the point person for organizational linkages and external partnerships.",
      );
    case PermissionString.facilityOfficer:
      return RoleInfo(
        icon: Icons.engineering_outlined,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the point person for infrastructure, equipment, and facility-related matters.",
      );
    case PermissionString.informationOfficer:
      return RoleInfo(
        icon: Icons.computer,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the point person for information technology and IT-related resources.",
      );
    case PermissionString.researchOfficer:
      return RoleInfo(
        icon: Icons.content_paste_search,
        iconColor: Colors.orange,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description:
            "Serve as the point person for research activities and initiatives.",
      );
    default:
      return RoleInfo(
        icon: Icons.person_outline,
        iconColor: Colors.grey,
        backgroundColor: mainBgColor,
        borderColor: Colors.grey.shade300,
        textColor: Colors.black,
        description: "Role description not set",
      );
  }
}

class RoleInfo {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final String description;

  RoleInfo({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.description,
  });
}

class RoleIconBox extends StatelessWidget {
  final RoleInfo roleInfo;
  final double size;
  final double opacity;

  const RoleIconBox({
    super.key,
    required this.roleInfo,
    this.size = 60.0,
    this.opacity = 0.08,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: roleInfo.iconColor.withOpacity(opacity),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Icon(roleInfo.icon, color: roleInfo.iconColor, size: size * 0.5),
      ),
    );
  }
}
