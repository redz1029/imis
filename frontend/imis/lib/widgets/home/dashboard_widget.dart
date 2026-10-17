import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imis/constant/constant.dart';

class BarEntry {
  final String label;
  final int value;
  final IconData icon;
  final Color color;

  BarEntry(this.label, this.value, this.icon, this.color);
}

class DonutPainter extends CustomPainter {
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  DonutPainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final bgPaint =
        Paint()
          ..color = backgroundColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final fgPaint =
        Paint()
          ..color = progressColor
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final sweepAngle = 2 * math.pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant DonutPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class DonutSegment {
  final String label;
  final int value;
  final Color color;

  DonutSegment(this.label, this.value, this.color);
}

class MultiDonutPainter extends CustomPainter {
  final List<DonutSegment> segments;
  final int total;
  final double strokeWidth;
  final double animationProgress;

  MultiDonutPainter({
    required this.segments,
    required this.total,
    required this.strokeWidth,
    required this.animationProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    if (total <= 0) {
      final emptyPaint =
          Paint()
            ..color = Colors.grey.shade200
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;
      canvas.drawCircle(center, radius, emptyPaint);
      return;
    }

    double startAngle = -math.pi / 2;

    for (final segment in segments) {
      if (segment.value <= 0) continue;

      final sweepAngle =
          (segment.value / total) * 2 * math.pi * animationProgress;

      final paint =
          Paint()
            ..color = segment.color
            ..strokeWidth = strokeWidth
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += (segment.value / total) * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant MultiDonutPainter oldDelegate) =>
      oldDelegate.animationProgress != animationProgress ||
      oldDelegate.segments != segments;
}

class ChartBarEntry {
  final String label;
  final int value;
  final Color color;

  ChartBarEntry(this.label, this.value, this.color);
}

class GridChart extends StatelessWidget {
  final List<ChartBarEntry> entries;
  final int maxValue;
  final double barAreaHeight;
  final double barWidth;

  const GridChart({
    super.key,
    required this.entries,
    required this.maxValue,
    this.barAreaHeight = 190,
    this.barWidth = 32,
  });

  List<int> get _gridSteps {
    final step = (maxValue / 4).ceil();
    final niceStep = step <= 0 ? 1 : step;
    return List.generate(5, (i) => niceStep * i);
  }

  @override
  Widget build(BuildContext context) {
    final steps = _gridSteps;
    final chartMax = steps.last == 0 ? 1 : steps.last;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 26,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                steps.reversed
                    .map(
                      (s) => Text(
                        s.toString(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    )
                    .toList(),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _GridBackgroundPainter(
                    lineCount: steps.length,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:
                      entries.map((e) => _verticalBar(e, chartMax)).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _verticalBar(ChartBarEntry entry, int maxValue) {
    final ratio = maxValue > 0 ? entry.value / maxValue : 0.0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            entry.value.toString(),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: barAreaHeight,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ratio.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return FractionallySizedBox(
                    heightFactor: value == 0 ? 0.01 : value,
                    child: Container(
                      width: barWidth,
                      decoration: BoxDecoration(
                        color: entry.color,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(4),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  final int lineCount;
  final Color color;

  _GridBackgroundPainter({required this.lineCount, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color.withValues(alpha: 0.5)
          ..strokeWidth = 1;

    for (int i = 0; i < lineCount; i++) {
      final y = size.height * (i / (lineCount - 1));
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridBackgroundPainter oldDelegate) => false;
}

Widget summaryCard(String label, double value, Color accentColor) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
    decoration: BoxDecoration(
      color: kBackground,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      children: [
        Text(
          "${value.toStringAsFixed(0)}%",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    ),
  );
}

class StatItem {
  final String label;
  final String count;
  final IconData icon;
  final Color color;

  const StatItem({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
  });
}

class NavChild {
  final String title;
  final int? index;
  final List<String>? allowedRoles;
  final List<NavChild> children;
  final String Function(String? role)? titleFor;

  final String? addPerm;
  final String? viewPerm;
  final String? permLabel;
  final bool prefixTitle;

  const NavChild(
    this.title,
    this.index, {
    this.allowedRoles,
    this.children = const [],
    this.titleFor,
    this.addPerm,
    this.viewPerm,
    this.permLabel,
    this.prefixTitle = true,
  });

  bool get usesPermissions => addPerm != null || viewPerm != null;

  bool isVisible(bool Function(String) hasPermission) {
    if (!usesPermissions) return true;
    return (addPerm != null && hasPermission(addPerm!)) ||
        (viewPerm != null && hasPermission(viewPerm!));
  }

  String resolveTitle(String? role, bool Function(String) hasPermission) {
    if (usesPermissions) {
      final hasAdd = addPerm != null && hasPermission(addPerm!);
      final hasView = viewPerm != null && hasPermission(viewPerm!);
      if (!prefixTitle) return permLabel ?? title;
      final label = permLabel ?? title;
      if (hasAdd && hasView) return 'Create/View $label';
      if (hasAdd) return 'Create $label';
      if (hasView) return 'View $label';
      return label;
    }
    return titleFor?.call(role) ?? title;
  }
}

class NavGroup {
  final IconData icon;
  final String label;
  final int pageIndex;
  final List<NavChild> children;
  final List<String>? allowedRoles;
  const NavGroup({
    required this.icon,
    required this.label,
    required this.pageIndex,
    this.children = const [],
    this.allowedRoles,
  });
}

class RootConnectorPainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;

  RootConnectorPainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.4
          ..style = PaintingStyle.stroke;

    final double midY = size.height / 2;
    const double curve = 8.0;

    if (!isFirst) {
      canvas.drawLine(const Offset(0, 0), Offset(0, midY - curve), paint);
    }
    if (!isLast) {
      canvas.drawLine(Offset(0, midY), Offset(0, size.height), paint);
    }

    final path =
        Path()
          ..moveTo(0, midY - curve)
          ..quadraticBezierTo(0, midY, curve, midY)
          ..lineTo(size.width, midY);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant RootConnectorPainter oldDelegate) {
    return oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast ||
        oldDelegate.color != color;
  }
}
