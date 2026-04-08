import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/widgets/marg_header.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../widgets/invest_card.dart';
import '../../../../shared/widgets/live_buy_price_card.dart';
import '../../../../shared/widgets/price_chart_card.dart';
import '../../../../shared/widgets/faq_section.dart';
import '../../../../shared/widgets/trends_section.dart';
import '../../../../shared/widgets/powered_by_footer.dart';
import '../../../../shared/widgets/shop_section.dart';
import '../../../../shared/widgets/info_icons_row.dart';
import '../../models/metal_config.dart';
export '../../models/metal_config.dart';

/// Base scaffold used for Gold & Silver placeholder pages.
class GoldSilverFeaturePlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GoldSilverFeaturePlaceholderPage({
    super.key,
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
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full buy flow page (used by Buy Gold / Buy Silver).
/// Fetches live rates from GET /api/account/augmont/rates and refreshes every hour while on screen.
class BuyMetalPage extends ConsumerStatefulWidget {
  final MetalConfig config;

  const BuyMetalPage({super.key, required this.config});

  @override
  ConsumerState<BuyMetalPage> createState() => _BuyMetalPageState();
}

class _BuyMetalPageState extends ConsumerState<BuyMetalPage> {
  final _amountController = TextEditingController();
  bool _buyInRupees = true;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setQuickAmount(int amount) {
    _amountController.text = amount.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final amountText = _amountController.text.trim();
    final hasAmount = amountText.isNotEmpty;
    final l10n = ProviderScope.containerOf(context).read(l10nProvider);
    final remoteBrand = ref.watch(appRemoteSettingsProvider).valueOrNull;
    final isGold = c.appBarTitle.toLowerCase().contains('gold');

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            MargHeader(
              l10n: l10n,
              brandName: remoteBrand?.displayAppName,
              logoUrl: remoteBrand?.logoUrl,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () => Navigator.of(context).pop(),
                color: AppColors.textPrimary,
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  _BalanceCard(title: c.balanceTitle, accent: c.accentColor),
                  const SizedBox(height: 12),
                  LiveBuyPriceCard(
                    label: c.buyPriceLabel,
                    isGold: isGold,
                    fallbackValue: c.buyPriceValue,
                    fallbackMeta: c.buyPriceMeta,
                  ),
                  const SizedBox(height: 12),
                  PriceChartCard(
                    accent: c.accentColor,
                    fill: c.chartFill,
                    riseText: c.riseText,
                  ),
                  const SizedBox(height: 12),
                  InvestCard(
                    accent: c.accentColor,
                    investTitle: c.investTitle,
                    purityText: c.purityText,
                    buyInRupees: _buyInRupees,
                    amountController: _amountController,
                    onBuyInRupeesChanged: (v) =>
                        setState(() => _buyInRupees = v),
                    onQuickAmount: _setQuickAmount,
                    hasAmount: hasAmount,
                  ),
                  const SizedBox(height: 16),
                  InfoIconsRow(accent: c.accentColor),
                  const SizedBox(height: 16),
                  ShopSection(sectionKey: c.sectionKey),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  FaqSection(sectionKey: c.sectionKey),
                  const SizedBox(height: 16),
                  TrendsSection(sectionKey: c.sectionKey),
                  const SizedBox(height: 24),
                  const PoweredByFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final Color accent;

  const _BalanceCard({required this.title, required this.accent});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'In Grams',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Color(0xFFFFC107)),
                        SizedBox(width: 8),
                        Text(
                          '0.0000 gms',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 44, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Value*',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Color(0xFFFFC107)),
                        SizedBox(width: 8),
                        Text(
                          '₹0.00',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              '*Value based on sell price',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Manage Your Gold Savings',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
