import 'package:flutter/material.dart';
import 'transfer_balance_list_contact_screen.dart';

/// Screen 106: Transfer Balance - Confirmation – Transfer Preview card, Transfer Now
const Color _confirmPurple = Color(0xFF6C63FF);
const Color _darkPurple = Color(0xFF3D3780);

class TransferBalanceConfirmationScreen extends StatelessWidget {
  final double amount;
  final TransferContact contact;

  const TransferBalanceConfirmationScreen({
    super.key,
    required this.amount,
    required this.contact,
  });

  @override
  Widget build(BuildContext context) {
    const fee = 2.00;
    final total = amount + fee;
    const transferId = '123Tyu890XBNu';
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
          'Transfer Preview',
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
                      Center(
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: _confirmPurple.withValues(alpha: 0.2),
                          child: Text(
                            contact.initial,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6C63FF),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Transfer (USD)',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${amount.toStringAsFixed(2)}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 24),
                      _detailRow('Transfer ID', transferId),
                      const SizedBox(height: 12),
                      _detailRow('Recipient', contact.name),
                      const SizedBox(height: 12),
                      _detailRow('Transfer amount', '\$${amount.toStringAsFixed(2)}'),
                      const SizedBox(height: 12),
                      _detailRow('Transfer fee', '\$${fee.toStringAsFixed(2)}'),
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
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _confirmPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Transfer Now'),
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
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
