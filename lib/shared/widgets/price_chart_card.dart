import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Reusable price chart card used on gold/silver pages.
/// Currently shows a static sparkline with range chips and a disclaimer.
class PriceChartCard extends StatelessWidget {
  final Color accent;
  final Color fill;
  final String riseText;

  const PriceChartCard({
    super.key,
    required this.accent,
    required this.fill,
    required this.riseText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Icon(Icons.trending_up_rounded, color: accent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    riseText,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(Icons.keyboard_arrow_up_rounded, color: accent),
              ],
            ),
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _SparkLinePainter(color: fill)),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _RangeChip('1M'),
                        _RangeChip('6M'),
                        _RangeChip('1Y'),
                        _RangeChip('3Y'),
                        _RangeChip('5Y', selected: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Text(
              'Note: The chart is based on past data. Past performance is not an indicator of future returns.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _RangeChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFC107) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SparkLinePainter extends CustomPainter {
  final Color color;
  _SparkLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final path = Path();
    final fillPath = Path();
    const points = [
      Offset(0, 0.7),
      Offset(0.1, 0.5),
      Offset(0.2, 0.55),
      Offset(0.3, 0.4),
      Offset(0.4, 0.45),
      Offset(0.5, 0.3),
      Offset(0.6, 0.35),
      Offset(0.7, 0.25),
      Offset(0.8, 0.3),
      Offset(0.9, 0.18),
      Offset(1.0, 0.22),
    ];

    for (var i = 0; i < points.length; i++) {
      final p = Offset(
        points[i].dx * size.width,
        points[i].dy * size.height,
      );
      if (i == 0) {
        path.moveTo(p.dx, p.dy);
        fillPath.moveTo(p.dx, size.height);
        fillPath.lineTo(p.dx, p.dy);
      } else {
        path.lineTo(p.dx, p.dy);
        fillPath.lineTo(p.dx, p.dy);
      }
    }

    fillPath.lineTo(points.last.dx * size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparkLinePainter oldDelegate) =>
      oldDelegate.color != color;
}

