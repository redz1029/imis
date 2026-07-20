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

class _SearchableDropdownState<T> extends State<SearchDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<T> _filteredItems = [];
  String? _errorText;
  bool _isOpen = false;

  static const double _maxDropdownHeight = 260;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
  }

  @override
  void didUpdateWidget(covariant SearchDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedItem != widget.selectedItem) {
      setState(() {});
    }
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
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return;

    _filteredItems = widget.items;
    _searchController.clear();

    _overlayEntry = _createOverlayEntry(renderObject);
    Overlay.of(context).insert(_overlayEntry!);

    setState(() => _isOpen = true);

    Future.delayed(const Duration(milliseconds: 50), () {
      if (!mounted) return;
      _searchFocusNode.requestFocus();
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) {
      setState(() => _isOpen = false);
    } else {
      _isOpen = false;
    }
  }

  OverlayEntry _createOverlayEntry(RenderBox renderBox) {
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final spaceBelow = screenHeight - keyboardHeight - offset.dy - size.height;
    final spaceAbove = offset.dy;

    final showAbove =
        spaceBelow < _maxDropdownHeight && spaceAbove > spaceBelow;

    final availableSpace = showAbove ? spaceAbove : spaceBelow;
    final dropdownHeight = availableSpace.clamp(120.0, _maxDropdownHeight);

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
                targetAnchor:
                    showAbove ? Alignment.topLeft : Alignment.bottomLeft,
                followerAnchor:
                    showAbove ? Alignment.bottomLeft : Alignment.topLeft,
                offset: Offset(0, showAbove ? -4 : 4),
                child: GestureDetector(
                  onTap: () {},
                  child: Material(
                    color: Colors.transparent,
                    child: StatefulBuilder(
                      builder: (context, setOverlayState) {
                        return Container(
                          width: size.width,
                          constraints: BoxConstraints(
                            maxHeight: dropdownHeight,
                          ),
                          decoration: BoxDecoration(
                            color: kSurface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: kBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 20,
                                offset: Offset(0, showAbove ? -6 : 6),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!showAbove) ...[
                                _buildSearchField(setOverlayState),
                                Divider(height: 1, color: kBorder),
                                _buildList(setOverlayState),
                              ] else ...[
                                _buildList(setOverlayState),
                                Divider(height: 1, color: kBorder),
                                _buildSearchField(setOverlayState),
                              ],
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

  Widget _buildSearchField(StateSetter setOverlayState) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocusNode,
        style: GoogleFonts.plusJakartaSans(fontSize: 13, color: kText),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search...',
          hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: kMuted),
          prefixIcon: Icon(Icons.search, size: 18, color: kMuted),
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
            borderSide: BorderSide(color: primaryColor, width: 1.5),
          ),
        ),
        onChanged: (query) {
          if (!mounted) return;
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
    );
  }

  Widget _buildList(StateSetter setOverlayState) {
    return Flexible(
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
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: _filteredItems.length,
                itemBuilder: (context, index) {
                  final item = _filteredItems[index];
                  final isSelected = item == widget.selectedItem;
                  return InkWell(
                    onTap: () {
                      _removeOverlay();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (!mounted) return;
                        widget.onChanged(item);
                        setState(() {
                          _errorText = widget.validator?.call(item);
                        });
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      color:
                          isSelected
                              ? primaryColor.withValues(alpha: 0.08)
                              : Colors.transparent,
                      child: Text(
                        widget.itemAsString(item),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: isSelected ? primaryColor : kText,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ),
                  );
                },
              ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   final displayText =
  //       widget.selectedItem != null
  //           ? widget.itemAsString(widget.selectedItem as T)
  //           : null;

  //   final hasLabel = widget.label != null;
  //   final borderColor =
  //       _errorText != null ? kDanger : (_isOpen ? primaryColor : kBorder);

  //   return CompositedTransformTarget(
  //     link: _layerLink,
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         InkWell(
  //           onTap: _toggleOverlay,
  //           borderRadius: BorderRadius.circular(8),
  //           child: Stack(
  //             clipBehavior: Clip.none,
  //             children: [
  //               Container(
  //                 padding: EdgeInsets.only(
  //                   left: 14,
  //                   right: 14,
  //                   top: hasLabel ? 13 : 13,
  //                   bottom: hasLabel ? 13 : 13,
  //                 ),
  //                 decoration: BoxDecoration(
  //                   color:
  //                       widget.enabled
  //                           ? kBackground
  //                           : kBorder.withValues(alpha: 0.3),
  //                   borderRadius: BorderRadius.circular(8),
  //                   border: Border.all(
  //                     color: borderColor,
  //                     width: _isOpen ? 1.5 : 1,
  //                   ),
  //                 ),
  //                 child: AnimatedDefaultTextStyle(
  //                   duration: _labelAnimDuration,
  //                   curve: Curves.easeOut,
  //                   style: GoogleFonts.plusJakartaSans(
  //                     fontSize: 13,
  //                     color: displayText != null ? kText : kMuted,
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                         child: Text(
  //                           displayText ?? (hasLabel ? '' : widget.hintText),
  //                           overflow: TextOverflow.ellipsis,
  //                         ),
  //                       ),
  //                       Icon(Icons.keyboard_arrow_down_rounded, color: kMuted),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //               if (hasLabel)
  //                 AnimatedPositioned(
  //                   duration: _labelAnimDuration,
  //                   curve: Curves.easeOut,
  //                   left: 10,
  //                   top: _isFloating ? -8 : 15,
  //                   child: AnimatedDefaultTextStyle(
  //                     duration: _labelAnimDuration,
  //                     curve: Curves.easeOut,
  //                     style: GoogleFonts.plusJakartaSans(
  //                       fontSize: _isFloating ? 11 : 13,
  //                       fontWeight: FontWeight.w600,
  //                       color:
  //                           _errorText != null
  //                               ? kDanger
  //                               : (_isFloating ? primaryColor : kMuted),
  //                     ),
  //                     child: Container(
  //                       padding:
  //                           _isFloating
  //                               ? const EdgeInsets.symmetric(horizontal: 4)
  //                               : EdgeInsets.zero,
  //                       color: _isFloating ? kBackground : Colors.transparent,
  //                       child: Text(widget.label!),
  //                     ),
  //                   ),
  //                 ),
  //             ],
  //           ),
  //         ),
  //         if (_errorText != null) ...[
  //           const SizedBox(height: 4),
  //           Text(
  //             _errorText!,
  //             style: GoogleFonts.plusJakartaSans(fontSize: 11, color: kDanger),
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

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
          InkWell(
            onTap: _toggleOverlay,
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              isEmpty: displayText == null,
              isFocused: _isOpen,
              decoration: InputDecoration(
                labelText: widget.label,
                labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kMuted,
                ),
                floatingLabelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: _errorText != null ? kDanger : primaryColor,
                  fontWeight: FontWeight.w600,
                ),
                hintText: widget.label == null ? widget.hintText : null,
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: kMuted,
                ),
                filled: true,
                fillColor:
                    widget.enabled
                        ? Colors.grey.shade50
                        : kBorder.withValues(alpha: 0.3),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kBorder),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _errorText != null ? kDanger : kBorder,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _errorText != null ? kDanger : primaryColor,
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kDanger),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: kDanger, width: 1.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      displayText ?? '',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: displayText != null ? kText : kMuted,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: kMuted,
                  ),
                ],
              ),
            ),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 4),
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
