import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final String? awaiting;
  final String tooltip;
  final VoidCallback? onTap;

  const StatusBadge({
    super.key,
    required this.label,
    this.awaiting,
    this.tooltip = 'View approval timeline',
    this.onTap,
  });

  ({Color bg, Color fg}) get _colors {
    switch (label) {
      case 'Approved':
        return (bg: const Color(0xFFE6F9F0), fg: const Color(0xFF10B981));
      case 'Pending':
        return (bg: const Color(0xFFFFF1E6), fg: const Color(0xFFF97316));
      default:
        return (bg: const Color(0xFFEEEFF2), fg: const Color(0xFF6B7280));
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _colors;
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: c.fg, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: c.fg,
            ),
          ),
        ],
      ),
    );

    final hasAwaiting = label == 'Pending' && (awaiting?.isNotEmpty ?? false);

    return Tooltip(
      message: tooltip,
      child: MouseRegion(
        cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              pill,
              if (hasAwaiting) ...[
                const SizedBox(height: 3),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Awaiting ',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      TextSpan(
                        text: awaiting,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
