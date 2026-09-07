import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class SearchUnderlineDropdown<T> extends StatefulWidget {
  final List<T> items;
  final String Function(T item) itemLabel;
  final T? selectedValue;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String? Function(T? value)? validator;
  final double maxPopupHeight;

  const SearchUnderlineDropdown({
    super.key,
    required this.items,
    required this.itemLabel,
    required this.selectedValue,
    required this.onChanged,
    this.hintText = 'Select',
    this.validator,
    this.maxPopupHeight = 280,
  });

  @override
  State<SearchUnderlineDropdown<T>> createState() =>
      SearchUnderlineDropdownState<T>();
}

class SearchUnderlineDropdownState<T>
    extends State<SearchUnderlineDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final TextEditingController _searchCtrl = TextEditingController();
  List<T> _filteredItems = [];
  bool _isOpen = false;

  String get _selectedLabel {
    if (widget.selectedValue == null) return '';
    final match = widget.items.where((i) => i == widget.selectedValue);
    return match.isEmpty ? '' : widget.itemLabel(match.first);
  }

  void _openDropdown() {
    if (widget.items.isEmpty) return;
    _filteredItems = List.from(widget.items);
    _searchCtrl.clear();
    _overlayEntry = _buildOverlay();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isOpen = false);
  }

  void _filter(String query) {
    _filteredItems =
        widget.items
            .where(
              (item) => widget
                  .itemLabel(item)
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
    _overlayEntry?.markNeedsBuild();
  }

  OverlayEntry _buildOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final fieldOffset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    final popupHeight = widget.maxPopupHeight;
    const bottomPadding = 20.0;
    final spaceBelow =
        screenHeight - fieldOffset.dy - size.height - bottomPadding;
    final spaceAbove = fieldOffset.dy - bottomPadding;
    final openUpward = spaceBelow < popupHeight && spaceAbove > spaceBelow;

    return OverlayEntry(
      builder:
          (context) => Stack(
            children: [
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _closeDropdown,
                ),
              ),
              Positioned(
                width: size.width < 260 ? 260 : size.width,
                child: CompositedTransformFollower(
                  link: _layerLink,
                  showWhenUnlinked: false,
                  targetAnchor:
                      openUpward ? Alignment.topLeft : Alignment.bottomLeft,
                  followerAnchor:
                      openUpward ? Alignment.bottomLeft : Alignment.topLeft,
                  offset: Offset(0, openUpward ? -4 : 8),
                  child: Material(
                    elevation: 6,
                    borderRadius: BorderRadius.circular(8),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight:
                            openUpward
                                ? spaceAbove.clamp(150, popupHeight)
                                : spaceBelow.clamp(150, popupHeight),
                        minWidth: 260,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: TextField(
                                controller: _searchCtrl,
                                autofocus: true,
                                style: const TextStyle(fontSize: 14),
                                decoration: InputDecoration(
                                  isDense: true,
                                  hintText: 'Search...',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 20,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    borderSide: BorderSide(
                                      color: primaryColor,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                onChanged: _filter,
                              ),
                            ),
                            const Divider(height: 1),
                            Flexible(
                              child: StatefulBuilder(
                                builder: (context, setOverlayState) {
                                  return _filteredItems.isEmpty
                                      ? const Padding(
                                        padding: EdgeInsets.all(16),
                                        child: Text(
                                          'No results found',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      )
                                      : ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.zero,
                                        itemCount: _filteredItems.length,
                                        itemBuilder: (context, i) {
                                          final item = _filteredItems[i];
                                          final isSelected =
                                              item == widget.selectedValue;
                                          return InkWell(
                                            onTap: () {
                                              widget.onChanged(item);
                                              _closeDropdown();
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 14,
                                                    vertical: 14,
                                                  ),
                                              color:
                                                  isSelected
                                                      ? primaryColor
                                                          .withOpacity(0.08)
                                                      : Colors.transparent,
                                              child: Text(
                                                widget.itemLabel(item),
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.black87,
                                                  fontWeight:
                                                      isSelected
                                                          ? FontWeight.w600
                                                          : FontWeight.normal,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap:
            widget.items.isEmpty
                ? null
                : (_isOpen ? _closeDropdown : _openDropdown),
        child: FormField<T>(
          initialValue: widget.selectedValue,
          validator: widget.validator,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color:
                            state.hasError
                                ? Colors.red
                                : (_isOpen
                                    ? primaryColor
                                    : Colors.grey.shade400),
                        width: state.hasError || _isOpen ? 1.5 : 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedLabel.isEmpty
                              ? widget.hintText
                              : _selectedLabel,
                          style: TextStyle(
                            fontSize: _selectedLabel.isEmpty ? 12 : 13,
                            color:
                                _selectedLabel.isEmpty
                                    ? Colors.grey
                                    : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 11),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
