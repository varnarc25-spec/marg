import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../shared/providers/app_providers.dart';
import '../../../../../core/services/mock_mpin_service.dart';
import '../../../home/presentation/screens/home_screen.dart';

/// MPIN Setup Screen
/// Allows users to set up a 4-digit MPIN for transaction authorization
class MpinSetupScreen extends ConsumerStatefulWidget {
  const MpinSetupScreen({super.key});

  @override
  ConsumerState<MpinSetupScreen> createState() => _MpinSetupScreenState();
}

class _MpinSetupScreenState extends ConsumerState<MpinSetupScreen> {
  final _mpinController = TextEditingController();
  final _confirmMpinController = TextEditingController();
  bool _isLoading = false;
  bool _isMpinSet = false;
  bool _isConfirmStep = false;

  @override
  void dispose() {
    _mpinController.dispose();
    _confirmMpinController.dispose();
    super.dispose();
  }

  Future<void> _setMpin() async {
    final mpin = _mpinController.text.trim();

    if (mpin.length != 4) {
      _showError('MPIN must be 4 digits');
      return;
    }

    if (!RegExp(r'^\d{4}$').hasMatch(mpin)) {
      _showError('MPIN must contain only numbers');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final mpinService = MockMpinService();
      await mpinService.setMpin(mpin);

      if (!mounted) return;

      // Store MPIN hash in user session
      // In real app, this would be a proper hash
      final mpinHash = 'hashed_${mpin.hashCode}';
      await ref.read(userSessionProvider.notifier).setMpin(mpinHash);

      setState(() {
        _isMpinSet = true;
        _isConfirmStep = true;
      });

      // Clear first MPIN field
      _mpinController.clear();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _confirmMpin() async {
    final mpin = _mpinController.text.trim();
    final confirmMpin = _confirmMpinController.text.trim();

    if (mpin.length != 4 || confirmMpin.length != 4) {
      _showError('Please enter 4-digit MPIN');
      return;
    }

    if (mpin != confirmMpin) {
      _showError('MPINs do not match. Please try again.');
      _mpinController.clear();
      _confirmMpinController.clear();
      setState(() => _isConfirmStep = false);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final mpinService = MockMpinService();
      await mpinService.setMpin(mpin);

      if (!mounted) return;

      // Store MPIN hash in user session
      final mpinHash = 'hashed_${mpin.hashCode}';
      await ref.read(userSessionProvider.notifier).setMpin(mpinHash);

      setState(() => _isMpinSet = true);

      // Navigate to home after success
      await Future.delayed(const Duration(seconds: 1));
      
      if (!mounted) return;

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => HomeScreen()),
        (route) => false,
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
        title: const Text('Set Up MPIN'),
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
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 50,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                _isConfirmStep ? 'Confirm Your MPIN' : 'Create Your MPIN',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _isConfirmStep
                    ? 'Re-enter your 4-digit MPIN to confirm'
                    : 'Set a 4-digit MPIN to secure your transactions',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // MPIN Input
              if (!_isConfirmStep) ...[
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _mpinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 70,
                    fieldWidth: 70,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: Colors.grey.shade300,
                    selectedColor: AppColors.primaryBlue,
                  ),
                  enableActiveFill: true,
                  onCompleted: (value) {
                    _setMpin();
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _setMpin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Continue'),
                ),
              ] else ...[
                PinCodeTextField(
                  appContext: context,
                  length: 4,
                  controller: _mpinController,
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 70,
                    fieldWidth: 70,
                    activeFillColor: Colors.white,
                    inactiveFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    activeColor: AppColors.primaryBlue,
                    inactiveColor: Colors.grey.shade300,
                    selectedColor: AppColors.primaryBlue,
                  ),
                  enableActiveFill: true,
                  onCompleted: (value) {
                    _confirmMpin();
                  },
                  onChanged: (value) {},
                ),
                const SizedBox(height: 16),
                Text(
                  'Re-enter MPIN',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _isLoading ? null : _confirmMpin,
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Confirm MPIN'),
                ),
              ],
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
                          'About MPIN',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your MPIN is required to authorize real money transactions. '
                      'Keep it secure and do not share it with anyone.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Skip option (for testing)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => HomeScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
