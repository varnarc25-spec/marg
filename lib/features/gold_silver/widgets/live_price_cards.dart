import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/marg_api_service.dart';

/// Live gold & silver in vertical layout: 4 cells —
/// Global Gold (USD/oz), Global Silver (USD/oz), Gold ₹/gm, Silver ₹/gm.
class LivePriceCards extends StatefulWidget {
  const LivePriceCards({super.key, required this.apiService});

  final MargApiService apiService;

  @override
  State<LivePriceCards> createState() => _LivePriceCardsState();
}

class _LivePriceCardsState extends State<LivePriceCards> {
  Map<String, dynamic>? _response;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _response = null;
      _error = null;
    });
    try {
      final data = await widget.apiService.getGoldSilverRates();
      if (mounted) {
        setState(() {
          _response = data;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = _response == null && _error == null;
    final data = _response?['data'] is Map ? _response!['data'] as Map : null;
    final rates = data?['rates'] is Map
        ? data!['rates'] as Map<String, dynamic>
        : null;
    final change = data?['change'] is Map
        ? data!['change'] as Map<String, dynamic>
        : null;
    final global = _response?['global'] is Map
        ? _response!['global'] as Map<String, dynamic>
        : null;
    final goldGlobal = global?['gold'] is Map ? global!['gold'] as Map : null;
    final silverGlobal = global?['silver'] is Map
        ? global!['silver'] as Map
        : null;

    final globalGoldUsd = goldGlobal?['usdPerOz']?.toString() ?? '--';
    final globalSilverUsd = silverGlobal?['usdPerOz']?.toString() ?? '--';
    // Gold/silver INR per gram: use data.rates.gBuy/sBuy only (do not use global.gold.inrPerGram / global.silver.inrPerGram).
    final gBuy = rates?['gBuy']?.toString() ?? '--';
    final sBuy = rates?['sBuy']?.toString() ?? '--';

    String formatUsd(String v) {
      if (v == '--') return v;
      final n = double.tryParse(v);
      if (n == null) return v;
      if (n >= 1000) return '\$${(n).toStringAsFixed(0)}';
      return '\$$v';
    }

    String changeText(Map<dynamic, dynamic>? c) {
      if (c == null) return '';
      final amount = (c['amount'] as num?)?.toDouble();
      final percent = (c['percent'] as num?)?.toDouble();
      final positive = c['positive'] == true;
      if (amount == null && percent == null) return '';
      final sign = positive ? '+' : '';
      final amtStr = amount != null ? '$sign${amount.toStringAsFixed(2)}' : '';
      final pctStr = percent != null
          ? ' ($sign${percent.toStringAsFixed(2)}%)'
          : '';
      if (amtStr.isEmpty && pctStr.isEmpty) return '';
      return '$amtStr$pctStr'.trim();
    }

    bool changePositive(Map<dynamic, dynamic>? c) =>
        c != null && c['positive'] == true;

    final goldUsdChange = change?['goldUsd'] as Map<dynamic, dynamic>?;
    final silverUsdChange = change?['silverUsd'] as Map<dynamic, dynamic>?;
    final gBuyChange = change?['gBuy'] as Map<dynamic, dynamic>?;
    final sBuyChange = change?['sBuy'] as Map<dynamic, dynamic>?;

    return GestureDetector(
      onTap: _error != null ? _load : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _LiveIndexCell(
            label: 'Global Gold',
            value: isLoading ? '...' : '${formatUsd(globalGoldUsd)} /oz',
            changeText: changeText(goldUsdChange),
            positive: changePositive(goldUsdChange),
          ),
          const SizedBox(height: 14),
          _LiveIndexCell(
            label: 'Global Silver',
            value: isLoading ? '...' : '${formatUsd(globalSilverUsd)} /oz',
            changeText: changeText(silverUsdChange),
            positive: changePositive(silverUsdChange),
          ),
          const SizedBox(height: 14),
          _LiveIndexCell(
            label: 'Gold',
            value: isLoading ? '...' : '₹$gBuy /gm',
            changeText: changeText(gBuyChange),
            positive: changePositive(gBuyChange),
          ),
          const SizedBox(height: 14),
          _LiveIndexCell(
            label: 'Silver',
            value: isLoading ? '...' : '₹$sBuy /gm',
            changeText: changeText(sBuyChange),
            positive: changePositive(sBuyChange),
          ),
        ],
      ),
    );
  }
}

/// One row: label — value — changeText (horizontal).
class _LiveIndexCell extends StatelessWidget {
  final String label;
  final String value;
  final String changeText;
  final bool positive;

  const _LiveIndexCell({
    required this.label,
    required this.value,
    required this.changeText,
    required this.positive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(
            label,
            style: theme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: theme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (changeText.isNotEmpty) ...[
            const SizedBox(width: 8),
            Text(
              changeText,
              style: theme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: positive ? AppColors.accentGreen : AppColors.accentRed,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
