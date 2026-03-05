import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_data.dart';
import 'add_bank_credit_card_page.dart';

/// Pay Credit Card Bill page: offer banner, bank grid, services, recommended card.
/// Matches screenshot layout; uses app theme (bike insurance style).
class PayCreditCardBillPage extends StatelessWidget {
  const PayCreditCardBillPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Pay Credit Card Bill',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 16),
          _OfferBanner(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 16),
          _BankGridCard(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 16),
          _ServicesRow(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 20),
          _RecommendedSection(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 16),
          _PaytmMoneyBanner(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 20),
          _RecommendedServicesRow(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 24),
          _FooterLogos(textTheme: textTheme),
        ],
      ),
    );
  }
}

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.secondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.flight_rounded,
            size: 28,
            color: colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Get a flight voucher worth ₹750',
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(Icons.arrow_forward_rounded, size: 18, color: colorScheme.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankGridCard extends StatelessWidget {
  const _BankGridCard({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    const crossAxisCount = 3;
    final banks = popularBanks;
    final items = [...banks, null];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final bank = items[index];
            if (bank == null) {
              return _ViewMoreBanksItem(colorScheme: colorScheme, textTheme: textTheme);
            }
            return _BankGridItem(
              bank: bank,
              colorScheme: colorScheme,
              textTheme: textTheme,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => AddBankCreditCardPage(bankName: bank.name),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _BankGridItem extends StatelessWidget {
  const _BankGridItem({
    required this.bank,
    required this.colorScheme,
    required this.textTheme,
    required this.onTap,
  });

  final CardRepayBank bank;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                bank.displayLetter,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              bank.name.length > 12 ? '${bank.name.substring(0, 10)}...' : bank.name,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewMoreBanksItem extends StatelessWidget {
  const _ViewMoreBanksItem({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(Icons.arrow_forward_rounded, color: colorScheme.primary, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              'View More Banks',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _ServicesRow extends StatelessWidget {
  const _ServicesRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cardRepayServices.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final service = cardRepayServices[index];
          return Card(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(service.icon, color: colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          service.title,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          service.subtitle,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RecommendedSection extends StatelessWidget {
  const _RecommendedSection({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final product = recommendedCreditCard;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RECOMMENDED FOR YOU',
          style: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.accentOrange,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  product.tags,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 2.8,
                        children: product.benefits.map((b) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(b.icon, size: 18, color: colorScheme.primary),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  b.text,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.credit_card_rounded, size: 56, color: colorScheme.primary),
                  ],
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'JOINING FEE: ${product.joiningFee}',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: FilledButton(
                    onPressed: () {},
                    child: Text(product.ctaLabel),
                  ),
                ),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    'Terms and conditions applied',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PaytmMoneyBanner extends StatelessWidget {
  const _PaytmMoneyBanner({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: colorScheme.primaryContainer.withValues(alpha: 0.25),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.trending_up_rounded, color: colorScheme.primary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Charges slashed for you!',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text('Claim Now →'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StrikePrice(label: 'ACCOUNT OPENING', oldPrice: '₹200', newPrice: '₹0'),
                _StrikePrice(label: 'BROKERAGE*', oldPrice: '₹200', newPrice: '₹0'),
                _StrikePrice(label: 'MTF INTEREST*', oldPrice: '₹200', newPrice: '₹0'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StrikePrice extends StatelessWidget {
  const _StrikePrice({
    required this.label,
    required this.oldPrice,
    required this.newPrice,
  });

  final String label;
  final String oldPrice;
  final String newPrice;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          oldPrice,
          style: textTheme.bodySmall?.copyWith(
            decoration: TextDecoration.lineThrough,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          newPrice,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _RecommendedServicesRow extends StatelessWidget {
  const _RecommendedServicesRow({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Services',
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: recommendedServicesList.map((s) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(s.icon, color: colorScheme.primary, size: 24),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          s.label,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FooterLogos extends StatelessWidget {
  const _FooterLogos({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Paytm',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Bharat Connect',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'VISA',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'RuPay',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
