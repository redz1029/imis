import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

Widget buildPageHeader({
  required bool isMobile,
  required String title,
  required int totalCount,
  required String itemLabel,
  required IconData icon,
  Widget? actionButton,
}) {
  return Container(
    width: double.infinity,
    color: Colors.white,
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: primaryColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1D23),
                    ),
                  ),
                  Text(
                    "$totalCount $itemLabel${totalCount != 1 ? 's' : ''} found",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            if (!isMobile && actionButton != null) actionButton,
          ],
        ),
        const SizedBox(height: 16),
      ],
    ),
  );
}
