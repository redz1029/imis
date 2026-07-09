import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';

class SearchDropdown<T> extends StatefulWidget {
  final String? label;
  final String hintText;
  final List<T> items;
  final String Function(T item) itemAsString;
  final T? selectedItem;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final bool enabled;

  const SearchDropdown({
    super.key,
    this.label,
    required this.hintText,
    required this.items,
    required this.itemAsString,
    required this.selectedItem,
    required this.onChanged,
    this.validator,
    this.enabled = true,
  });

  @override
  State<SearchDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<T> _filteredItems = [];
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _removeOverlay();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleOverlay() {
    if (!widget.enabled) return;
    if (_overlayEntry == null) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }

  void _showOverlay() {
    _filteredItems = widget.items;
    _searchController.clear();

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    Future.delayed(Duration(milliseconds: 50), () {
      _searchFocusNode.requestFocus();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: _removeOverlay,
          child: Stack(
            children: [
              Positioned.fill(child: Container(color: Colors.transparent)),
              CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: GestureDetector(
                  onTap: () {}, // absorb taps so it doesn't close itself
                  child: Material(
                    color: Colors.transparent,
                    child: StatefulBuilder(
                      builder: (context, setOverlayState) {
                        return Container(
                          width: size.width,
                          constraints: BoxConstraints(maxHeight: 260),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 16,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: TextField(
                                  controller: _searchController,
                                  focusNode: _searchFocusNode,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: kText,
                                  ),
                                  decoration: InputDecoration(
                                    isDense: true,
                                    hintText: 'Search...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: kMuted,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      size: 18,
                                      color: kMuted,
                                    ),
                                    filled: true,
                                    fillColor: kBackground,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: kBorder),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: kBorder),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                  onChanged: (query) {
                                    setOverlayState(() {
                                      _filteredItems =
                                          widget.items.where((item) {
                                            return widget
                                                .itemAsString(item)
                                                .toLowerCase()
                                                .contains(query.toLowerCase());
                                          }).toList();
                                    });
                                  },
                                ),
                              ),
                              Divider(height: 1, color: kBorder),
                              Flexible(
                                child:
                                    _filteredItems.isEmpty
                                        ? Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Text(
                                            'No results found',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13,
                                              color: kMuted,
                                            ),
                                          ),
                                        )
                                        : ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          itemCount: _filteredItems.length,
                                          itemBuilder: (context, index) {
                                            final item = _filteredItems[index];
                                            final isSelected =
                                                item == widget.selectedItem;
                                            return InkWell(
                                              onTap: () {
                                                widget.onChanged(item);
                                                setState(() {
                                                  _errorText = widget.validator
                                                      ?.call(item);
                                                });
                                                _removeOverlay();
                                              },
                                              child: Container(
                                                width: double.infinity,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 14,
                                                      vertical: 12,
                                                    ),
                                                color:
                                                    isSelected
                                                        ? primaryColor
                                                            .withValues(
                                                              alpha: 0.08,
                                                            )
                                                        : Colors.transparent,
                                                child: Text(
                                                  widget.itemAsString(item),
                                                  style:
                                                      GoogleFonts.plusJakartaSans(
                                                        fontSize: 13,
                                                        color:
                                                            isSelected
                                                                ? primaryColor
                                                                : kText,
                                                        fontWeight:
                                                            isSelected
                                                                ? FontWeight
                                                                    .w600
                                                                : FontWeight
                                                                    .w400,
                                                      ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayText =
        widget.selectedItem != null
            ? widget.itemAsString(widget.selectedItem as T)
            : null;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kMuted,
              ),
            ),
            SizedBox(height: 6),
          ],
          InkWell(
            onTap: _toggleOverlay,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
              decoration: BoxDecoration(
                color:
                    widget.enabled
                        ? kBackground
                        : kBorder.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _errorText != null ? kDanger : kBorder,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      displayText ?? widget.hintText,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: displayText != null ? kText : kMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, color: kMuted),
                ],
              ),
            ),
          ),
          if (_errorText != null) ...[
            SizedBox(height: 4),
            Text(
              _errorText!,
              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kDanger),
            ),
          ],
        ],
      ),
    );
  }
}
