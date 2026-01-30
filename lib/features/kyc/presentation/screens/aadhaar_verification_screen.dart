import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../core/services/mock_kyc_service.dart';
import '../../../../../data/models/user_session.dart';
import 'bank_verification_screen.dart';

/// Aadhaar Verification Screen
/// Second step in KYC flow
class AadhaarVerificationScreen extends ConsumerStatefulWidget {
  const AadhaarVerificationScreen({super.key});

  @override
  ConsumerState<AadhaarVerificationScreen> createState() => _AadhaarVerificationScreenState();
}

class _AadhaarVerificationScreenState extends ConsumerState<AadhaarVerificationScreen> {
  final _aadhaarController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isOtpSent = false;
  bool _isVerified = false;
  int _resendCountdown = 60;

  @override
  void initState() {
    super.initState();
    if (_isOtpSent) {
      _startResendCountdown();
    }
  }

  @override
  void dispose() {
    _aadhaarController.dispose();
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

  Future<void> _sendOTP() async {
    final aadhaarNumber = _aadhaarController.text.trim().replaceAll(' ', '');

    if (aadhaarNumber.isEmpty) {
      _showError('Please enter your Aadhaar number');
      return;
    }

    // Validate Aadhaar format: 12 digits
    if (!RegExp(r'^\d{12}$').hasMatch(aadhaarNumber)) {
      _showError('Please enter a valid 12-digit Aadhaar number');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final kycService = MockKycService();
      await kycService.sendAadhaarOTP(aadhaarNumber);

      if (!mounted) return;

      setState(() {
        _isOtpSent = true;
        _resendCountdown = 60;
      });
      _startResendCountdown();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpController.text.trim();
    final aadhaarNumber = _aadhaarController.text.trim().replaceAll(' ', '');

    if (otp.length != 6) {
      _showError('Please enter 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final kycService = MockKycService();
      await kycService.verifyAadhaarOTP(aadhaarNumber, otp);

      if (!mounted) return;

      // Update KYC status
      await ref.read(userSessionProvider.notifier).updateKycStatus(
        KycStatus.aadhaarVerified,
      );

      setState(() => _isVerified = true);

      // Navigate to next step after a brief delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const BankVerificationScreen(),
        ),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOTP() async {
    if (_resendCountdown > 0) return;
    await _sendOTP();
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

  String _getMaskedAadhaar() {
    final aadhaar = _aadhaarController.text.trim().replaceAll(' ', '');
    if (aadhaar.length >= 8) {
      return '${aadhaar.substring(0, 4)} **** ${aadhaar.substring(aadhaar.length - 4)}';
    }
    return aadhaar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhaar Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Progress indicator
              Row(
                children: [
                  _buildProgressStep(1, 'PAN', true),
                  Expanded(child: Container(height: 2, color: AppColors.accentGreen)),
                  _buildProgressStep(2, 'Aadhaar', true),
                  Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                  _buildProgressStep(3, 'Bank', false),
                ],
              ),
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
                  child: const Icon(
                    Icons.fingerprint,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Verify Your Aadhaar',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your 12-digit Aadhaar number',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Aadhaar Input
              TextField(
                controller: _aadhaarController,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                  labelText: 'Aadhaar Number',
                  hintText: '1234 5678 9012',
                  prefixIcon: const Icon(Icons.badge),
                  suffixIcon: _isVerified
                      ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                      : null,
                ),
                enabled: !_isLoading && !_isVerified && !_isOtpSent,
              ),
              const SizedBox(height: 8),
              Text(
                'We will send an OTP to your registered mobile number',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              // Send OTP Button
              if (!_isOtpSent && !_isVerified)
                ElevatedButton(
                  onPressed: _isLoading ? null : _sendOTP,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Send OTP'),
                ),
              // OTP Input Section
              if (_isOtpSent && !_isVerified) ...[
                const SizedBox(height: 16),
                Text(
                  'Enter OTP sent to mobile linked with Aadhaar',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  _getMaskedAadhaar(),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
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
                const SizedBox(height: 24),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive OTP? ",
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
                        onPressed: _resendOTP,
                        child: const Text('Resend OTP'),
                      ),
                  ],
                ),
              ],
              // UIDAI Disclaimer
              if (!_isVerified) ...[
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.accentOrange.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.accentOrange,
                            size: 20,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'UIDAI Disclaimer',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Aadhaar number is used only for verification purposes. '
                        'We do not store your Aadhaar number.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStep(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
