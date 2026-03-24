import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';

/// Light promo strip under the title (e.g. bank offer).
class DthPromoBanner extends StatelessWidget {
  const DthPromoBanner({
    super.key,
    this.text = 'Exclusive offers on select bank cards. View All',
    this.onViewAll,
  });

  final String text;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFE8F5E9),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onViewAll,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.local_offer_outlined,
                color: Colors.green.shade800,
                size: 22,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade900,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                'View All ›',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
