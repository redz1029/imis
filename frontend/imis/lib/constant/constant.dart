import 'package:flutter/material.dart';

//REUSABLE CODE//

//Colors
const primaryColor = Color.fromRGBO(192, 74, 74, 1);
const secondaryBgButton = Color.fromRGBO(192, 74, 74, 0.226);
const primaryLightColor = Color.fromRGBO(192, 74, 74, 0.644);
const secondaryColor = Color.fromRGBO(253, 252, 250, 1);
const mainBgColor = Color.fromRGBO(245, 245, 245, 1);
const grey = Color.fromRGBO(161, 161, 161, 1);
const lightGrey = Color.fromRGBO(217, 217, 217, 1);
const lightGrey1 = Color.fromRGBO(245, 245, 245, 1);
const primaryTextColor = Color.fromRGBO(65, 65, 65, 1);

//Sizing
const gap = SizedBox(height: 16);
const gap1 = SizedBox(height: 14);
const gap2 = SizedBox(height: 4);
const gap3 = SizedBox(height: 32);
const gap4 = SizedBox(width: 16);
const gap5 = SizedBox(height: 48);
const gap6 = SizedBox(height: 48);
const gap7 = SizedBox(height: 60);

//For Logo Widget
class Logo extends StatelessWidget {
  const Logo({super.key}); // Add a const constructor

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [Image.asset('assets/logo.png', width: 300)],
    );
  }
}

//buildHeaderCell for PGS
class BuildHeaderCell extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontStyle fontStyle;

  const BuildHeaderCell({
    super.key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 15,
    this.fontStyle = FontStyle.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize,
            color: color,
            fontStyle: fontStyle,
          ),
        ),
      ),
    );
  }
}

// Reusable Pagination Widget
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

// Pagination Info Widget (shows "Page X/Y")
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
//-------------------------------------------------------------------//