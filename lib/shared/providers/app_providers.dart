import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repositories/mock_data_repository.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/market_data.dart';
import '../../data/models/portfolio.dart';
import '../../data/models/options_strategy.dart';
import '../../data/models/trade_history.dart';
import '../../data/models/user_session.dart';
import '../../core/services/firebase_auth_service.dart';
import '../../core/services/mock_kyc_service.dart';
import '../../core/services/mock_mpin_service.dart';

/// Repository Provider
final mockDataRepositoryProvider = Provider<MockDataRepository>((ref) {
  return MockDataRepository();
});

/// User Profile Provider
final userProfileProvider = FutureProvider<UserProfile>((ref) async {
  final repository = ref.watch(mockDataRepositoryProvider);
  return repository.getUserProfile();
});

/// Market Data Provider
final marketDataProvider = FutureProvider<MarketData>((ref) async {
  final repository = ref.watch(mockDataRepositoryProvider);
  return repository.getMarketData();
});

/// Portfolio Provider
final portfolioProvider = FutureProvider<PortfolioSnapshot>((ref) async {
  final repository = ref.watch(mockDataRepositoryProvider);
  return repository.getPortfolioSnapshot();
});

/// Options Strategy Provider
final optionsStrategyProvider = FutureProvider<OptionsStrategy>((ref) async {
  final repository = ref.watch(mockDataRepositoryProvider);
  return repository.getOptionsStrategy();
});

/// Trade History Provider
final tradeHistoryProvider = FutureProvider<List<TradeHistory>>((ref) async {
  final repository = ref.watch(mockDataRepositoryProvider);
  return repository.getTradeHistory();
});

/// Theme Mode Provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, bool>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<bool> {
  ThemeModeNotifier() : super(false) {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('isDarkMode') ?? false;
  }

  Future<void> toggleTheme() async {
    state = !state;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', state);
  }
}

/// Onboarding Complete Provider
final onboardingCompleteProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  return OnboardingNotifier();
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier() : super(false) {
    _loadOnboardingStatus();
  }

  Future<void> _loadOnboardingStatus() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('onboardingComplete') ?? false;
  }

  Future<void> completeOnboarding() async {
    state = true;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
  }

  Future<void> resetOnboarding() async {
    state = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', false);
  }
}

/// Language Provider
final languageProvider = StateNotifierProvider<LanguageNotifier, String>((ref) {
  return LanguageNotifier();
});

class LanguageNotifier extends StateNotifier<String> {
  LanguageNotifier() : super('en') {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getString('language') ?? 'en';
  }

  Future<void> setLanguage(String language) async {
    state = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
  }
}

/// Firebase Auth Service Provider
final firebaseAuthServiceProvider = Provider<FirebaseAuthService>((ref) {
  return FirebaseAuthService();
});

/// Mock KYC Service Provider
final mockKycServiceProvider = Provider<MockKycService>((ref) {
  return MockKycService();
});

/// Mock MPIN Service Provider
final mockMpinServiceProvider = Provider<MockMpinService>((ref) {
  return MockMpinService();
});

/// User Session Provider
/// Manages authenticated user session state
final userSessionProvider = StateNotifierProvider<UserSessionNotifier, UserSession?>((ref) {
  return UserSessionNotifier();
});

class UserSessionNotifier extends StateNotifier<UserSession?> {
  UserSessionNotifier() : super(null) {
    _loadSession();
  }

