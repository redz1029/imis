import 'package:flutter/material.dart';
import 'package:imis/constant/constant.dart';

class FilterBottomSheet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const FilterBottomSheet({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 4),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: Colors.grey.shade600,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Flexible(child: child),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isRequired;
  final bool isEnabled;
  final VoidCallback? onTap;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.icon,
    this.isActive = false,
    this.isRequired = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color:
              isActive
                  ? primaryColor.withOpacity(0.08)
                  : !isEnabled
                  ? Colors.grey.shade50
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color:
                isActive
                    ? primaryColor.withOpacity(0.4)
                    : isRequired && !isActive
                    ? Colors.orangeAccent
                    : Colors.grey.shade300,
            width: isActive ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color:
                  isActive
                      ? primaryColor
                      : isRequired && !isActive
                      ? Colors.orange.shade600
                      : Colors.grey.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color:
                    isActive
                        ? primaryColor
                        : isRequired && !isActive
                        ? Colors.orange.shade700
                        : Colors.grey.shade700,
              ),
            ),
            if (isRequired && !isActive) ...[
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Required',
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 14,
              color: isActive ? primaryColor : Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
