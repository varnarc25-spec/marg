import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Offers section: included offers, promo code, discount list.
class FlightBookingOffersSection extends StatefulWidget {
  const FlightBookingOffersSection({
    super.key,
    required this.selectedOffer,
    required this.onOfferChanged,
  });

  final int? selectedOffer;
  final ValueChanged<int?> onOfferChanged;

  @override
  State<FlightBookingOffersSection> createState() =>
      _FlightBookingOffersSectionState();
}

class _FlightBookingOffersSectionState
    extends State<FlightBookingOffersSection> {
  final _promoController = TextEditingController();
  bool _showAllOffers = false;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Included offers ──
            Text(
              'Offers included in your booking',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _IncludedOfferChip(
                    title: '50% off on meals',
                    subtitle: 'Auto-applied on meal selection',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '+',
                    style: textTheme.titleMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: _IncludedOfferChip(
                    title: '30% off on seats',
                    subtitle: 'Auto-applied on seat selection',
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Apply promo ──
            Text(
              'Apply one more offer',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Have a promocode? Type here',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: colorScheme.outline.withValues(alpha: 0.3),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Apply',
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ── Discount offers ──
            _DiscountOffer(
              icon: Icons.percent_rounded,
              iconColor: AppColors.primaryBlue,
              title: 'Discount worth ₹500',
              description:
                  'Avail up to Rs. 5000 instant discount on flight ticket bookings. T&C',
              promoCode: 'FLYDEAL',
              selected: widget.selectedOffer == 0,
              onTap: () => widget.onOfferChanged(
                widget.selectedOffer == 0 ? null : 0,
              ),
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            Divider(
              color: colorScheme.outline.withValues(alpha: 0.15),
              height: 1,
            ),

            _DiscountOffer(
              icon: Icons.account_balance_rounded,
              iconColor: AppColors.accentRed,
              title: 'Discount worth ₹1,026',
              description:
                  'Flat 14% instant discount up to Rs. 1500 with BOBCARD full swipe and EMI transactions. T&C',
              promoCode: 'BOBSALE',
              selected: widget.selectedOffer == 1,
              onTap: () => widget.onOfferChanged(
                widget.selectedOffer == 1 ? null : 1,
              ),
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),

            const SizedBox(height: 8),

            // +22 offers
            Center(
              child: TextButton(
                onPressed: () =>
                    setState(() => _showAllOffers = !_showAllOffers),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Bank icons placeholder
                    for (final color in [
                      AppColors.primaryBlue,
                      AppColors.accentGreen,
                      AppColors.accentOrange,
                      AppColors.accentRed,
                    ])
                      Container(
                        width: 22,
                        height: 22,
                        margin: const EdgeInsets.only(right: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_rounded,
                          size: 12,
                          color: color,
                        ),
                      ),
                    const SizedBox(width: 4),
                    Text(
                      '+22 offers',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      _showAllOffers
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: AppColors.accentGreen,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Included offer chip ──

class _IncludedOfferChip extends StatelessWidget {
  const _IncludedOfferChip({
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.accentGreen.withValues(alpha: 0.3),
        ),
        color: AppColors.accentGreen.withValues(alpha: 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Discount offer row ──

class _DiscountOffer extends StatelessWidget {
  const _DiscountOffer({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.promoCode,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String promoCode;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.accentGreen.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      promoCode,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              size: 22,
              color: selected
                  ? AppColors.primaryBlue
                  : colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
