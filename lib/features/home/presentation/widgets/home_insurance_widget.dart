import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';

/// Dark blue promotional banner for health insurance: "Did you know?" / "Health plans start at ₹224/mo*".
class HomeInsuranceBanner extends ConsumerWidget {
  const HomeInsuranceBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.homeInsuranceBannerSubtitle,
                    style: GoogleFonts.mulish(
                      fontSize: 12,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.homeInsuranceBannerTitle,
                    style: GoogleFonts.mulish(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white24,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.shield_rounded,
              size: 40,
              color: Colors.deepPurple.shade200,
            ),
          ],
        ),
      ),
    );
  }
}

/// Insurance hub: Bike, Car, Health, Life.
class HomeInsuranceHub extends StatelessWidget {
  const HomeInsuranceHub({super.key, required this.items});

  final List<HomeIconGridItem> items;

  @override
  Widget build(BuildContext context) {
    return HomeIconGrid(items: items, columns: 4, maxItems: 4);
  }
}
