import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/services/mock_mpin_service.dart';

/// MPIN Verification Bottom Sheet
/// Used before placing real money trades
class MpinVerificationSheet extends StatefulWidget {
  final Function(String) onVerified;
  final VoidCallback? onCancel;

  const MpinVerificationSheet({
    super.key,
    required this.onVerified,
    this.onCancel,
  });

  @override
  State<MpinVerificationSheet> createState() => _MpinVerificationSheetState();
}

class _MpinVerificationSheetState extends State<MpinVerificationSheet> {
  final _mpinController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _mpinController.dispose();
    super.dispose();
  }

  Future<void> _verifyMpin() async {
    final mpin = _mpinController.text.trim();

    if (mpin.length != 4) {
      setState(() => _errorMessage = 'Please enter 4-digit MPIN');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final mpinService = MockMpinService();
      final isValid = await mpinService.verifyMpin(mpin);

      if (!mounted) return;

      if (isValid) {
        widget.onVerified(mpin);
        Navigator.of(context).pop();
      } else {
        setState(() {
          _errorMessage = 'Incorrect MPIN. Please try again.';
          _mpinController.clear();
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _mpinController.clear();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Text(
                'Enter MPIN',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your MPIN to authorize this transaction',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // MPIN Input
              PinCodeTextField(
                appContext: context,
                length: 4,
                controller: _mpinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(12),
                  fieldHeight: 60,
                  fieldWidth: 60,
                  activeFillColor: Colors.white,
                  inactiveFillColor: Colors.white,
                  selectedFillColor: Colors.white,
                  activeColor: AppColors.primaryBlue,
                  inactiveColor: Colors.grey.shade300,
                  selectedColor: AppColors.primaryBlue,
                ),
                enableActiveFill: true,
                onCompleted: (value) {
                  _verifyMpin();
                },
                onChanged: (value) {
                  setState(() => _errorMessage = null);
                },
              ),
              // Error message
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppColors.accentRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: AppColors.accentRed,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              // Verify Button
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyMpin,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verify MPIN'),
              ),
              const SizedBox(height: 12),
              // Cancel Button
              TextButton(
                onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Helper function to show MPIN verification sheet
Future<bool> showMpinVerification({
  required BuildContext context,
  required Function(String) onVerified,
  VoidCallback? onCancel,
}) async {
  bool verified = false;
  
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => MpinVerificationSheet(
      onVerified: (mpin) {
        verified = true;
        onVerified(mpin);
      },
      onCancel: onCancel,
    ),
  );
  
  return verified;
}
