import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';

class IconBtn extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onTap;
  final double size;
  const IconBtn({
    required this.icon,
    required this.tooltip,
    required this.color,

    required this.onTap,
    this.size = 15,
  });

  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Icon(icon, size: size, color: color),
    ),
  );
}

class StepBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const StepBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(8),
    child: SizedBox(
      width: 36,
      height: 46,
      child: Icon(icon, size: 18, color: primaryColor),
    ),
  );
}

PopupProps<T> popupProps<T>(
  String hint,
  Widget Function(BuildContext, T, bool) builder,
) => PopupProps.menu(
  showSearchBox: true,
  searchFieldProps: TextFieldProps(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(color: kMuted, fontSize: 13),
      fillColor: kSurface,
      filled: true,
      prefixIcon: const Icon(Icons.search_rounded, size: 18, color: kMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: kBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
  ),
  itemBuilder: builder,
  menuProps: MenuProps(
    borderRadius: BorderRadius.circular(12),
    elevation: 8,
    shadowColor: Colors.black.withValues(alpha: 0.12),
  ),
);
