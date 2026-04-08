import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/widgets/app_logo.dart';
import '../../../../../core/l10n/app_localizations.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../accounts/presentation/screens/my_account_screen.dart';
import 'otp_verification_screen.dart';

/// Login/Signup Screen
/// Provides options to login with Phone (OTP) or Email
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _isEmailMode = false;
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handlePhoneLogin() async {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      _showError('Please enter your phone number');
      return;
    }

    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phoneNumber)) {
      _showError('Please enter a valid 10-digit phone number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      final verificationId = await authService.sendPhoneOTPWithCallback(
        '+91$phoneNumber',
        (vid) {
          // Code sent callback - navigation happens in the future
        },
      );

      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            verificationId: verificationId,
            phoneNumber: '+91$phoneNumber',
            authMethod: AuthMethod.phone,
          ),
        ),
      );
    } catch (e) {
      final message = e.toString()
          .replaceFirst(RegExp(r'^Exception:\s*'), '')
          .replaceFirst(RegExp(r'^Error:\s*'), '')
          .trim();
      _showError(message.isNotEmpty ? message : 'Could not send OTP. Try again or use Email sign-in.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleEmailLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showError('Please enter email and password');
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showError('Please enter a valid email address');
      return;
    }

    setState(() => _isLoading = true);

    bool didReplace = false;
    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      Map<String, dynamic> userData;

      if (_isSignUp) {
        userData = await authService.signUpWithEmailPassword(
          email: email,
          password: password,
        );
      } else {
        userData = await authService.signInWithEmailPassword(
          email: email,
          password: password,
        );
      }

      if (!mounted) return;

      await ref
          .read(userSessionProvider.notifier)
          .createSessionAfterLogin(
            firebaseUid: userData['uid'] as String,
            email: userData['email'] as String?,
            phoneNumber: userData['phoneNumber'] as String?,
          );

      // Register user in marg_api (POST /api/user/register) for both login and signup
      final idToken = await authService.getIdToken();
      if (idToken != null) {
        final api = ref.read(margApiServiceProvider);
        try {
          await api.register(idToken: idToken, name: email);
        } catch (_) {
          // Continue – user may already exist
        }
        // Always ensure wallet exists (runs even if register failed, e.g. user already registered)
        try {
          await api.ensurePaperWallet(idToken: idToken);
        } catch (_) {}
      }

      // Claim anonymous onboarding to this user if we have a session id
      try {
        final sessionId = await ref.read(onboardingSessionIdProvider.future);
        final idToken = await authService.getIdToken();
        if (idToken != null && sessionId.isNotEmpty) {
          final api = ref.read(margApiServiceProvider);
          await api.claimOnboarding(idToken: idToken, sessionId: sessionId);
        }
      } catch (_) {}

      ref.invalidate(userProfileProvider);

      if (!mounted) return;
      await authService.debugLogIdTokenToConsole(forceRefresh: true);
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final onboardingComplete = ref.read(onboardingCompleteProvider);
      if (onboardingComplete) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyAccountScreen()),
        );
      }
      didReplace = true;
      return;
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted && !didReplace) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);

    bool didReplace = false;
    try {
      final authService = ref.read(firebaseAuthServiceProvider);
      final userData = await authService.signInWithGoogle();

      if (!mounted) return;

      await ref
          .read(userSessionProvider.notifier)
          .createSessionAfterLogin(
            firebaseUid: userData['uid'] as String,
            email: userData['email'] as String?,
            phoneNumber: userData['phoneNumber'] as String?,
          );

      // Register user in marg_api (POST /api/user/register)
      final idToken = await authService.getIdToken();
      if (idToken != null) {
        final api = ref.read(margApiServiceProvider);
        final name = userData['email'] as String? ?? userData['displayName'] as String?;
        try {
          await api.register(idToken: idToken, name: name);
        } catch (_) {}
        try {
          await api.ensurePaperWallet(idToken: idToken);
        } catch (_) {}
      }

      // Claim anonymous onboarding if we have a session id
      try {
        final sessionId = await ref.read(onboardingSessionIdProvider.future);
        final idToken = await authService.getIdToken();
        if (idToken != null && sessionId.isNotEmpty) {
          final api = ref.read(margApiServiceProvider);
          await api.claimOnboarding(idToken: idToken, sessionId: sessionId);
        }
      } catch (_) {}

      ref.invalidate(userProfileProvider);

      if (!mounted) return;
      await authService.debugLogIdTokenToConsole(forceRefresh: true);
      if (!mounted) return;
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(true);
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      final onboardingComplete = ref.read(onboardingCompleteProvider);
      if (onboardingComplete) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MyAccountScreen()),
        );
      }
      didReplace = true;
      return;
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted && !didReplace) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleAppleSignIn() {
    // When implementing: after Apple sign-in success, call createSessionAfterLogin
    // then api.register(idToken: idToken, name: displayNameOrEmail) and claimOnboarding.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Apple Sign-In coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleFacebookSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Facebook Sign-In coming soon'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String message) {
    if (message.contains('Firebase Auth is not available') ||
        message.contains('Firebase is not') ||
        message.contains('no firebase app') ||
        message.contains('flutterfire configure')) {
      _showFirebaseErrorDialog(message);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.accentRed,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _showFirebaseErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.accentRed),
            SizedBox(width: 8),
            Text('Firebase Not Configured'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Firebase is not initialized. Google Sign-In requires Firebase to be set up.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                'To fix this:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('1. Run: flutterfire configure'),
              const Text('2. Or add configuration files:'),
              const SizedBox(height: 4),
              const Text('   • iOS: GoogleService-Info.plist'),
              const Text('   • Android: google-services.json'),
              const SizedBox(height: 16),
              const Text(
                'For now, you can use Phone or Email login (if configured).',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: AppLogo(
                    size: 50,
                    networkUrl:
                        ref.watch(appRemoteSettingsProvider).valueOrNull?.logoUrl,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _isEmailMode
                    ? (_isSignUp
                          ? ref.watch(l10nProvider).authCreateAccount
                          : ref.watch(l10nProvider).authWelcomeBack)
                    : ref.watch(l10nProvider).authWelcome,
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isEmailMode
                    ? (_isSignUp
                          ? ref.watch(l10nProvider).authSignUpToStart
                          : ref.watch(l10nProvider).authSignInToContinue)
                    : ref.watch(l10nProvider).authTagline,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              if (!_isEmailMode) ...[
                _buildPhoneLoginSection(),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _LoginOptionIcon(
                      backgroundColor: const Color(0xFFE1D5F5),
                      icon: FaIcon(
                        FontAwesomeIcons.envelope,
                        size: 26,
                        color: _iconColorForBackground(const Color(0xFFE1D5F5)),
                      ),
                      onTap: () => setState(() => _isEmailMode = true),
                    ),
                    _LoginOptionIcon(
                      backgroundColor: const Color(0xFF000000),
                      icon: FaIcon(
                        FontAwesomeIcons.apple,
                        size: 26,
                        color: Colors.white,
                      ),
                      onTap: _handleAppleSignIn,
                    ),
                    _LoginOptionIcon(
                      backgroundColor: const Color(0xFFEA4335),
                      icon: FaIcon(
                        FontAwesomeIcons.google,
                        size: 26,
                        color: Colors.white,
                      ),
                      onTap: _isLoading ? null : _handleGoogleSignIn,
                    ),
                    _LoginOptionIcon(
                      backgroundColor: const Color(0xFF1877F2),
                      icon: FaIcon(
                        FontAwesomeIcons.facebook,
                        size: 26,
                        color: Colors.white,
                      ),
                      onTap: _handleFacebookSignIn,
                    ),
                  ],
                ),
              ] else ...[
                _buildEmailLoginSection(),
              ],
              const SizedBox(height: 32),
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: () {}, child: const Text('Terms')),
                  Text(' • ', style: Theme.of(context).textTheme.bodySmall),
                  TextButton(onPressed: () {}, child: const Text('Privacy')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLoginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Phone Number',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: 'Enter 10-digit phone number',
            prefixIcon: const Icon(Icons.phone),
            prefixText: '+91 ',
          ),
          maxLength: 10,
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handlePhoneLogin,
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Continue with Phone'),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailLoginSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() {
              _isEmailMode = false;
              _isSignUp = false;
            }),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email Address',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: _isSignUp ? 'Create Password' : 'Password',
            hintText: 'Enter your password',
            prefixIcon: const Icon(Icons.lock_outlined),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: AppDimensions.buttonHeight,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _handleEmailLogin,
            child: _isLoading
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(_isSignUp ? 'Sign Up' : 'Sign In'),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isSignUp
                  ? 'Already have an account? '
                  : "Don't have an account? ",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
              onPressed: () => setState(() => _isSignUp = !_isSignUp),
              child: Text(_isSignUp ? 'Sign In' : 'Sign Up'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Divider(color: Colors.grey.shade300)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('OR', style: Theme.of(context).textTheme.bodyMedium),
            ),
            Expanded(child: Divider(color: Colors.grey.shade300)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _LoginOptionIcon(
              backgroundColor: const Color(0xFFE1D5F5),
              icon: FaIcon(
                FontAwesomeIcons.envelope,
                size: 26,
                color: _iconColorForBackground(const Color(0xFFE1D5F5)),
              ),
              onTap: () => setState(() => _isEmailMode = true),
            ),
            _LoginOptionIcon(
              backgroundColor: const Color(0xFF000000),
              icon: FaIcon(
                FontAwesomeIcons.apple,
                size: 26,
                color: Colors.white,
              ),
              onTap: _handleAppleSignIn,
            ),
            _LoginOptionIcon(
              backgroundColor: const Color(0xFFEA4335),
              icon: FaIcon(
                FontAwesomeIcons.google,
                size: 26,
                color: Colors.white,
              ),
              onTap: _isLoading ? null : _handleGoogleSignIn,
            ),
            _LoginOptionIcon(
              backgroundColor: const Color(0xFF1877F2),
              icon: FaIcon(
                FontAwesomeIcons.facebook,
                size: 26,
                color: Colors.white,
              ),
              onTap: _handleFacebookSignIn,
            ),
          ],
        ),
      ],
    );
  }
}

Color _iconColorForBackground(Color background) {
  final luminance = background.computeLuminance();
  return luminance > 0.5 ? AppColors.textPrimary : Colors.white;
}

class _LoginOptionIcon extends StatelessWidget {
  final Color? backgroundColor;
  final Widget icon;
  final VoidCallback? onTap;

  const _LoginOptionIcon({
    this.backgroundColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 48,
          height: AppDimensions.buttonHeight,
          decoration: BoxDecoration(
            color: bg,
            border: bg == null ? Border.all(color: Colors.grey.shade300) : null,
            borderRadius: BorderRadius.circular(12),
            boxShadow: bg != null
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
