import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/root_navigator_key.dart';
import 'shared/providers/app_providers.dart';
import 'features/onboarding/presentation/screens/app_splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/homescreen1.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  bool firebaseInitialized = false;
  try {
    if (Firebase.apps.isEmpty) {
      try {
        // Initialize with firebase_options.dart for proper configuration
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        firebaseInitialized = true;
        if (kDebugMode) {
          try {
            final projectId = Firebase.app().options.projectId;
          } catch (e) {}
        }
      } catch (initError, initStack) {
        if (kDebugMode) {}
        firebaseInitialized = false;
      }
    } else {
      firebaseInitialized = true;
    }
  } catch (e, stackTrace) {
    // Firebase not configured - app will run without Firebase features
    firebaseInitialized = false;
    if (kDebugMode) {}
  }

  // Store Firebase initialization status globally (optional - for checking later)
  if (!firebaseInitialized) {}

  runApp(const ProviderScope(child: MargApp()));
}

/// Main App Widget
/// Sets up theme, routing, and app structure
class MargApp extends ConsumerWidget {
  const MargApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);
    final languageCode = ref.watch(languageProvider);
    final locale = _localeFromCode(languageCode);
    final remoteTitle = ref.watch(appRemoteSettingsProvider).valueOrNull?.displayAppName;

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      title: (remoteTitle != null && remoteTitle.isNotEmpty)
          ? remoteTitle
          : 'Marg - Trading App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('te'),
        Locale('ta'),
        Locale('kn'),
        Locale('mr'),
        Locale('gu'),
        Locale('pa'),
        Locale('ml'),
        Locale('bn'),
      ],
      home: const AppSplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }

  static Locale _localeFromCode(String code) {
    if (code.isEmpty) return const Locale('en');
    if (code == 'hinglish') return const Locale('en', 'IN');
    return Locale(code);
  }
}
