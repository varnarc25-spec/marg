import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../data/models/user_session.dart';
import 'language_selection_screen.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';

/// Splash Screen - First screen users see
/// Shows brand and trust tagline
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    // Default navigation target - will be updated based on checks
    Widget? targetScreen;
    String? navigationReason;

    try {
      // Wait a bit more for providers to initialize
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      // Check auth state first - use try-catch to handle any provider errors
      bool isLoggedIn = false;
      UserSession? userSession;
      
      try {
        final authService = ref.read(firebaseAuthServiceProvider);
        isLoggedIn = authService.isLoggedIn();
        debugPrint('🔐 Auth check: isLoggedIn = $isLoggedIn');
      } catch (e) {
        // If auth service fails, assume not logged in
        debugPrint('⚠️ Auth service check failed: $e');
        isLoggedIn = false;
      }

      // Check user session
      try {
        userSession = ref.read(userSessionProvider);
        debugPrint('👤 User session: ${userSession != null ? "exists" : "null"}');
      } catch (e) {
        debugPrint('⚠️ User session check failed: $e');
        userSession = null;
      }

      // If not logged in, go to login screen
      if (!isLoggedIn && userSession == null) {
        targetScreen = const LoginScreen();
        navigationReason = 'User not logged in';
      } else {
        // User is logged in - check onboarding
        bool onboardingComplete = false;
        try {
          onboardingComplete = ref.read(onboardingCompleteProvider);
          debugPrint('📋 Onboarding complete: $onboardingComplete');
        } catch (e) {
          debugPrint('⚠️ Onboarding check failed: $e');
          onboardingComplete = false;
        }

        if (onboardingComplete) {
          targetScreen = const HomeScreen();
          navigationReason = 'Onboarding complete, going to home';
        } else {
          targetScreen = const LanguageSelectionScreen();
          navigationReason = 'Onboarding not complete, starting onboarding';
        }
      }
    } catch (e, stackTrace) {
      // Fallback: if anything fails, go to login screen
      debugPrint('❌ Navigation error: $e');
      debugPrint('Stack trace: $stackTrace');
      targetScreen = const LoginScreen();
      navigationReason = 'Error occurred, fallback to login';
    }

    // Ensure navigation always happens
    if (targetScreen != null && mounted) {
      debugPrint('➡️ $navigationReason');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => targetScreen!),
      );
    } else if (mounted) {
      // Final safety fallback
      debugPrint('⚠️ No target screen determined, defaulting to Login');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo/Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 60,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.appName,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppStrings.appTagline,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
