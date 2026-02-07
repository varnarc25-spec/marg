import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Semi-circular risk gauge (FEAR-style): colored arc, LOW/HIGH labels, center "Risk", needle.
class RiskProfileGauge extends StatelessWidget {
  /// One of 'low', 'medium', 'high' — sets needle position.
  final String riskProfile;

  /// Width of the gauge. Height is derived to avoid overlap when used below a header.
  final double size;

  /// Center label (e.g. localized "Risk"). If null, uses "Risk".
  final String? centerLabel;

  const RiskProfileGauge({
    super.key,
    required this.riskProfile,
    this.size = 220,
    this.centerLabel,
  });

  /// Needle angle: 0 = up, -pi/2 = left (low), pi/2 = right (high).
  double _needleAngle() {
    switch (riskProfile.toLowerCase()) {
      case 'low':
        return -math.pi / 2;
      case 'high':
        return math.pi / 2;
      case 'medium':
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size * 0.62,
      child: CustomPaint(
        painter: _RiskGaugePainter(
          needleAngle: _needleAngle(),
          riskProfile: riskProfile,
          centerLabel: centerLabel ?? 'Risk',
        ),
      ),
    );
  }
}

class _RiskGaugePainter extends CustomPainter {
  final double needleAngle;
  final String riskProfile;
  final String centerLabel;

  _RiskGaugePainter({
    required this.needleAngle,
    required this.riskProfile,
    this.centerLabel = 'Risk',
  });

  /// Gradient: low (blue) → green → yellow → orange → high (red)
  static const List<Color> _gradientColors = [
    Color(0xFFB3E5FC), // light blue (low)
    Color(0xFF4CAF50), // green
    Color(0xFFFFEB3B), // yellow
    Color(0xFFFF9800), // orange
    Color(0xFFE53935), // red (high)
  ];

  static const Color _lowColor = Color(0xFFB3E5FC);
  static const Color _highColor = Color(0xFFE53935);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.5, size.height * 0.78);
    final radius = size.width * 0.42;
    const startAngle = math.pi;
    const sweepAngle = math.pi;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Gradient arc: sweep from left (low) to right (high)
    final gradient = SweepGradient(
      center: Alignment.center,
      startAngle: math.pi,
      endAngle: math.pi * 2,
      colors: _gradientColors,
    );
    final strokeWidth = size.width * 0.09;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

    // White circular gauge face at bottom center
    final faceRadius = size.width * 0.14;
    final faceCenter = Offset(size.width * 0.5, size.height * 0.78);
    canvas.drawCircle(
      faceCenter,
      faceRadius,
      Paint()..color = Colors.white,
    );
    canvas.drawCircle(
      faceCenter,
      faceRadius,
      Paint()
        ..color = AppColors.textPrimary.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    // Center label (bold, prominent)
    final riskSpan = TextSpan(
      text: centerLabel,
      style: TextStyle(
        fontSize: size.width * 0.07,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
    final riskTp = TextPainter(
      text: riskSpan,
      textDirection: TextDirection.ltr,
    )..layout();
    riskTp.paint(
      canvas,
      Offset(
        faceCenter.dx - riskTp.width * 0.5,
        faceCenter.dy - riskTp.height * 0.5,
      ),
    );

    // Needle (dark grey, from center)
    canvas.save();
    canvas.translate(faceCenter.dx, faceCenter.dy);
    canvas.rotate(needleAngle);
    final needleLength = radius - faceRadius - 6;
    final needlePath = Path()
      ..moveTo(0, 0)
      ..lineTo(-needleLength * 0.12, -needleLength * 0.06)
      ..lineTo(0, -needleLength)
      ..lineTo(needleLength * 0.12, -needleLength * 0.06)
      ..close();
    canvas.drawPath(
      needlePath,
      Paint()..color = const Color(0xFF424242),
    );
    canvas.restore();

    // Labels: LOW (blue, left), HIGH (red, right) only
    _drawLabel(
      canvas,
      'LOW',
      Offset(size.width * 0.2, size.height * 0.72),
      TextStyle(
        fontSize: size.width * 0.055,
        fontWeight: FontWeight.bold,
        color: _lowColor,
      ),
    );
    _drawLabel(
      canvas,
      'HIGH',
      Offset(size.width * 0.8, size.height * 0.72),
      TextStyle(
        fontSize: size.width * 0.055,
        fontWeight: FontWeight.bold,
        color: _highColor,
      ),
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset position, TextStyle style) {
    final span = TextSpan(text: text, style: style);
    final tp = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(
        position.dx - tp.width * 0.5,
        position.dy - tp.height * 0.5,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _RiskGaugePainter old) {
    return old.needleAngle != needleAngle ||
        old.riskProfile != riskProfile ||
        old.centerLabel != centerLabel;
  }
}
