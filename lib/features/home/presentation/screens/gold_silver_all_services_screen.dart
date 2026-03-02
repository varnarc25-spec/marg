import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_icon_tile.dart';
import '../../../gold_silver/presentation/screens/gold_silver_screens.dart';

class GoldSilverAllServicesScreen extends StatelessWidget {
  const GoldSilverAllServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Gold & Silver – All Services'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          const _LivePricesHeader(),
          const SizedBox(height: 20),
          _ServicesSection(
            title: 'Invest',
            icon: Icons.savings_rounded,
            items: [
              _ServiceItem('Buy Gold', Icons.monetization_on_rounded,
                  builder: (_) => const BuyGoldPage()),
              _ServiceItem('Buy Silver (999)', Icons.diamond_rounded,
                  builder: (_) => const BuySilver999Page()),
              _ServiceItem('Daily Gold Savings', Icons.savings_rounded,
                  builder: (_) => const DailyGoldSavingsPage()),
              _ServiceItem('Daily Silver Savings', Icons.savings_outlined,
                  builder: (_) => const DailySilverSavingsPage()),
              _ServiceItem('Smart SIP ', Icons.auto_graph_rounded,
                  builder: (_) => const SmartSipPage()),
              _ServiceItem('Gift Gold / Silver', Icons.card_giftcard_rounded,
                  builder: (_) => const GiftGoldSilverPage()),
              _ServiceItem('Family Vault', Icons.lock_rounded,
                  builder: (_) => const FamilyVaultPage()),
              _ServiceItem('Nominees',
                  Icons.person_add_alt_1_rounded,
                  builder: (_) => const NomineeManagementPage()),
            ],
          ),
          const SizedBox(height: 18),
          _ServicesSection(
            title: 'Manage',
            icon: Icons.pie_chart_outline_rounded,
            items: [
              _ServiceItem('Portfolio & Holdings',
                  Icons.account_balance_wallet_rounded,
                  builder: (_) => const PortfolioHoldingsPage()),
              _ServiceItem('Profit / Loss', Icons.show_chart_rounded,
                  builder: (_) => const ProfitLossPage()),
              _ServiceItem('Price Alerts', Icons.notifications_active_rounded,
                  builder: (_) => const PriceAlertsPage()),
              _ServiceItem('Sell Gold / Silver',
                  Icons.currency_exchange_rounded,
                  builder: (_) => const SellGoldSilverPage()),
              _ServiceItem('Convert to Physical Gold',
                  Icons.local_shipping_rounded,
                  builder: (_) => const ConvertPhysicalGoldPage()),
              _ServiceItem('Convert to Physical Silver',
                  Icons.local_shipping_outlined,
                  builder: (_) => const ConvertPhysicalSilverPage()),
            ],
          ),
          const SizedBox(height: 18),
          _ServicesSection(
            title: 'Reports',
            icon: Icons.receipt_long_rounded,
            items: [
              _ServiceItem('Transaction History', Icons.history_rounded,
                  builder: (_) => const TransactionHistoryPage()),
              _ServiceItem('Tax & Capital Gains Report',
                  Icons.receipt_long_rounded,
                  builder: (_) => const TaxCapitalGainsReportPage()),
              _ServiceItem('Annual Statement', Icons.description_rounded,
                  builder: (_) => const AnnualStatementPage()),
            ],
          ),
        ],
      ),
    );
  }
}

class _LivePricesHeader extends StatelessWidget {
  const _LivePricesHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _LivePriceCard(
            title: 'Live Gold',
            subtitle: '₹10,139.44 / gm',
            gradient: [
              Color(0xFFFFB74D),
              Color(0xFFFFA726),
              Color(0xFFFF9800),
            ],
            icon: Icons.monetization_on_rounded,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _LivePriceCard(
            title: 'Live Silver',
            subtitle: '₹120.50 / gm',
            gradient: [
              Color(0xFFE5E7EB),
              Color(0xFFCBD5E1),
              Color(0xFF94A3B8),
            ],
            icon: Icons.diamond_rounded,
          ),
        ),
      ],
    );
  }
}

class _LivePriceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  const _LivePriceCard({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          Icon(icon, color: Colors.white, size: 26),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

class _ServicesSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_ServiceItem> items;

  const _ServicesSection({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlueDark, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 14,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, i) {
              final item = items[i];
              final bg = i.isEven
                  ? AppColors.iconTilePastelBlue
                  : AppColors.iconTilePastelPurple;
              return _ServiceTile(
                label: item.label,
                icon: item.icon,
                backgroundColor: bg,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: item.builder),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ServiceItem {
  final String label;
  final IconData icon;
  final WidgetBuilder builder;

  const _ServiceItem(this.label, this.icon, {required this.builder});
}

class _ServiceTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onTap;

  const _ServiceTile({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppIconTile(
      icon: icon,
      label: label,
      size: 58,
      iconColor: Colors.white,
      backgroundColor: backgroundColor,
      onTap: onTap,
    );
  }
}

