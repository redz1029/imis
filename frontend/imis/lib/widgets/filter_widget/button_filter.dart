// import 'package:flutter/material.dart';
// import 'package:dropdown_search/dropdown_search.dart';

// class SearchableDropdown extends StatelessWidget {
//   final List<String> items;
//   final String? selectedItem;
//   final ValueChanged<String> onChanged;
//   final String hintText;
//   final String searchHint;
//   final IconData? prefixIcon;
//   final Color? activeColor;
//   final String? defaultValue; // optional: treat this value as "inactive"

//   const SearchableDropdown({
//     super.key,
//     required this.items,
//     this.selectedItem,
//     required this.onChanged,
//     this.hintText = "Select item",
//     this.searchHint = "Search...",
//     this.prefixIcon,
//     this.activeColor,
//     this.defaultValue,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // Not active if: null, empty, starts with "all", or matches defaultValue
//     final isActive =
//         selectedItem != null &&
//         selectedItem!.isNotEmpty &&
//         !selectedItem!.toLowerCase().startsWith('all') &&
//         selectedItem != defaultValue;

//     final color = activeColor ?? Theme.of(context).primaryColor;
//     final fillColor = isActive ? color.withValues(alpha: 0.08) : Colors.white;
//     final borderColor =
//         isActive ? color.withValues(alpha: 0.5) : Colors.grey.shade300;
//     final contentColor = isActive ? color : Colors.grey.shade600;

//     return DropdownSearch<String>(
//       items: items,
//       selectedItem: selectedItem,

//       dropdownBuilder: (context, selected) {
//         return Row(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (prefixIcon != null) ...[
//               Icon(prefixIcon, size: 14, color: contentColor),
//               const SizedBox(width: 8),
//             ],
//             Text(
//               (selected != null && selected.isNotEmpty) ? selected : hintText,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: TextStyle(
//                 fontSize: 13,
//                 color: contentColor,
//                 fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
//               ),
//             ),
//           ],
//         );
//       },

//       popupProps: PopupProps.menu(
//         showSearchBox: true,
//         constraints: const BoxConstraints(maxHeight: 300),
//         menuProps: MenuProps(
//           borderRadius: BorderRadius.circular(12),
//           elevation: 4,
//           shadowColor: Colors.black12,
//         ),
//         searchFieldProps: TextFieldProps(
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: searchHint,
//             hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
//             prefixIcon: Icon(
//               Icons.search,
//               size: 16,
//               color: Colors.grey.shade400,
//             ),
//             prefixIconConstraints: const BoxConstraints(minWidth: 36),
//             isDense: true,
//             filled: true,
//             fillColor: Colors.grey.shade50,
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 10,
//               vertical: 8,
//             ),
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             enabledBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: Colors.grey.shade200),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(8),
//               borderSide: BorderSide(color: color),
//             ),
//           ),
//         ),
//         itemBuilder:
//             (context, item, isSelected) => Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Text(
//                       item,
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: isSelected ? color : Colors.black87,
//                         fontWeight:
//                             isSelected ? FontWeight.w500 : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                   if (isSelected) Icon(Icons.check, size: 14, color: color),
//                 ],
//               ),
//             ),
//       ),

//       dropdownDecoratorProps: DropDownDecoratorProps(
//         dropdownSearchDecoration: InputDecoration(
//           isDense: true,
//           filled: true,
//           fillColor: fillColor,
//           contentPadding: const EdgeInsets.only(
//             left: 14,
//             right: 4,
//             top: 8,
//             bottom: 8,
//           ),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: borderColor, width: 0.8),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: borderColor, width: 0.8),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(color: color, width: 1),
//           ),
//         ),
//       ),

//       dropdownButtonProps: DropdownButtonProps(
//         icon: Icon(Icons.keyboard_arrow_down, size: 16, color: contentColor),
//         padding: const EdgeInsets.only(right: 10),
//       ),

//       onChanged: (value) {
//         if (value != null) onChanged(value);
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String> onChanged;
  final String hintText;
  final String searchHint;
  final IconData? prefixIcon;
  final Color? activeColor;
  final String? defaultValue;

  const SearchableDropdown({
    super.key,
    required this.items,
    this.selectedItem,
    required this.onChanged,
    this.hintText = "Select item",
    this.searchHint = "Search...",
    this.prefixIcon,
    this.activeColor,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    final isActive =
        selectedItem != null &&
        selectedItem!.isNotEmpty &&
        !selectedItem!.toLowerCase().startsWith('all') &&
        selectedItem != defaultValue;

    final color = activeColor ?? Theme.of(context).primaryColor;
    final fillColor = isActive ? color.withValues(alpha: 0.08) : Colors.white;
    final borderColor =
        isActive ? color.withValues(alpha: 0.5) : Colors.grey.shade300;
    final contentColor = isActive ? color : Colors.grey.shade600;

    return DropdownSearch<String>(
      items: items,
      selectedItem: selectedItem,

      dropdownBuilder: (context, selected) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (prefixIcon != null) ...[
              Icon(prefixIcon, size: 14, color: contentColor),
              const SizedBox(width: 8),
            ],
            Text(
              (selected != null && selected.isNotEmpty) ? selected : hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: contentColor,
                fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        );
      },

      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: const BoxConstraints(maxHeight: 300),
        menuProps: MenuProps(
          borderRadius: BorderRadius.circular(12),
          elevation: 4,
          shadowColor: Colors.black12,
        ),
        searchFieldProps: TextFieldProps(
          autofocus: true,
          decoration: InputDecoration(
            hintText: searchHint,
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            prefixIcon: Icon(
              Icons.search,
              size: 16,
              color: Colors.grey.shade400,
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 36),
            isDense: true,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: color),
            ),
          ),
        ),
        itemBuilder:
            (context, item, isSelected) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: 13,
                        color: isSelected ? color : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.normal,
                      ),
                    ),
                  ),
                  if (isSelected) Icon(Icons.check, size: 14, color: color),
                ],
              ),
            ),
      ),

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.only(
            left: 14,
            right: 4,
            top: 8,
            bottom: 8,
          ),
          // ✅ Changed from 20 → 8 to match the image style
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor, width: 0.8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor, width: 0.8),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: color, width: 1),
          ),
        ),
      ),

      dropdownButtonProps: DropdownButtonProps(
        icon: Icon(Icons.keyboard_arrow_down, size: 16, color: contentColor),
        padding: const EdgeInsets.only(right: 10),
      ),

      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
