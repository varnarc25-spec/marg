import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Base scaffold used for all Gold & Silver feature pages.
class _GoldSilverFeaturePage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _GoldSilverFeaturePage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.iconTilePastelBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            const Text(
              'This is a placeholder screen. Integrate your gold & silver flows, APIs and KYC checks here.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuyGoldPage extends StatelessWidget {
  const BuyGoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Buy Gold',
      subtitle: 'Purchase digital 24K gold instantly at live market prices.',
      icon: Icons.monetization_on_rounded,
    );
  }
}

class BuySilver999Page extends StatelessWidget {
  const BuySilver999Page({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Buy Silver (999)',
      subtitle: 'Invest in 999 purity digital silver with full price transparency.',
      icon: Icons.diamond_rounded,
    );
  }
}

class DailyGoldSavingsPage extends StatelessWidget {
  const DailyGoldSavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Daily Gold Savings',
      subtitle: 'Automate small daily contributions into digital gold.',
      icon: Icons.savings_rounded,
    );
  }
}

class DailySilverSavingsPage extends StatelessWidget {
  const DailySilverSavingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Daily Silver Savings',
      subtitle: 'Build long-term silver exposure with SIP-style investments.',
      icon: Icons.savings_outlined,
    );
  }
}

class SmartSipPage extends StatelessWidget {
  const SmartSipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Smart SIP (Auto-buy on dips)',
      subtitle: 'Configure rules to auto-buy gold/silver when prices dip.',
      icon: Icons.auto_graph_rounded,
    );
  }
}

class PortfolioHoldingsPage extends StatelessWidget {
  const PortfolioHoldingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Portfolio & Holdings',
      subtitle: 'Track quantity, average price, and current value of holdings.',
      icon: Icons.account_balance_wallet_rounded,
    );
  }
}

class ProfitLossPage extends StatelessWidget {
  const ProfitLossPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Profit / Loss',
      subtitle: 'View mark-to-market P&L across all gold & silver positions.',
      icon: Icons.show_chart_rounded,
    );
  }
}

class PriceAlertsPage extends StatelessWidget {
  const PriceAlertsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Price Alerts',
      subtitle: 'Set custom alerts when gold or silver crosses your target levels.',
      icon: Icons.notifications_active_rounded,
    );
  }
}

class SellGoldSilverPage extends StatelessWidget {
  const SellGoldSilverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Sell Gold / Silver',
      subtitle: 'Exit positions and withdraw to your linked bank account.',
      icon: Icons.currency_exchange_rounded,
    );
  }
}

class ConvertPhysicalGoldPage extends StatelessWidget {
  const ConvertPhysicalGoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Convert to Physical Gold',
      subtitle: 'Request doorstep delivery or store at a secure vault partner.',
      icon: Icons.local_shipping_rounded,
    );
  }
}

class ConvertPhysicalSilverPage extends StatelessWidget {
  const ConvertPhysicalSilverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Convert to Physical Silver',
      subtitle: 'Convert digital silver units into coins or bars.',
      icon: Icons.local_shipping_outlined,
    );
  }
}

class GiftGoldSilverPage extends StatelessWidget {
  const GiftGoldSilverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Gift Gold / Silver',
      subtitle: 'Send digital gold or silver to friends and family securely.',
      icon: Icons.card_giftcard_rounded,
    );
  }
}

class FamilyVaultPage extends StatelessWidget {
  const FamilyVaultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Family Vault',
      subtitle: 'Create a shared vault for family investments and goals.',
      icon: Icons.lock_rounded,
    );
  }
}

class NomineeManagementPage extends StatelessWidget {
  const NomineeManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Nominee Management',
      subtitle: 'Add / update nominees for smooth transmission of assets.',
      icon: Icons.person_add_alt_1_rounded,
    );
  }
}

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Transaction History',
      subtitle: 'Browse all buy, sell, convert and gift transactions.',
      icon: Icons.history_rounded,
    );
  }
}

class TaxCapitalGainsReportPage extends StatelessWidget {
  const TaxCapitalGainsReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Tax & Capital Gains Report',
      subtitle: 'Download ready-to-file capital gains statements for tax filing.',
      icon: Icons.receipt_long_rounded,
    );
  }
}

class AnnualStatementPage extends StatelessWidget {
  const AnnualStatementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _GoldSilverFeaturePage(
      title: 'Annual Statement',
      subtitle: 'Get a consolidated annual summary of your holdings and flows.',
      icon: Icons.description_rounded,
    );
  }
}