  Future<void> _loadSession() async {
    // Check if user is logged in via auth service first
    final authService = FirebaseAuthService();
    if (authService.isLoggedIn()) {
      final user = authService.getCurrentUser();
      if (user != null) {
        // Try to load saved session
        final prefs = await SharedPreferences.getInstance();
        final savedUid = prefs.getString('user_session_uid');
        
        if (savedUid != null && savedUid.isNotEmpty) {
          try {
            // Load saved session data
            final sessionMap = <String, dynamic>{
              'firebase_uid': savedUid,
              'is_logged_in': prefs.getBool('user_session_logged_in') ?? false,
              'paper_trading_enabled': prefs.getBool('user_session_paper') ?? false,
              'real_trading_enabled': prefs.getBool('user_session_real') ?? false,
              'kyc_status': prefs.getString('user_session_kyc') ?? 'notStarted',
              'device_trusted': prefs.getBool('user_session_device') ?? true,
              'email': prefs.getString('user_session_email'),
              'phone_number': prefs.getString('user_session_phone'),
              'mpin_set': prefs.getBool('user_session_mpin_set') ?? false,
              'mpin_hash': prefs.getString('user_session_mpin_hash'),
            };
            
            state = UserSession.fromJson(sessionMap);
          } catch (e) {
            // If parsing fails, create new session
            state = UserSession.afterLogin(
              firebaseUid: user.uid,
              email: user.email,
              phoneNumber: user.phoneNumber,
            );
          }
        } else {
          // No saved session, create new one
          state = UserSession.afterLogin(
            firebaseUid: user.uid,
            email: user.email,
            phoneNumber: user.phoneNumber,
          );
        }
      }
    } else {
      state = null;
    }
  }

  Future<void> _saveSession(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    // Store individual fields for simplicity
    // In production, use proper JSON encoding with dart:convert
    final json = session.toJson();
    await prefs.setString('user_session_uid', json['firebase_uid'] as String? ?? '');
    await prefs.setBool('user_session_logged_in', json['is_logged_in'] as bool? ?? false);
    await prefs.setBool('user_session_paper', json['paper_trading_enabled'] as bool? ?? false);
    await prefs.setBool('user_session_real', json['real_trading_enabled'] as bool? ?? false);
    await prefs.setString('user_session_kyc', json['kyc_status'] as String? ?? 'notStarted');
    await prefs.setBool('user_session_device', json['device_trusted'] as bool? ?? true);
    await prefs.setString('user_session_email', json['email'] as String? ?? '');
    await prefs.setString('user_session_phone', json['phone_number'] as String? ?? '');
    await prefs.setBool('user_session_mpin_set', json['mpin_set'] as bool? ?? false);
    await prefs.setString('user_session_mpin_hash', json['mpin_hash'] as String? ?? '');
  }

  /// Create session after successful login
  Future<void> createSessionAfterLogin({
    required String firebaseUid,
    String? email,
    String? phoneNumber,
  }) async {
    final session = UserSession.afterLogin(
      firebaseUid: firebaseUid,
      email: email,
      phoneNumber: phoneNumber,
    );
    state = session;
    await _saveSession(session);
  }

  /// Update KYC status
  Future<void> updateKycStatus(KycStatus status) async {
    if (state == null) return;
    
    final updatedSession = state!.copyWith(kycStatus: status);
    
    // If KYC is completed, enable real trading
    if (status == KycStatus.completed) {
      final finalSession = updatedSession.copyWith(realTradingEnabled: true);
      state = finalSession;
      await _saveSession(finalSession);
    } else {
      state = updatedSession;
      await _saveSession(updatedSession);
    }
  }

  /// Enable real trading
  Future<void> enableRealTrading() async {
    if (state == null) return;
    
    final updatedSession = state!.copyWith(realTradingEnabled: true);
    state = updatedSession;
    await _saveSession(updatedSession);
  }

  /// Set MPIN
  Future<void> setMpin(String mpinHash) async {
    if (state == null) return;
    
    final updatedSession = state!.copyWith(mpinSet: true, mpinHash: mpinHash);
    state = updatedSession;
    await _saveSession(updatedSession);
  }

  /// Sign out
  Future<void> signOut() async {
    final authService = FirebaseAuthService();
    await authService.signOut();
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session_uid');
    await prefs.remove('user_session_logged_in');
    await prefs.remove('user_session_paper');
    await prefs.remove('user_session_real');
    await prefs.remove('user_session_kyc');
    await prefs.remove('user_session_device');
    await prefs.remove('user_session_email');
    await prefs.remove('user_session_phone');
    await prefs.remove('user_session_mpin_set');
    await prefs.remove('user_session_mpin_hash');
    
    state = null;
  }
}
