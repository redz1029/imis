import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';

Widget sectionLabel(String label, IconData icon) => Row(
  children: [
    Icon(icon, size: 14, color: primaryColor),
    const SizedBox(width: 6),
    Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: kMuted,
        letterSpacing: 0.5,
      ),
    ),
  ],
);

class DialogFooter extends StatelessWidget {
  final VoidCallback onCancel, onConfirm;
  final String confirmLabel;
  final IconData confirmIcon;
  const DialogFooter({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.confirmLabel,
    required this.confirmIcon,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(24, 14, 24, 20),
    decoration: const BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
      border: Border(top: BorderSide(color: kBorder)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: onCancel,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kBorder),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            'Cancel',
            style: GoogleFonts.plusJakartaSans(
              color: kMuted,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onConfirm,
          icon: Icon(confirmIcon, size: 16, color: Colors.white),
          label: Text(
            confirmLabel,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    ),
  );
}

DropDownDecoratorProps ddProps(String label) =>
    DropDownDecoratorProps(dropdownSearchDecoration: field(label));
InputDecoration field(String label, {Widget? prefix}) => InputDecoration(
  labelText: label,
  prefixIcon: prefix,
  filled: true,
  fillColor: kBackground,
  labelStyle: GoogleFonts.plusJakartaSans(
    color: kMuted,
    fontSize: 13,
    fontWeight: FontWeight.w500,
  ),
  floatingLabelStyle: GoogleFonts.plusJakartaSans(
    color: primaryColor,
    fontSize: 12,
    fontWeight: FontWeight.w600,
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kBorder),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kBorder),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: primaryColor, width: 1.5),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: kDanger),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
);
Widget skeleton() => ListView.separated(
  itemCount: 5,
  separatorBuilder: (_, __) => const SizedBox(height: 8),
  itemBuilder:
      (_, __) => Container(
        height: 68,
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: kBackground,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 13,
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 100,
                  height: 10,
                  decoration: BoxDecoration(
                    color: kBackground,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
);
