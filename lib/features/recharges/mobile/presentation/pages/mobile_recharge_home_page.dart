import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../data/models/mobile_operator.dart';
import '../../data/models/mobile_recharge_history_item.dart';
import '../providers/mobile_recharge_provider.dart';
import 'contact_picker_page.dart';
import 'mobile_operator_selection_page.dart';
import 'mobile_plan_list_page.dart';
import 'mobile_recent_history_page.dart';
import '../../../../../../shared/widgets/hub_ads_slides_carousel.dart';
import '../widgets/reminder_permission_card.dart';

/// Purple accent for Mobile Recharge screen (PhonePe-style).
const Color _mobileRechargePurple = Color(0xFF6B2D91);

/// Mobile Recharge home: banner, search, validity reminder, quick top-up, recents.
class MobileRechargeHomePage extends ConsumerStatefulWidget {
  const MobileRechargeHomePage({
    super.key,
    this.menuItemSlug = 'mobile-recharge',
  });

  /// Service/menu item slug used for server-driven reminder targeting.
  final String menuItemSlug;

  @override
  ConsumerState<MobileRechargeHomePage> createState() =>
      _MobileRechargeHomePageState();
}

class _MobileRechargeHomePageState
    extends ConsumerState<MobileRechargeHomePage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mobile Recharge',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 8),
          HubAdsSlidesCarousel(
            section: 'recharge-bill-payment',
            category: 'recharges',
            menuItem: widget.menuItemSlug,
          ),
          const SizedBox(height: 20),
          _SearchBar(
            controller: _searchController,
            onContactsTap: () async {
              final result = await Navigator.of(context)
                  .push<ContactPickerResult>(
                    MaterialPageRoute(
                      builder: (_) => const ContactPickerPage(),
                    ),
                  );
              if (result != null && mounted) {
                _searchController.text = result.number;
                ref.read(mobileRechargeNumberProvider.notifier).state =
                    result.number;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MobileOperatorSelectionPage(),
                  ),
                );
              }
            },
            onSearchSubmit: (query) {
              final digits = query.replaceAll(RegExp(r'\D'), '');
              if (digits.length >= 10) {
                final number = digits.length > 10
                    ? digits.substring(digits.length - 10)
                    : digits;
                ref.read(mobileRechargeNumberProvider.notifier).state = number;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const MobileOperatorSelectionPage(),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          ReminderPermissionCard(
            menuItemSlug: widget.menuItemSlug,
            channel: 'local_notifications',
          ),
          const SizedBox(height: 24),
          const Text(
            'Quick Data Top-up',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const _QuickDataTopUpSection(),
          const SizedBox(height: 24),
          const _RecentsSection(),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'By proceeding further, you allow the app to fetch your current and future plan expiry information and remind you.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onContactsTap;
  final void Function(String query)? onSearchSubmit;

  const _SearchBar({
    required this.controller,
    required this.onContactsTap,
    this.onSearchSubmit,
  });

  static const _searchBorderRadius = 12.0;
  static const _buttonBlue = Color(0xFF1E88E5);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(_searchBorderRadius),
              border: Border.all(color: const Color(0xFFE0E0E0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(_searchBorderRadius),
              child: TextField(
                controller: controller,
                onSubmitted: onSearchSubmit,
                style: const TextStyle(fontSize: 15),
                decoration: InputDecoration(
                  hintText: 'Search by Number or Name',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    color: AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary,
                    size: 22,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_searchBorderRadius),
                    borderSide: const BorderSide(color: _buttonBlue, width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(_searchBorderRadius),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  disabledBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.iconTileBackground,
            borderRadius: BorderRadius.circular(_searchBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(_searchBorderRadius),
            child: InkWell(
              onTap: onContactsTap,
              borderRadius: BorderRadius.circular(_searchBorderRadius),
              child: const Center(
                child: Icon(
                  Icons.contacts_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickDataTopUpSection extends ConsumerWidget {
  const _QuickDataTopUpSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(mobileQuickTopUpProvider);
    return async.when(
      data: (list) => SizedBox(
        height: 112,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: list.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (context, i) {
            final e = list[i];
            return _QuickTopUpCard(entry: e);
          },
        ),
      ),
      loading: () => const SizedBox(
        height: 112,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox(height: 48),
    );
  }
}

class _QuickTopUpCard extends ConsumerWidget {
  final QuickTopUpEntry entry;

  const _QuickTopUpCard({required this.entry});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: const Color(0xFFF8F8F8),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: () {
          ref.read(mobileRechargeNumberProvider.notifier).state = entry.number;
          ref.read(selectedMobileOperatorProvider.notifier).state =
              MobileOperator(id: entry.operatorId, name: entry.operatorName);
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const MobilePlanListPage()));
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 160,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: _mobileRechargePurple.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      entry.operatorName.length >= 2
                          ? entry.operatorName.substring(0, 2)
                          : entry.operatorName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _mobileRechargePurple,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: _mobileRechargePurple,
                    child: const Icon(
                      Icons.arrow_forward_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Text(
                entry.alias,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                entry.dataPlanLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Default number of recent transactions to show on home before "View all".
const int _kRecentsLimit = 5;

class _RecentsSection extends ConsumerWidget {
  const _RecentsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(mobileHistoryProvider);
    return async.when(
      data: (items) {
        final showViewAll = items.length > _kRecentsLimit;
        final displayItems = items.take(_kRecentsLimit).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'RECENTS',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                if (showViewAll)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const MobileRecentHistoryPage(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...displayItems.map((item) => _RecentTile(item: item)),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text(
        'Error: $e',
        style: const TextStyle(color: AppColors.textSecondary),
      ),
    );
  }
}

class _RecentTile extends ConsumerWidget {
  final MobileRechargeHistoryItem item;

  const _RecentTile({required this.item});

  static String _formatDate(DateTime d) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(mobileRechargeNumberProvider.notifier).state = item.number;
        ref
            .read(selectedMobileOperatorProvider.notifier)
            .state = MobileOperator(
          id: item.operatorName.toLowerCase().replaceAll(' ', '_'),
          name: item.operatorName,
        );
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const MobilePlanListPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: _mobileRechargePurple.withValues(alpha: 0.12),
              child: Text(
                item.avatarText,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _mobileRechargePurple,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.displayName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.number,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Last Recharge: ₹${item.amount.toInt()} on ${_formatDate(item.date)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.more_vert_rounded,
                color: AppColors.textSecondary,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
