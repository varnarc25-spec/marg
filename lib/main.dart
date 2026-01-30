import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'shared/providers/app_providers.dart';
import 'features/onboarding/presentation/screens/splash_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  bool firebaseInitialized = false;
  try {
    if (Firebase.apps.isEmpty) {
      debugPrint('🔄 Attempting to initialize Firebase...');
      try {
        // Initialize with firebase_options.dart for proper configuration
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        firebaseInitialized = true;
        debugPrint('✅ Firebase initialized successfully');
        if (kDebugMode) {
          try {
            final projectId = Firebase.app().options.projectId;
            debugPrint('📱 Firebase Project ID: $projectId');
          } catch (e) {
            debugPrint('⚠️ Could not get Firebase project ID: $e');
          }
        }
      } catch (initError, initStack) {
        debugPrint('❌ Firebase.initializeApp() failed: $initError');
        if (kDebugMode) {
          debugPrint('   Stack: $initStack');
        }
        firebaseInitialized = false;
        debugPrint('⚠️ Continuing without Firebase. Some features may not work.');
        debugPrint('💡 To enable Firebase Auth:');
        debugPrint('   1. Run: flutterfire configure');
        debugPrint('   2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)');
      }
    } else {
      firebaseInitialized = true;
      debugPrint('✅ Firebase already initialized');
    }
  } catch (e, stackTrace) {
    // Firebase not configured - app will run without Firebase features
    firebaseInitialized = false;
    debugPrint('🔥 Firebase initialization skipped: $e');
    if (kDebugMode) {
      debugPrint('Stack trace: $stackTrace');
      debugPrint('💡 To enable Firebase Auth:');
      debugPrint('   1. Run: flutterfire configure');
      debugPrint('   2. Or add GoogleService-Info.plist (iOS) and google-services.json (Android)');
    }
  }

  // Store Firebase initialization status globally (optional - for checking later)
  if (!firebaseInitialized) {
    debugPrint('⚠️ WARNING: Firebase is not initialized. Google Sign-In and other Firebase features will not work.');
  }

  runApp(
    const ProviderScope(
      child: MargApp(),
    ),
  );
}

/// Main App Widget
/// Sets up theme, routing, and app structure
class MargApp extends ConsumerWidget {
  const MargApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Marg - Trading App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
