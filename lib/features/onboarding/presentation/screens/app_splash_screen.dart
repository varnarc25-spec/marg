import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/navigation/root_navigator_key.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/app_logo.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../home/presentation/screens/homescreen1.dart';
import 'language_selection_screen.dart';

/// Deep royal → bright azure gradient (reference-style splash).
const List<Color> _splashGradientColors = [
  Color(0xFF0A2E6B),
  Color(0xFF0D47A1),
  Color(0xFF1976D2),
  Color(0xFF29B6F6),
];

const List<double> _splashGradientStops = [0.0, 0.32, 0.68, 1.0];

/// App Splash Screen — gradient background, soft wave accents, centered brand.
/// Logged-in users go to [HomeScreen]; others go to [LanguageSelectionScreen].
class AppSplashScreen extends ConsumerStatefulWidget {
  const AppSplashScreen({super.key});

  @override
  ConsumerState<AppSplashScreen> createState() => _AppSplashScreenState();
}

class _AppSplashScreenState extends ConsumerState<AppSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _hasNavigatedAway = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    await _replaceWithPostSplash();
  }

  Future<void> _replaceWithPostSplash() async {
    if (!mounted || _hasNavigatedAway) return;
    _hasNavigatedAway = true;
    final auth = ref.read(firebaseAuthServiceProvider);
    final next = auth.isLoggedIn()
        ? const HomeScreen()
        : const LanguageSelectionScreen();
    if (auth.isLoggedIn()) {
      await auth.debugLogIdTokenToConsole(forceRefresh: true);
    }
    if (!mounted) return;
    final route = MaterialPageRoute<void>(builder: (_) => next);
    final nav = rootNavigatorKey.currentState;
    if (nav != null) {
      nav.pushReplacement(route);
    } else {
      Navigator.of(context).pushReplacement(route);
    }
  }

  void _onTap() {
    _replaceWithPostSplash();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nProvider);
    final remoteBrand = ref.watch(appRemoteSettingsProvider).valueOrNull;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: GestureDetector(
        onTap: _onTap,
        behavior: HitTestBehavior.opaque,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: _splashGradientColors,
                  stops: _splashGradientStops,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 200,
              child: CustomPaint(
                painter: _SplashCloudWavesPainter(),
                child: const SizedBox.expand(),
              ),
            ),
            SafeArea(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      Container(
                        width: 108,
                        height: 108,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.18),
                              blurRadius: 28,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: const Color(0xFF1565C0).withValues(alpha: 0.25),
                              blurRadius: 20,
                              spreadRadius: -4,
                            ),
                          ],
                        ),
                        child: AppLogo(size: 54, networkUrl: remoteBrand?.logoUrl),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        l10n.onboardingWelcome,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        remoteBrand?.displayAppName ?? l10n.appName,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        l10n.appTagline,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withValues(alpha: 0.86),
                          height: 1.55,
                        ),
                      ),
                      const Spacer(flex: 2),
                      SizedBox(
                        width: 36,
                        height: 36,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.85),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Tap anywhere to continue',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                      SizedBox(height: 12 + bottomInset),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Layered soft curves at the bottom (cloud / wave accent).
class _SplashCloudWavesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void layer(Color color, double baseY, double amp) {
      final path = Path()..moveTo(0, h);
      path.lineTo(0, baseY);
      path.cubicTo(
        w * 0.15,
        baseY - amp,
        w * 0.35,
        baseY + amp * 0.65,
        w * 0.5,
        baseY - amp * 0.25,
      );
      path.cubicTo(
        w * 0.62,
        baseY - amp * 0.9,
        w * 0.82,
        baseY + amp * 0.5,
        w,
        baseY - amp * 0.15,
      );
      path.lineTo(w, h);
      path.close();
      canvas.drawPath(path, Paint()..color = color);
    }

    layer(Colors.white.withValues(alpha: 0.07), h * 0.42, h * 0.22);
    layer(Colors.white.withValues(alpha: 0.11), h * 0.52, h * 0.16);
    layer(const Color(0xFF64B5F6).withValues(alpha: 0.14), h * 0.62, h * 0.12);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
