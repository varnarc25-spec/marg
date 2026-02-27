import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';

/// Scan QR Code screen with camera overlay, scan frame, and action buttons.
/// Matches design: top bar (back, title, menu), gradient overlay, white scan frame
/// with corner brackets, "Scanning process...", bottom bar (gallery, scan, cancel).
class ScanQrScreen extends ConsumerWidget {
  const ScanQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Placeholder for camera feed (blurred background effect)
          _CameraPlaceholder(),
          // Blue–purple gradient overlay
          _GradientOverlay(),
          // Safe area content
          SafeArea(
            child: Column(
              children: [
                _TopBar(title: l10n.scanQrTitle),
                const Spacer(),
                _ScanFrameAndStatus(statusText: l10n.scanningProcess),
                const Spacer(),
                _BottomActionBar(
                  onGalleryTap: () => _pickFromGallery(context),
                  onScanTap: () => _onScanTap(context),
                  onCancelTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _pickFromGallery(BuildContext context) {
    // TODO: open image picker for QR from gallery
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pick from gallery – coming soon')),
    );
  }

  void _onScanTap(BuildContext context) {
    // TODO: trigger scan / toggle scanner
  }
}

/// Placeholder for camera preview (dark with subtle pattern).
class _CameraPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1a1a2e),
            const Color(0xFF16213e),
          ],
        ),
      ),
      child: CustomPaint(
        painter: _GridPatternPainter(),
      ),
    );
  }
}

class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1;
    const step = 24.0;
    for (var x = 0.0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Semi-transparent blue–purple gradient over the camera area.
class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF5C6BC0).withValues(alpha: 0.75),
              const Color(0xFF7E57C2).withValues(alpha: 0.7),
              const Color(0xFF4527A0).withValues(alpha: 0.8),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String title;

  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).pop(),
          ),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          _CircleButton(
            icon: Icons.more_horiz_rounded,
            onTap: () {
              // TODO: show options menu
            },
          ),
        ],
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 22, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

class _ScanFrameAndStatus extends StatelessWidget {
  final String statusText;

  const _ScanFrameAndStatus({required this.statusText});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ScanFrame(),
        const SizedBox(height: 24),
        Text(
          statusText,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.95),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

/// White rectangular frame with L-shaped corner brackets.
class _ScanFrame extends StatelessWidget {
  static const double _width = 260;
  static const double _height = 260;
  static const double _cornerLength = 32;
  static const double _strokeWidth = 4;
  static const double _radius = 12;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: CustomPaint(
        painter: _ScanFramePainter(
          cornerLength: _cornerLength,
          strokeWidth: _strokeWidth,
          radius: _radius,
        ),
      ),
    );
  }
}

class _ScanFramePainter extends CustomPainter {
  final double cornerLength;
  final double strokeWidth;
  final double radius;

  _ScanFramePainter({
    required this.cornerLength,
    required this.strokeWidth,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final r = radius;
    final c = cornerLength;

    // Top-left L
    canvas.drawPath(
      Path()
        ..moveTo(0, r + c)
        ..lineTo(0, r)
        ..quadraticBezierTo(0, 0, r, 0)
        ..lineTo(r + c, 0),
      paint,
    );
    // Top-right L
    canvas.drawPath(
      Path()
        ..moveTo(size.width - (r + c), 0)
        ..lineTo(size.width - r, 0)
        ..quadraticBezierTo(size.width, 0, size.width, r)
        ..lineTo(size.width, r + c),
      paint,
    );
    // Bottom-right L
    canvas.drawPath(
      Path()
        ..moveTo(size.width, size.height - (r + c))
        ..lineTo(size.width, size.height - r)
        ..quadraticBezierTo(size.width, size.height, size.width - r, size.height)
        ..lineTo(size.width - (r + c), size.height),
      paint,
    );
    // Bottom-left L
    canvas.drawPath(
      Path()
        ..moveTo(r + c, size.height)
        ..lineTo(r, size.height)
        ..quadraticBezierTo(0, size.height, 0, size.height - r)
        ..lineTo(0, size.height - (r + c)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ScanFramePainter oldDelegate) =>
      oldDelegate.cornerLength != cornerLength ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.radius != radius;
}

class _BottomActionBar extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onScanTap;
  final VoidCallback onCancelTap;

  const _BottomActionBar({
    required this.onGalleryTap,
    required this.onScanTap,
    required this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircleButton(
            icon: Icons.photo_library_rounded,
            onTap: onGalleryTap,
          ),
          _LargeScanButton(onTap: onScanTap),
          _CircleButton(
            icon: Icons.close_rounded,
            onTap: onCancelTap,
          ),
        ],
      ),
    );
  }
}

class _LargeScanButton extends StatelessWidget {
  final VoidCallback onTap;

  const _LargeScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF7E57C2),
      shape: const CircleBorder(),
      elevation: 8,
      shadowColor: const Color(0xFF7E57C2).withValues(alpha: 0.5),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 72,
          height: 72,
          child: Icon(
            Icons.qr_code_scanner_rounded,
            color: Colors.white,
            size: 36,
          ),
        ),
      ),
    );
  }
}
