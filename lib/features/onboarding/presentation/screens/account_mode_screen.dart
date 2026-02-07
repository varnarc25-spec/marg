import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/progress_indicator_widget.dart';
import '../../../../shared/widgets/app_icon_tile.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'onboarding_success_screen.dart';

/// Account Mode Selection Screen
/// Users choose between Paper Trading (default) and Real Trading (locked)
/// Same layout as goal and experience screens.
class AccountModeScreen extends ConsumerStatefulWidget {
  const AccountModeScreen({super.key});

  @override
  ConsumerState<AccountModeScreen> createState() => _AccountModeScreenState();
}

class _AccountModeScreenState extends ConsumerState<AccountModeScreen> {
  String? selectedMode;
  int? expandedIndex;

  static List<Map<String, dynamic>> _modes(AppLocalizations l10n) => [
        {'id': 'paper', 'title': l10n.accountPaper, 'description': l10n.accountPaperDesc, 'icon': Icons.school, 'locked': false},
        {'id': 'real', 'title': l10n.accountReal, 'description': l10n.accountRealDesc, 'lockedDescription': l10n.accountRealLocked, 'icon': Icons.account_balance, 'locked': true},
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ProgressIndicatorWidget(
                currentStep: 6,
                totalSteps: 6,
              ),
              const SizedBox(height: 24),
              const AppIconTile(
                icon: Icons.speed_outlined,
                size: 64,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.chooseTradingMode,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.switchLaterSettings,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Expanded(
                child: ListView.separated(
                  itemCount: _modes(l10n).length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final mode = _modes(l10n)[index];
                    final isExpanded = expandedIndex == index;
                    final isLocked = mode['locked'] as bool;
                    return _AccountModeListTile(
                      value: mode['id'] as String,
                      title: mode['title'] as String,
                      description: isLocked
                          ? (mode['lockedDescription'] as String? ?? mode['description'] as String)
                          : mode['description'] as String,
                      icon: mode['icon'] as IconData,
                      groupValue: selectedMode,
                      isExpanded: isExpanded,
                      isLocked: isLocked,
                      onTap: isLocked
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Complete onboarding to unlock real trading',
                                  ),
                                ),
                              );
                            }
                          : () => setState(() => selectedMode = mode['id'] as String),
                      onExpandToggle: () =>
                          setState(() => expandedIndex = isExpanded ? null : index),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: selectedMode == null
                      ? null
                      : () async {
                          if (selectedMode != null) {
                            await ref
                                .read(onboardingTradingModeProvider.notifier)
                                .setTradingMode(selectedMode!);
                          }
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const OnboardingSuccessScreen(),
                            ),
                          );
                        },
                  style: TextButton.styleFrom(
                    backgroundColor: selectedMode != null
                        ? AppColors.primaryBlue.withOpacity(0.9)
                        : AppColors.textSecondary.withOpacity(0.3),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.next),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _AccountModeListTile extends StatelessWidget {
  final String value;
  final String title;
  final String description;
  final IconData icon;
  final String? groupValue;
  final bool isExpanded;
  final bool isLocked;
  final VoidCallback onTap;
  final VoidCallback onExpandToggle;

  const _AccountModeListTile({
    required this.value,
    required this.title,
    required this.description,
    required this.icon,
    required this.groupValue,
    required this.isExpanded,
    required this.isLocked,
    required this.onTap,
    required this.onExpandToggle,
  });

  static List<BoxShadow> get _cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 24,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 12,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = groupValue == value && !isLocked;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isLocked
                  ? AppColors.backgroundLight
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: _cardShadow,
              border: Border(
                left: BorderSide(
                  color: isSelected
                      ? AppColors.primaryBlue
                      : Colors.transparent,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppIconTile(
                  icon: isLocked ? Icons.lock : icon,
                  size: 40,
                  iconColor: isLocked
                      ? AppColors.textSecondary
                      : Colors.white,
                  backgroundColor: isLocked
                      ? AppColors.textSecondary.withOpacity(0.25)
                      : AppColors.iconTileBackground,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isLocked
                                    ? AppColors.textSecondary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onExpandToggle,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                isExpanded
                                    ? Icons.expand_less
                                    : Icons.expand_more,
                                size: 24,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                if (isLocked)
                  Icon(
                    Icons.lock_outline,
                    size: 24,
                    color: AppColors.textSecondary,
                  )
                else
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    size: 28,
                    color: isSelected
                        ? AppColors.primaryBlue
                        : Colors.grey.shade300,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
