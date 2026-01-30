import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../core/services/mock_kyc_service.dart';
import '../../../../../data/models/user_session.dart';
import 'aadhaar_verification_screen.dart';

/// PAN Verification Screen
/// First step in KYC flow
class PanVerificationScreen extends ConsumerStatefulWidget {
  const PanVerificationScreen({super.key});

  @override
  ConsumerState<PanVerificationScreen> createState() => _PanVerificationScreenState();
}

class _PanVerificationScreenState extends ConsumerState<PanVerificationScreen> {
  final _panController = TextEditingController();
  bool _isLoading = false;
  bool _isVerified = false;

  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  Future<void> _verifyPAN() async {
    final panNumber = _panController.text.trim().toUpperCase();

    if (panNumber.isEmpty) {
      _showError('Please enter your PAN number');
      return;
    }

    // Validate PAN format: ABCDE1234F
    final panRegex = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$');
    if (!panRegex.hasMatch(panNumber)) {
      _showError('Invalid PAN format. Please enter a valid PAN (e.g., ABCDE1234F)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final kycService = MockKycService();
      await kycService.verifyPAN(panNumber);

      if (!mounted) return;

      // Update KYC status
      await ref.read(userSessionProvider.notifier).updateKycStatus(
        KycStatus.panVerified,
      );

      setState(() => _isVerified = true);

      // Navigate to next step after a brief delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const AadhaarVerificationScreen(),
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.accentRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PAN Verification'),
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
                  Expanded(child: Container(height: 2, color: Colors.grey.shade300)),
                  _buildProgressStep(2, 'Aadhaar', false),
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
                    Icons.badge_outlined,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Verify Your PAN',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your Permanent Account Number (PAN) to continue',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // PAN Input
              TextField(
                controller: _panController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 10,
                decoration: InputDecoration(
                  labelText: 'PAN Number',
                  hintText: 'ABCDE1234F',
                  prefixIcon: const Icon(Icons.badge),
                  suffixIcon: _isVerified
                      ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                      : null,
                ),
                style: const TextStyle(
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
                enabled: !_isLoading && !_isVerified,
              ),
              const SizedBox(height: 8),
              Text(
                'Format: 5 letters, 4 digits, 1 letter (e.g., ABCDE1234F)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              // Verify Button
              if (!_isVerified)
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyPAN,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify PAN'),
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check_circle, color: AppColors.accentGreen),
                      SizedBox(width: 8),
                      Text(
                        'PAN Verified Successfully',
                        style: TextStyle(
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
