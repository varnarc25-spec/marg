import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/providers/app_providers.dart';
import '../../features/gold_silver/models/augmont_rates_models.dart';

/// Live buy price card for gold/silver.
/// - Internally calls [augmontRatesProvider] to get gBuy/sBuy and GST from GET /rates.
/// - Shows fallback values from config while loading or when API is unavailable.
class LiveBuyPriceCard extends ConsumerStatefulWidget {
  final String label;
  final bool isGold;
  final String fallbackValue;
  final String fallbackMeta;

  const LiveBuyPriceCard({
    super.key,
    required this.label,
    required this.isGold,
    required this.fallbackValue,
    required this.fallbackMeta,
  });

  @override
  ConsumerState<LiveBuyPriceCard> createState() => _LiveBuyPriceCardState();
}

class _LiveBuyPriceCardState extends ConsumerState<LiveBuyPriceCard> {
  Timer? _hourlyRefreshTimer;

  @override
  void dispose() {
    _hourlyRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncRates = ref.watch(augmontRatesProvider);

    // Start hourly refresh when this card is visible.
    if (_hourlyRefreshTimer == null) {
      _hourlyRefreshTimer = Timer.periodic(const Duration(hours: 1), (_) {
        if (mounted) ref.invalidate(augmontRatesProvider);
      });
    }

    String value = widget.fallbackValue;
    String meta = widget.fallbackMeta;

    final AugmontRates? data = asyncRates.valueOrNull;
    if (data != null) {
      final r = data.rates;
      if (widget.isGold) {
        value = '₹${r.gBuy}/gm';
        meta =
            r.gBuyGst != '0' ? '(+GST ₹${r.gBuyGst}/gm)' : '(+3% GST)';
      } else {
        value = '₹${r.sBuy}/gm';
        meta =
            r.sBuyGst != '0' ? '(+GST ₹${r.sBuyGst}/gm)' : '(+3% GST)';
      }
    } else if (asyncRates.isLoading) {
      value = '...';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Live',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                ),
                children: [
                  TextSpan(text: '${widget.label} '),
                  TextSpan(
                    text: value,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: meta,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

