import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';
import 'package:imis/office/models/office.dart';
import 'package:imis/performance_governance_system/enum/pgs_status.dart';

Widget statusDropdown({
  required String label,
  required PgsStatus value,
  required Function(PgsStatus?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<PgsStatus>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      items:
          PgsStatus.values.map((status) {
            return DropdownMenuItem<PgsStatus>(
              value: status,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: statusColor(status),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(statusLabel(status)),
                ],
              ),
            );
          }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget serviceDropdown({
  required String label,
  required Office? value,
  required List<Office> items,
  required Function(Office?) onChanged,
  bool hasError = false,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: DropdownButtonFormField<Office>(
      value: value,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: '$label *',
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: Colors.grey.shade50,
        errorText: hasError ? '$label is required' : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(
            color: hasError ? Colors.red : Colors.grey.shade300,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      items:
          items.map((service) {
            return DropdownMenuItem<Office>(
              value: service,
              child: Row(
                children: [
                  const Icon(
                    Icons.miscellaneous_services_outlined,
                    size: 14,
                    color: primaryColor,
                  ),
                  const SizedBox(width: 8),
                  // ← Flexible removed, Text lang with overflow
                  Expanded(
                    child: Text(
                      service.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      onChanged: onChanged,
    ),
  );
}
