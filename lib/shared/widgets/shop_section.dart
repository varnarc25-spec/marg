import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../models/shop_product_item.dart';
import '../../core/theme/app_theme.dart';

/// Reusable \"Shop\" section for gold/silver pages.
/// Loads products from [shopProductsProvider] using [sectionKey] (e.g. 'gold_buy').
class ShopSection extends ConsumerWidget {
  final String sectionKey;

  const ShopSection({super.key, required this.sectionKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProducts = ref.watch(shopProductsProvider(sectionKey));

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
      child: asyncProducts.when(
        loading: () => const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Shop for Gold Coins & Jewellery',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load products right now. Please try again later.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        data: (items) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Shop for Gold Coins & Jewellery',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              const _MiniFeatureRow(),
              const SizedBox(height: 14),
              if (items.isNotEmpty) _ProductsRow(items: items),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Shop Now',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Go To Cart',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MiniFeatureRow extends StatelessWidget {
  const _MiniFeatureRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _MiniFeatureCard(
            'Guaranteed Purity\nWith BIS Hallmark',
            Icons.verified_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MiniFeatureCard(
            'Tamper-Proof\nPackaging & Secure\nDelivery',
            Icons.local_shipping_outlined,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: _MiniFeatureCard(
            'Simple & Transparent\nProcess',
            Icons.thumb_up_alt_outlined,
          ),
        ),
      ],
    );
  }
}

class _MiniFeatureCard extends StatelessWidget {
  final String text;
  final IconData icon;
  const _MiniFeatureCard(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductsRow extends StatelessWidget {
  final List<ShopProductItem> items;
  const _ProductsRow({required this.items});

  @override
  Widget build(BuildContext context) {
    final products = items.take(2).toList();
    return Row(
      children: [
        for (var i = 0; i < products.length; i++) ...[
          Expanded(
            child: _ProductCard(item: products[i]),
          ),
          if (i == 0 && products.length > 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ShopProductItem item;

  const _ProductCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.workspace_premium_rounded,
                color: Color(0xFFFFC107),
                size: 30,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(item.title,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(
            item.meta,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(item.price,
              style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () {},
            child: const Text('Add To Cart'),
          ),
        ],
      ),
    );
  }
}

