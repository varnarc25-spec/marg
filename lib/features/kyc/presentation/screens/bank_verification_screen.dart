import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../core/services/mock_kyc_service.dart';
import '../../../../../data/models/user_session.dart';
import 'kyc_completion_screen.dart';

/// Bank Verification Screen
/// Third step in KYC flow - Penny drop verification
class BankVerificationScreen extends ConsumerStatefulWidget {
  const BankVerificationScreen({super.key});

  @override
  ConsumerState<BankVerificationScreen> createState() => _BankVerificationScreenState();
}

class _BankVerificationScreenState extends ConsumerState<BankVerificationScreen> {
  final _accountController = TextEditingController();
  final _ifscController = TextEditingController();
  bool _isLoading = false;
  bool _isVerified = false;

  @override
  void dispose() {
    _accountController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  Future<void> _verifyBankAccount() async {
    final accountNumber = _accountController.text.trim();
    final ifscCode = _ifscController.text.trim().toUpperCase();

    if (accountNumber.isEmpty || ifscCode.isEmpty) {
      _showError('Please enter both account number and IFSC code');
      return;
    }

    if (accountNumber.length < 9) {
      _showError('Account number must be at least 9 digits');
      return;
    }

    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(ifscCode)) {
      _showError('Invalid IFSC code format (e.g., HDFC0001234)');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final kycService = MockKycService();
      await kycService.verifyBankAccount(
        accountNumber: accountNumber,
        ifscCode: ifscCode,
      );

      if (!mounted) return;

      // Update KYC status
      await ref.read(userSessionProvider.notifier).updateKycStatus(
        KycStatus.bankVerified,
      );

      setState(() => _isVerified = true);

      // Navigate to completion screen after a brief delay
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const KycCompletionScreen(),
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
        title: const Text('Bank Verification'),
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
                  Expanded(child: Container(height: 2, color: AppColors.accentGreen)),
                  _buildProgressStep(3, 'Bank', true),
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
                    Icons.account_balance,
                    size: 40,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Verify Your Bank Account',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'We will verify your account using a penny drop',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Account Number Input
              TextField(
                controller: _accountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Account Number',
                  hintText: 'Enter your account number',
                  prefixIcon: const Icon(Icons.account_balance_wallet),
                  suffixIcon: _isVerified
                      ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                      : null,
                ),
                enabled: !_isLoading && !_isVerified,
              ),
              const SizedBox(height: 24),
              // IFSC Code Input
              TextField(
                controller: _ifscController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 11,
                decoration: InputDecoration(
                  labelText: 'IFSC Code',
                  hintText: 'HDFC0001234',
                  prefixIcon: const Icon(Icons.code),
                  suffixIcon: _isVerified
                      ? const Icon(Icons.check_circle, color: AppColors.accentGreen)
                      : null,
                ),
                style: const TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.w600,
                ),
                enabled: !_isLoading && !_isVerified,
              ),
              const SizedBox(height: 8),
              Text(
                'Format: 4 letters, 0, 6 alphanumeric (e.g., HDFC0001234)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 32),
              // Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'About Penny Drop',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'A small amount (₹1) will be credited to your account to verify '
                      'the account details. This is a standard verification process.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Verify Button
              if (!_isVerified)
                ElevatedButton(
                  onPressed: _isLoading ? null : _verifyBankAccount,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify Bank Account'),
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
                        'Bank Account Verified',
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
