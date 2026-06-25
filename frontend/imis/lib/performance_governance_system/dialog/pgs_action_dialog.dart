import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/performance_governance_system/enum/pgs_action_type.dart';

class PgsActionDialog extends StatelessWidget {
  final String title;
  final String content;
  final ActionType actionType;

  const PgsActionDialog({
    super.key,
    required this.title,
    required this.content,
    required this.actionType,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 380,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 32,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: config.iconBgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(config.icon, color: config.iconColor, size: 28),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w700,
                fontSize: 17,
                color: kText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: kMuted,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kBorder),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.plusJakartaSans(
                        color: kMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context, true),
                    icon: Icon(config.btnIcon, size: 16, color: Colors.white),
                    label: Text(
                      config.btnLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: config.btnColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _ActionConfig _getConfig() {
    switch (actionType) {
      case ActionType.draft:
        return _ActionConfig(
          icon: Icons.edit_note_rounded,
          iconColor: primaryColor,
          iconBgColor: primaryColor.withValues(alpha: 0.1),
          btnIcon: Icons.save_outlined,
          btnLabel: 'Save Draft',
          btnColor: primaryColor,
        );
      case ActionType.submit:
        return _ActionConfig(
          icon: Icons.send_rounded,
          iconColor: primaryColor,
          iconBgColor: primaryColor.withValues(alpha: 0.1),
          btnIcon: Icons.send_rounded,
          btnLabel: 'Submit',
          btnColor: primaryColor,
        );
      case ActionType.approve:
        return _ActionConfig(
          icon: Icons.check_circle_outline_rounded,
          iconColor: primaryColor,
          iconBgColor: primaryColor.withValues(alpha: 0.1),
          btnIcon: Icons.check_rounded,
          btnLabel: 'Approve',
          btnColor: primaryColor,
        );
      case ActionType.disapprove:
        return _ActionConfig(
          icon: Icons.cancel_outlined,
          iconColor: kDanger,
          iconBgColor: kDangerLight,
          btnIcon: Icons.close_rounded,
          btnLabel: 'Disapprove',
          btnColor: kDanger,
        );
    }
  }
}

class _ActionConfig {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final IconData btnIcon;
  final String btnLabel;
  final Color btnColor;

  const _ActionConfig({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.btnIcon,
    required this.btnLabel,
    required this.btnColor,
  });
}
