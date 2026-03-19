import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SearchableDropdown extends StatelessWidget {
  final List<String> items;
  final String selectedItem;
  final ValueChanged<String> onChanged;
  final String hintText;
  final String searchHint;

  const SearchableDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    this.hintText = "Select item",
    this.searchHint = "Search...",
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      items: items,
      selectedItem: selectedItem,

      dropdownBuilder: (context, selectedItem) {
        return Text(
          selectedItem!.isNotEmpty ? selectedItem : hintText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14),
        );
      },

      popupProps: PopupProps.menu(
        showSearchBox: true,
        constraints: const BoxConstraints(maxHeight: 350),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: searchHint,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 8,
            ),
          ),
        ),
      ),

      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Theme.of(context).cardColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide.none,
          ),
        ),
      ),

      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(Icons.keyboard_arrow_down, size: 18),
        padding: EdgeInsets.zero,
      ),

      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
