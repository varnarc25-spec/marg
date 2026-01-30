import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../data/models/user_session.dart';
import '../../../mpin/presentation/screens/mpin_setup_screen.dart';

/// KYC Completion Screen
/// Final step showing KYC completion and enabling real trading
class KycCompletionScreen extends ConsumerStatefulWidget {
  const KycCompletionScreen({super.key});

  @override
  ConsumerState<KycCompletionScreen> createState() => _KycCompletionScreenState();
}

class _KycCompletionScreenState extends ConsumerState<KycCompletionScreen> {
  bool _isLoading = false;

  Future<void> _completeKYC() async {
    setState(() => _isLoading = true);

    try {
      // Update KYC status to completed
      await ref.read(userSessionProvider.notifier).updateKycStatus(
        KycStatus.completed,
      );

      // Enable real trading
      await ref.read(userSessionProvider.notifier).enableRealTrading();

      if (!mounted) return;

      // Navigate to MPIN setup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => MpinSetupScreen(),
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KYC Verification'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              // Success Icon
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 60,
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'KYC Verification Complete!',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'All your documents have been verified successfully',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Checklist
              _buildChecklistItem('PAN Verified', true),
              const SizedBox(height: 16),
              _buildChecklistItem('Aadhaar Verified', true),
              const SizedBox(height: 16),
              _buildChecklistItem('Bank Account Verified', true),
              const SizedBox(height: 48),
              // Info Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.lock_open,
                          color: AppColors.primaryBlue,
                          size: 24,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Real Trading Unlocked',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'You can now trade with real money. Set up your MPIN to secure your transactions.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              // Risk Disclosure
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
                          Icons.warning_amber_rounded,
                          color: AppColors.accentOrange,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Risk Disclosure',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Trading in securities involves risk. Please trade responsibly and only '
                      'invest what you can afford to lose. Past performance is not indicative '
                      'of future results.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              // Continue Button
              ElevatedButton(
                onPressed: _isLoading ? null : _completeKYC,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Continue to MPIN Setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChecklistItem(String label, bool isCompleted) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.accentGreen : Colors.grey.shade300,
          ),
          child: isCompleted
              ? const Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                )
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              decoration: isCompleted ? TextDecoration.lineThrough : null,
              color: isCompleted ? AppColors.textSecondary : null,
            ),
          ),
        ),
      ],
    );
  }
}
