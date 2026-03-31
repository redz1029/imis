import 'package:flutter/material.dart';
import 'accomplishment_widget.dart/scorecard_monitoring_accomplishment_widget.dart';
import 'dart:math';

class TotalScoreIndicator extends StatelessWidget {
  final int deliverableId;
  final int totalPeriods;

  const TotalScoreIndicator({
    super.key,
    required this.deliverableId,
    required this.totalPeriods,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: totalScores.putIfAbsent(
        deliverableId,
        () => ValueNotifier<int>(0),
      ),
      builder: (context, total, _) {
        Color color;

        if (total >= 75) {
          color = Colors.green;
        } else if (total >= 50) {
          color = Colors.orange;
        } else {
          color = Colors.red;
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 100,
              height: 50,
              child: Stack(
                children: [
                  CustomPaint(
                    size: const Size(100, 50),
                    painter: HalfCirclePainter(
                      progress: (total / 200).clamp(0.0, 1.0),
                      color: color,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Text(
                        '$total',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text("Total Score", style: const TextStyle(fontSize: 12)),
          ],
        );
      },
    );
  }
}

class HalfCirclePainter extends CustomPainter {
  final double progress;
  final Color color;

  HalfCirclePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 12.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final _ = pi;
    final sweepAngle = pi * progress;
    final backgroundPaint =
        Paint()
          ..color = Colors.grey[300]!
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    final foregroundPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, pi, pi, false, backgroundPaint);

    canvas.drawArc(rect, pi, sweepAngle, false, foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant HalfCirclePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
