import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../core/services/firebase_auth_service.dart';
import '../../../../../features/onboarding/presentation/screens/language_selection_screen.dart';

/// Auth Method Enum
enum AuthMethod {
  phone,
  email,
}

/// OTP Verification Screen
/// Verifies OTP sent to phone or email
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String verificationId;
  final String? phoneNumber;
  final String? email;
  final AuthMethod authMethod;

  const OtpVerificationScreen({
    super.key,
    required this.verificationId,
    this.phoneNumber,
    this.email,
    required this.authMethod,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendCountdown();
      }
    });
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showError('Please enter 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = FirebaseAuthService();
      Map<String, dynamic> userData;

      if (widget.authMethod == AuthMethod.phone) {
        userData = await authService.verifyPhoneOTP(
          verificationId: widget.verificationId,
          smsCode: otp,
        );
      } else {
        // Email OTP verification is not directly supported
        throw Exception('Email OTP verification is not supported. Please use phone OTP or email/password.');
      }

      if (!mounted) return;

      // Create user session
      await ref.read(userSessionProvider.notifier).createSessionAfterLogin(
        firebaseUid: userData['uid'] as String,
        email: userData['email'] as String?,
        phoneNumber: userData['phoneNumber'] as String?,
      );

      // Navigate to onboarding or home
      final onboardingComplete = ref.read(onboardingCompleteProvider);
      if (onboardingComplete) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const LanguageSelectionScreen(),
          ),
        );
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOTP() async {
    if (_resendCountdown > 0 || _isResending) return;

    setState(() {
      _isResending = true;
      _resendCountdown = 60;
    });

    try {
      final authService = FirebaseAuthService();
      
      if (widget.authMethod == AuthMethod.phone) {
        await authService.sendPhoneOTPWithCallback(
          widget.phoneNumber!,
          (verificationId) {
            // Code sent - update the verification ID if needed
          },
        );
      } else {
        throw Exception('Email OTP resend is not supported.');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            backgroundColor: AppColors.accentGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _startResendCountdown();
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _getMaskedContact() {
    if (widget.authMethod == AuthMethod.phone) {
      final phone = widget.phoneNumber ?? '';
      if (phone.length > 4) {
        return '${phone.substring(0, 3)}****${phone.substring(phone.length - 2)}';
      }
      return phone;
    } else {
      final email = widget.email ?? '';
      final parts = email.split('@');
      if (parts.length == 2) {
        final username = parts[0];
        if (username.length > 2) {
          return '${username.substring(0, 2)}***@${parts[1]}';
        }
        return '***@${parts[1]}';
      }
      return email;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.authMethod == AuthMethod.phone
                        ? Icons.phone_android
                        : Icons.email,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Enter Verification Code',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We sent a 6-digit code to',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                _getMaskedContact(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // OTP Input
              PinCodeTextField(
                appContext: context,
                length: 6,
                controller: _otpController,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 60,
                  fieldWidth: 50,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primaryBlue,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: AppColors.primaryBlue,
                ),
                enableActiveFill: true,
                onCompleted: (value) {
                  _verifyOTP();
                },
                onChanged: (value) {},
              ),
              const SizedBox(height: 32),
              // Verify Button
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyOTP,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify OTP'),
              ),
              const SizedBox(height: 24),
              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  if (_resendCountdown > 0)
                    Text(
                      'Resend in ${_resendCountdown}s',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _isResending ? null : _resendOTP,
                      child: _isResending
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Resend OTP'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              // Help text
              Text(
                'Note: OTP is mocked for demo. Check console for OTP value.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
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
