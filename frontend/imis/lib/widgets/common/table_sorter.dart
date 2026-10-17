import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class TableSorter<T> {
  final Map<String, Comparable Function(T item)> accessors;
  String? column;
  bool ascending;

  TableSorter({required this.accessors, this.column, this.ascending = true});

  bool isActive(String col) => column == col;

  void toggle(String col) {
    if (column == col) {
      ascending = !ascending;
    } else {
      column = col;
      ascending = true;
    }
  }

  void apply(List<T> list) {
    final get = accessors[column];
    if (get == null) return;
    list.sort((a, b) {
      final r = get(a).compareTo(get(b));
      return ascending ? r : -r;
    });
  }

  void reset() {
    column = null;
    ascending = true;
  }
}

class SortHeader<T> extends StatelessWidget {
  final String label;
  final String column;
  final TableSorter<T> sorter;
  final VoidCallback onChanged;
  final int? flex;
  final TextStyle? style;

  const SortHeader({
    super.key,
    required this.label,
    required this.column,
    required this.sorter,
    required this.onChanged,
    this.flex,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final active = sorter.isActive(column);

    final header = InkWell(
      onTap: () {
        sorter.toggle(column);
        onChanged();
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: (style ??
                      const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ))
                  .copyWith(color: active ? primaryColor : null),
            ),
          ),
          const SizedBox(width: 4),
          Icon(
            !active
                ? Icons.unfold_more
                : sorter.ascending
                ? Icons.arrow_upward
                : Icons.arrow_downward,
            size: 14,
            color: active ? primaryColor : Colors.grey,
          ),
        ],
      ),
    );

    return flex == null ? header : Expanded(flex: flex!, child: header);
  }
}
