import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../home/presentation/screens/wealth_home_screen.dart';
import '../../../home/presentation/widgets/home_bottom_nav_widget.dart';
import '../../../learning/presentation/screens/learning_hub_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../support/presentation/screens/about_app_screen.dart';
import '../../../support/presentation/screens/help_center_screen.dart';
import 'personal_data_edit_screen.dart';
import 'personal_data_screen.dart';

/// Menu / My Account – Overview (market, funds, account), then profile card, News/Chats/Settings, menu list, bottom nav
const Color _accountPurple = Color(0xFF6C63FF);
const Color _newsAmber = Color(0xFFFFE082);
const Color _chatsGreen = Color(0xFFA5D6A7);
const Color _settingsBlue = Color(0xFFB39DDB);
const Color _essentialOrange = Color(0xFFFF9800);
const Color _positiveGreen = Color(0xFF2E7D32);
const Color _chartBlue = Color(0xFF1976D2);

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _MenuItem({required this.icon, required this.title, required this.onTap});
}

class MyAccountScreen extends ConsumerStatefulWidget {
  const MyAccountScreen({super.key});

  @override
  ConsumerState<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends ConsumerState<MyAccountScreen> {
  bool _overviewExpanded = false;

  static String _displayName(WidgetRef ref) {
    final session = ref.watch(userSessionProvider);
    final authService = ref.watch(firebaseAuthServiceProvider);
    final user = authService.getCurrentUser();
    final profile = ref.watch(userProfileProvider).value;
    final name = profile?.name;
    if (name != null && name.isNotEmpty) return name;
    if (user?.displayName != null && user!.displayName!.isNotEmpty) return user.displayName!;
    final email = session?.email ?? user?.email;
    if (email != null && email.isNotEmpty) return email.split('@').first;
    final phone = session?.phoneNumber ?? user?.phoneNumber;
    if (phone != null && phone.isNotEmpty) return phone;
    return 'User';
  }

  static String _displayEmailOrPhone(ref) {
    final session = ref.watch(userSessionProvider);
    final authService = ref.watch(firebaseAuthServiceProvider);
    final user = authService.getCurrentUser();
    final email = session?.email ?? user?.email;
    if (email != null && email.isNotEmpty) return email;
    final phone = session?.phoneNumber ?? user?.phoneNumber;
    if (phone != null && phone.isNotEmpty) return phone;
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final onboardingComplete = ref.watch(onboardingCompleteProvider);
    final name = _displayName(ref);
    final emailOrPhone = _displayEmailOrPhone(ref);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          if (!onboardingComplete)
            SliverToBoxAdapter(child: _buildOnboardingBanner(context)),
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildExpandableOverview(context),
                    const SizedBox(height: 20),
                    _buildAccountOverviewContent(context, name: name, emailOrPhone: emailOrPhone),
                    const SizedBox(height: 24),
                    ..._menuItems(context).map((e) => _MenuTile(icon: e.icon, title: e.title, onTap: e.onTap)),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          SliverFillRemaining(hasScrollBody: false, child: const SizedBox.shrink()),
        ],
      ),
      bottomNavigationBar: HomeBottomNav(
        selectedIndex: 3,
        onHomeTap: () => Navigator.of(context).pop(),
        onWealthTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const WealthHomeScreen()),
          );
        },
        onDiscoverTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const LearningHubScreen()),
          );
        },
        onProfileTap: () {},
      ),
    );
  }

  List<_MenuItem> _menuItems(BuildContext context) {
    return [
      _MenuItem(
        icon: Icons.info_outline_rounded,
        title: 'About',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AboutAppScreen()),
          );
        },
      ),
    ];
  }

  Widget _buildExpandableOverview(BuildContext context) {
    if (!_overviewExpanded) {
      return InkWell(
        onTap: () => setState(() => _overviewExpanded = true),
        borderRadius: BorderRadius.circular(12),
        child: _buildMarketOverview(context, expanded: false),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildMarketOverview(context, expanded: true)),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => setState(() => _overviewExpanded = false),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              style: IconButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Funds',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          '₹309.20',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      ],
    );
  }

  Widget _buildAccountOverviewContent(
    BuildContext context, {
    required String name,
    required String emailOrPhone,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildProfileCard(context, name: name, emailOrPhone: emailOrPhone, onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PersonalDataEditScreen()),
          );
        }),
        const SizedBox(height: 20),
        _buildQuickNavButtons(context),
        const SizedBox(height: 24),
        _buildPrivacyModeRow(context),
        const SizedBox(height: 24),
        _buildSectionHeading(context, 'Account'),
        const SizedBox(height: 8),
        _OverviewLink(title: 'Funds', icon: Icons.currency_rupee_rounded, trailing: '₹309.20', onTap: () {}),
        _OverviewLink(title: 'App Code', icon: Icons.lock_outline_rounded, onTap: () {}),
        _OverviewLink(title: 'Profile', icon: Icons.person_outline_rounded, onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PersonalDataScreen()),
          );
        }),
        _OverviewLink(title: 'Personal Details', icon: Icons.person_outline_rounded, onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PersonalDataScreen()),
          );
        }),
        _OverviewLink(title: 'Identify Verification', icon: Icons.badge_outlined, onTap: () {}),
        _OverviewLink(title: 'Transaction History', icon: Icons.receipt_long_outlined, onTap: () {}),
        const SizedBox(height: 24),
        _buildSectionHeading(context, 'Console'),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: [
            _ConsoleChip(label: 'Portfolio', onTap: () {}),
            _ConsoleChip(label: 'Tradebook', onTap: () {}),
            _ConsoleChip(label: 'P&L', onTap: () {}),
            _ConsoleChip(label: 'Tax P&L', onTap: () {}),
            _ConsoleChip(label: 'Gift stocks', onTap: () {}),
            _ConsoleChip(label: 'Family', onTap: () {}),
            _ConsoleChip(label: 'Downloads', onTap: () {}),
          ],
        ),
        const SizedBox(height: 24),
        _buildSectionHeading(context, 'Support'),
        const SizedBox(height: 8),
        _OverviewLink(title: 'Support portal', icon: Icons.support_rounded, onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
          );
        }),
        _OverviewLink(title: 'User manual', icon: Icons.help_outline_rounded, onTap: () {}),
        _OverviewLink(title: 'Contact', icon: Icons.phone_outlined, onTap: () {}),
        const SizedBox(height: 24),
        _buildSectionHeading(context, 'Others'),
        const SizedBox(height: 8),
        _OverviewLink(title: 'Invite friends', icon: Icons.person_add_outlined, onTap: () {}),
        _OverviewLink(title: 'Licenses', icon: Icons.description_outlined, onTap: () {}),
        _OverviewLink(title: 'Share', icon: Icons.share_rounded, onTap: () {}),
        _OverviewLink(title: 'Rate us', icon: Icons.star_rounded, onTap: () {}),
      ],
    );
  }

  Widget _buildMarketOverview(BuildContext context, {required bool expanded}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NIFTY 50',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            '25,693.70',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '+50.90 (+0.19%)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: _positiveGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (expanded) ...[
                      const SizedBox(height: 8),
                      _buildMiniChartPlaceholder(context),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'NIFTY BANK',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Flexible(
                          child: Text(
                            '60,120.55',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            '+56.90 (+0.09%)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: _positiveGreen,
                                  fontWeight: FontWeight.w600,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (expanded) ...[
                      const SizedBox(height: 8),
                      _buildMiniChartPlaceholder(context),
                    ],
                  ],
                ),
              ),
              if (!expanded)
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 32,
                ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 10),
            Text(
              '* Charts indicate 52 weeks trend',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMiniChartPlaceholder(BuildContext context) {
    return Container(
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [_chartBlue.withValues(alpha: 0.3), _chartBlue],
        ),
        boxShadow: [
          BoxShadow(
            color: _chartBlue.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );
  }

  static bool _privacyMode = false;

  Widget _buildPrivacyModeRow(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Privacy mode',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            Switch(
              value: _privacyMode,
              onChanged: (v) => setState(() => _privacyMode = v),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeading(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );
  }

  Widget _OverviewLink({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? trailing,
  }) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              if (trailing != null && trailing.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    trailing,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ),
              Icon(icon, size: 20, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ConsoleChip({required String label, required VoidCallback onTap}) {
    return Builder(
      builder: (context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _chartBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _chartBlue,
                ),
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.9),
      child: SafeArea(
        top: true,
        bottom: false,
        child: Row(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 22,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Please complete the onboarding process',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, {required String name, required String emailOrPhone, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      shadowColor: Colors.black.withValues(alpha: 0.06),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: _accountPurple.withValues(alpha: 0.2),
                child: Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _accountPurple),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.diamond_rounded, size: 14, color: _essentialOrange),
                        const SizedBox(width: 4),
                        Text(
                          'Essential',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: _essentialOrange,
                              ),
                        ),
                      ],
                    ),
                    if (emailOrPhone.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        emailOrPhone,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickNavButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickNavButton(
            label: 'News',
            icon: Icons.newspaper_rounded,
            color: _newsAmber,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickNavButton(
            label: 'Chats',
            icon: Icons.chat_bubble_outline_rounded,
            color: _chatsGreen,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickNavButton(
            label: 'Settings',
            icon: Icons.settings_rounded,
            color: _settingsBlue,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

}

class _QuickNavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickNavButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 28, color: Colors.black87),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ),
            Icon(Icons.chevron_right_rounded, size: 22, color: Theme.of(context).colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}
