import 'package:flutter/material.dart';
import '../constant/constant.dart';

class PaginationControls extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final bool isLoading;
  final ValueChanged<int> onPageChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeTextColor;
  final Color inactiveTextColor;

  const PaginationControls({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    required this.isLoading,
    required this.onPageChanged,
    this.activeColor = primaryColor,
    this.inactiveColor = Colors.transparent,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = primaryTextColor,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalItems / itemsPerPage).ceil();
    final hasPreviousPage = currentPage > 1;
    final hasNextPage = currentPage < totalPages;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed:
              hasPreviousPage && !isLoading
                  ? () => onPageChanged(currentPage - 1)
                  : null,
          icon: const Icon(Icons.chevron_left),
          color: grey,
        ),

        ..._buildPageButtons(totalPages),

        IconButton(
          onPressed:
              hasNextPage && !isLoading
                  ? () => onPageChanged(currentPage + 1)
                  : null,
          icon: const Icon(Icons.chevron_right),
          color: grey,
        ),
      ],
    );
  }

  List<Widget> _buildPageButtons(int totalPages) {
    final buttons = <Widget>[];

    // Always show first page
    if (currentPage > 2) {
      buttons.add(_buildPageButton(1));
      if (currentPage > 3) {
        buttons.add(const Text('...', style: TextStyle(color: grey)));
      }
    }

    // Show pages around current page
    int startPage = currentPage - 1;
    int endPage = currentPage + 1;

    if (startPage < 1) startPage = 1;
    if (endPage > totalPages) endPage = totalPages;

    for (int i = startPage; i <= endPage; i++) {
      buttons.add(_buildPageButton(i));
    }

    // Always show last page if not in current range
    if (currentPage < totalPages - 1) {
      if (currentPage < totalPages - 2) {
        buttons.add(const Text('...', style: TextStyle(color: grey)));
      }
      buttons.add(_buildPageButton(totalPages));
    }

    return buttons;
  }

  Widget _buildPageButton(int page) {
    final isCurrent = page == currentPage;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: !isCurrent && !isLoading ? () => onPageChanged(page) : null,
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCurrent ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: isCurrent ? activeColor : lightGrey),
          ),
          alignment: Alignment.center,
          child: Text(
            '$page',
            style: TextStyle(
              color: isCurrent ? activeTextColor : inactiveTextColor,
            ),
          ),
        ),
      ),
    );
  }
}

class PaginationInfo extends StatelessWidget {
  final int currentPage;
  final int totalItems;
  final int itemsPerPage;
  final Color textColor;

  const PaginationInfo({
    super.key,
    required this.currentPage,
    required this.totalItems,
    required this.itemsPerPage,
    this.textColor = grey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Text(
        'Page $currentPage/${(totalItems / itemsPerPage).ceil()}',
        style: TextStyle(color: textColor),
      ),
    );
  }
}
