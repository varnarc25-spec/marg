import 'package:flutter/material.dart';
import 'package:marg/features/financial_hub/invest/presentation/pages/invet_search_page.dart';
import 'stock_details.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../data/invest_list_data.dart';

/// Invest page: search bar, market indices (NIFTY/SENSEX),
/// Investment Ideas carousel, Market Movers (Top Gainers/Losers), News,
/// Expert Recommendations, Investor Tools grid.
/// Uses app theme colors and structure similar to bike insurance home.
class InvestPage extends StatefulWidget {
  const InvestPage({super.key});

  @override
  State<InvestPage> createState() => _InvestPageState();
}

class _InvestPageState extends State<InvestPage> {
  int _marketMoversTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const StockSearchPage(),
                ),
              );
            },
            decoration: InputDecoration(
              hintText: 'Search Stocks',
              hintStyle: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 22,
                color: colorScheme.onSurfaceVariant,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
            ),
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ),
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Material(
              color: colorScheme.primary.withValues(alpha: 0.2),
              shape: const CircleBorder(),
              child: InkWell(
                onTap: () {},
                customBorder: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'A',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 16),
          _MarketIndicesSection(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 20),
          _SectionHeader(
            title: 'Investment Ideas',
            onViewAll: () {},
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: investIdeas.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _InvestmentIdeaCard(
                    item: investIdeas[i],
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _PageDots(count: investIdeas.length, current: 0),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Market Movers',
            onViewAll: () {},
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 12),
          _MarketMoversTabs(
            selectedIndex: _marketMoversTabIndex,
            onTap: (i) => setState(() => _marketMoversTabIndex = i),
            tabLabels: investMarketMoverTabs,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 12),
          ...investTopGainers.map(
            (item) => _MarketMoverTile(
              item: item,
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeaderWithIcon(
            title: 'News in, action on!',
            icon: Icons.article_outlined,
            onViewAll: () {},
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: investNewsItems.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _NewsCard(
                    item: investNewsItems[i],
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          _PageDots(count: investNewsItems.length, current: 1),
          const SizedBox(height: 24),
          _SectionHeader(
            title: 'Expert Recommendations',
            onViewAll: () {},
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 4),
          Text(
            'Verified research, aggregated by Refinitiv',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: investExpertRecommendations.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _ExpertRecommendationCard(
                    item: investExpertRecommendations[i],
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Investor Tools',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: investTools.map((t) {
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(t.icon, size: 32, color: colorScheme.primary),
                        const SizedBox(height: 12),
                        Text(
                          t.label,
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MarketIndicesSection extends StatelessWidget {
  const _MarketIndicesSection({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: investMarketIndices.map((index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index.name} ${index.value}',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${index.change} (${index.changePercent})',
                        style: textTheme.bodySmall?.copyWith(
                          color: index.isPositive
                              ? AppColors.accentGreen
                              : AppColors.accentRed,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (index.name == 'SENSEX')
                      Icon(
                        Icons.star_border_rounded,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onViewAll,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final VoidCallback onViewAll;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeaderWithIcon extends StatelessWidget {
  const _SectionHeaderWithIcon({
    required this.title,
    required this.icon,
    required this.onViewAll,
    required this.colorScheme,
    required this.textTheme,
  });

  final String title;
  final IconData icon;
  final VoidCallback onViewAll;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: onViewAll,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _InvestmentIdeaCard extends StatelessWidget {
  const _InvestmentIdeaCard({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  final InvestmentIdeaItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 220,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (item.logoColor ?? colorScheme.primary).withValues(
                      alpha: 0.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item.title.substring(0, 1).toUpperCase(),
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: item.logoColor ?? colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '${item.price} ${item.change} (${item.changePercent})',
              style: textTheme.bodyMedium?.copyWith(
                color: item.isPositive
                    ? AppColors.accentGreen
                    : AppColors.accentRed,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.buyPrice,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  item.targetPrice,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              item.poweredBy,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketMoversTabs extends StatelessWidget {
  const _MarketMoversTabs({
    required this.selectedIndex,
    required this.onTap,
    required this.tabLabels,
    required this.colorScheme,
    required this.textTheme,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<String> tabLabels;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(tabLabels.length, (i) {
          final selected = i == selectedIndex;
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () => onTap(i),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tabLabels[i],
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: selected
                          ? colorScheme.onSurface
                          : colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 3,
                    width: selected ? 24 : 0,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _MarketMoverTile extends StatelessWidget {
  const _MarketMoverTile({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  final MarketMoverItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StockDetailPage(
              stockName: item.name,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      item.name.substring(0, 1).toUpperCase(),
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        item.exchange,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.price,
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${item.change} (${item.changePercent})',
                      style: textTheme.bodySmall?.copyWith(
                        color: item.isPositive
                            ? AppColors.accentGreen
                            : AppColors.accentRed,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: colorScheme.outline.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  final InvestNewsItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.8,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item.companyName.substring(0, 1).toUpperCase(),
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: item.isPositive
                        ? AppColors.accentGreen.withValues(alpha: 0.15)
                        : AppColors.accentRed.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${item.price} (${item.changePercent})',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: item.isPositive
                          ? AppColors.accentGreen
                          : AppColors.accentRed,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                item.headline,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  height: 1.3,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              item.timestamp,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpertRecommendationCard extends StatelessWidget {
  const _ExpertRecommendationCard({
    required this.item,
    required this.colorScheme,
    required this.textTheme,
  });

  final ExpertRecommendationItem item;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 240,
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accentRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      item.companyName
                          .split(' ')
                          .map((w) => w[0])
                          .take(2)
                          .join(),
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.accentRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.companyName,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.price} ${item.changePercent}',
                        style: textTheme.bodySmall?.copyWith(
                          color: item.isPositive
                              ? AppColors.accentGreen
                              : AppColors.accentRed,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  size: 18,
                  color: AppColors.accentGreen,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    item.recommendationText,
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Icon(
              Icons.speed_rounded,
              size: 32,
              color: colorScheme.primary.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count.clamp(0, 5), (i) {
        final selected = i == current;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }
}
