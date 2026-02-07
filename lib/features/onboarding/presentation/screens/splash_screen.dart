import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../data/models/user_session.dart';
import 'language_selection_screen.dart';
import 'splash_screen_links.dart';
import '../../../home/presentation/screens/home_screen.dart';
import '../../../auth/presentation/screens/login_screen.dart';

/// Splash Screen - First screen users see
/// Shows brand, trust tagline, and dropdown menu to open any screen
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late List<String> _menuCategories;
  late List<SplashScreenLink> _allLinks;
  String? _selectedMenu;
  SplashScreenLink? _selectedLink;

  @override
  void initState() {
    super.initState();
    _allLinks = splashScreenLinks;
    _menuCategories = _allLinks.map((e) => e.category).toSet().toList()..sort();
    _selectedMenu = _menuCategories.isNotEmpty ? _menuCategories.first : null;
    _updateLinksForMenu();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  void _updateLinksForMenu() {
    final links = _selectedMenu == null
        ? <SplashScreenLink>[]
        : _allLinks.where((e) => e.category == _selectedMenu).toList();
    if (links.isEmpty) {
      _selectedLink = null;
    } else {
      final currentLabel = _selectedLink?.label;
      final stillValid = links.any((e) => e.label == currentLabel);
      _selectedLink = stillValid
          ? links.firstWhere((e) => e.label == currentLabel)
          : links.first;
    }
  }

  List<SplashScreenLink> get _linksInSelectedMenu =>
      _selectedMenu == null
          ? []
          : _allLinks.where((e) => e.category == _selectedMenu).toList();

  void _openScreen(Widget screen) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void _openSelectedLink() {
    final link = _selectedLink;
    if (link != null) _openScreen(link.createScreen());
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    Widget? targetScreen;
    String? navigationReason;

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      bool isLoggedIn = false;
      UserSession? userSession;

      try {
        final authService = ref.read(firebaseAuthServiceProvider);
        isLoggedIn = authService.isLoggedIn();
      } catch (e) {
        isLoggedIn = false;
      }
      try {
        userSession = ref.read(userSessionProvider);
      } catch (e) {
        userSession = null;
      }

      if (!isLoggedIn && userSession == null) {
        targetScreen = const LoginScreen();
        navigationReason = 'User not logged in';
      } else {
        bool onboardingComplete = false;
        try {
          onboardingComplete = ref.read(onboardingCompleteProvider);
        } catch (e) {
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
      debugPrint('❌ Navigation error: $e');
      debugPrint('Stack trace: $stackTrace');
      targetScreen = const LoginScreen();
      navigationReason = 'Error occurred, fallback to login';
    }

    if (!mounted) return;
    debugPrint('➡️ $navigationReason');
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => targetScreen ?? const LoginScreen()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final linksInMenu = _linksInSelectedMenu;

    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.trending_up,
                  size: 40,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                ref.watch(l10nProvider).appName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                ref.watch(l10nProvider).appTagline,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _navigateToNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Or open any screen:',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedMenu,
                                isExpanded: true,
                                dropdownColor: AppColors.primaryBlue,
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                items: _menuCategories
                                    .map((c) => DropdownMenuItem<String>(
                                          value: c,
                                          child: Text(c),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedMenu = v;
                                    _updateLinksForMenu();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 3,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<SplashScreenLink>(
                                value: _selectedLink != null && linksInMenu.contains(_selectedLink)
                                    ? _selectedLink
                                    : (linksInMenu.isEmpty ? null : linksInMenu.first),
                                isExpanded: true,
                                dropdownColor: AppColors.primaryBlue,
                                icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                items: linksInMenu
                                    .map((link) => DropdownMenuItem<SplashScreenLink>(
                                          value: link,
                                          child: Text(
                                            link.label,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ))
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    _selectedLink = v;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _selectedLink != null ? _openSelectedLink : null,
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text('Go'),
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryBlue,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    itemCount: _allLinks.length,
                    itemBuilder: (context, index) {
                      final link = _allLinks[index];
                      return ListTile(
                        dense: true,
                        title: Text(
                          '${link.category} → ${link.label}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.white70),
                        onTap: () => _openScreen(link.createScreen()),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
