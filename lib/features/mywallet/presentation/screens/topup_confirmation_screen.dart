import 'package:flutter/material.dart';
import 'topup_success_screen.dart';

/// Screen 100: Topup Balance - Confirmation – Deposit Preview card on dark purple, Deposit Now
const Color _confirmPurple = Color(0xFF6C63FF);
const Color _darkPurple = Color(0xFF3D3780);

class TopupConfirmationScreen extends StatelessWidget {
  final double amount;
  final double fee;

  const TopupConfirmationScreen({super.key, required this.amount, required this.fee});

  @override
  Widget build(BuildContext context) {
    final total = amount + fee;
    const depositId = '123Tyu890XBNu';
    const payment = 'Bank of America';
    const time = '31 Oct 2022, 02:00 PM';

    return Scaffold(
      backgroundColor: _darkPurple,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Deposit Preview',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: _darkPurple,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: _confirmPurple,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'B',
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Deposit (USD)',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                ),
                                Text(
                                  '+ \$${amount.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00C853),
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _detailRow('Deposit ID', depositId),
                      const SizedBox(height: 12),
                      _detailRow('Deposit amount', '\$${amount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _detailRow('Deposit fee', '\$${fee.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _detailRow('Payment', payment),
                      const SizedBox(height: 12),
                      _detailRow('Time', time),
                      const SizedBox(height: 12),
                      _detailRow('Total amount', '\$${total.toStringAsFixed(2)}'),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const TopupSuccessScreen()),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _confirmPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Deposit Now'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.black54, fontSize: 14),
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
