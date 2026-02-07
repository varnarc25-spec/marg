import 'package:flutter/material.dart';

/// Purple accent for order success (per design)
const Color _successPurple = Color(0xFF6C63FF);

/// Order Success screen – success icon, confirmation message, amount, Show Details and Done buttons
class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildSuccessIcon(context),
              const SizedBox(height: 28),
              _buildMessage(context),
              const SizedBox(height: 8),
              _buildAmount(context),
              const Spacer(flex: 2),
              _buildShowDetailsButton(context),
              const SizedBox(height: 14),
              _buildDoneButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: _successPurple,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _successPurple.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: const Icon(
        Icons.check_rounded,
        color: Colors.white,
        size: 64,
      ),
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Text(
      'Successfully purchased.',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }

  Widget _buildAmount(BuildContext context) {
    return Text(
      '0.061 BTC',
      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  Widget _buildShowDetailsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        style: FilledButton.styleFrom(
          backgroundColor: _successPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Show Details'),
      ),
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: _successPurple,
          side: BorderSide(color: _successPurple.withValues(alpha: 0.6)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Done'),
      ),
    );
  }
}
