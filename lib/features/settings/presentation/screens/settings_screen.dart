import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';

/// Settings Screen
/// App settings including language, theme, and onboarding reset
/// Enhanced with better UI/UX and inline language selection
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _showLanguageOptions = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = ref.watch(themeModeProvider);
    final language = ref.watch(languageProvider);
    final l10n = ref.watch(l10nProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Preferences Section
          _SettingsSection(
            title: l10n.settingsSectionPreferences,
            icon: Icons.tune,
            children: [
              // Language Selection with Inline Options
              _LanguageSelectorTile(
                l10n: l10n,
                currentLanguage: language,
                showOptions: _showLanguageOptions,
                onToggle: () {
                  setState(() {
                    _showLanguageOptions = !_showLanguageOptions;
                  });
                },
                onLanguageSelected: (langCode) {
                  ref.read(languageProvider.notifier).setLanguage(langCode);
                  setState(() {
                    _showLanguageOptions = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.languageChangedTo.replaceAll('%s', l10n.languageDisplayName(langCode))),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              if (_showLanguageOptions) ...[
                const SizedBox(height: 8),
                _LanguageOptionsList(
                  l10n: l10n,
                  currentLanguage: language,
                  onLanguageSelected: (langCode) {
                    ref.read(languageProvider.notifier).setLanguage(langCode);
                    setState(() {
                      _showLanguageOptions = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.languageChangedTo.replaceAll('%s', l10n.languageDisplayName(langCode))),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
              const Divider(height: 32),
              // Theme Toggle with Enhanced UI
              _ThemeToggleTile(
                l10n: l10n,
                isDarkMode: isDarkMode,
                onToggle: () {
                  ref.read(themeModeProvider.notifier).toggleTheme();
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Account Section
          _SettingsSection(
            title: l10n.settingsSectionAccount,
            icon: Icons.account_circle,
            children: [
              _SettingsTile(
                leading: const Icon(Icons.refresh, color: AppColors.primaryBlue),
                title: l10n.settingsResetOnboarding,
                subtitle: l10n.settingsResetSubtitle,
                onTap: () {
                  _showResetOnboardingDialog(context, ref, l10n);
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          // About Section
          _SettingsSection(
            title: l10n.settingsSectionAbout,
            icon: Icons.info_outline,
            children: [
              _SettingsTile(
                leading: const Icon(Icons.info, color: AppColors.primaryBlue),
                title: l10n.settingsAppInfo,
                subtitle: l10n.settingsVersionSubtitle,
                onTap: () {
                  _showAppInfoDialog(context, l10n);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showResetOnboardingDialog(BuildContext context, WidgetRef ref, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.resetOnboardingTitle),
        content: Text(l10n.resetOnboardingMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(onboardingCompleteProvider.notifier).resetOnboarding();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.onboardingResetDone)),
              );
            },
            child: Text(l10n.reset),
          ),
        ],
      ),
    );
  }

  void _showAppInfoDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.appInfoTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appName),
            const SizedBox(height: 8),
            Text(l10n.settingsVersionSubtitle),
            const SizedBox(height: 8),
            Text(l10n.appInfoDescription),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Language Selector Tile with Expandable Options
class _LanguageSelectorTile extends StatelessWidget {
  final AppLocalizations l10n;
  final String currentLanguage;
  final bool showOptions;
  final VoidCallback onToggle;
  final Function(String) onLanguageSelected;

  const _LanguageSelectorTile({
    required this.l10n,
    required this.currentLanguage,
    required this.showOptions,
    required this.onToggle,
    required this.onLanguageSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(
          Icons.language,
          color: AppColors.primaryBlue,
          size: 20,
        ),
      ),
      title: Text(
        l10n.settingsLanguage,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        l10n.languageDisplayName(currentLanguage),
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: Icon(
        showOptions ? Icons.expand_less : Icons.expand_more,
        color: AppColors.primaryBlue,
      ),
      onTap: onToggle,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

/// Language Options List
class _LanguageOptionsList extends StatelessWidget {
  final AppLocalizations l10n;
  final String currentLanguage;
  final Function(String) onLanguageSelected;

  const _LanguageOptionsList({
    required this.l10n,
    required this.currentLanguage,
    required this.onLanguageSelected,
  });

  static const List<Map<String, String>> _languageCodes = [
    {'code': 'en', 'flag': '\u{1F1EC}\u{1F1E7}'},
    {'code': 'hi', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'te', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'ta', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'kn', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'mr', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'gu', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'pa', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'ml', 'flag': '\u{1F1EE}\u{1F1F3}'},
    {'code': 'bn', 'flag': '\u{1F1EE}\u{1F1F3}'},
  ];

  @override
  Widget build(BuildContext context) {
    final languages = _languageCodes
        .map((e) => {
              'code': e['code']!,
              'name': l10n.languageDisplayName(e['code']!),
              'flag': e['flag']!,
            })
        .toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: languages.map((lang) {
          final isSelected = lang['code'] == currentLanguage;
          return InkWell(
            onTap: () => onLanguageSelected(lang['code'] as String),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryBlue.withValues(alpha: 0.1)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Text(
                    lang['flag'] as String,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      lang['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : null,
                          ),
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Enhanced Theme Toggle Tile
class _ThemeToggleTile extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDarkMode;
  final VoidCallback onToggle;

  const _ThemeToggleTile({
    required this.l10n,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [
                  AppColors.backgroundDark,
                  AppColors.surfaceDark,
                ]
              : [
                  AppColors.primaryBlue.withValues(alpha: 0.1),
                  AppColors.primaryBlueLight.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode
              ? AppColors.textSecondaryDark.withValues(alpha: 0.3)
              : AppColors.primaryBlue.withValues(alpha: 0.3),
        ),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
                color: isDarkMode
                ? AppColors.primaryBlueLight.withValues(alpha: 0.2)
                : AppColors.primaryBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: isDarkMode
                ? AppColors.primaryBlueLight
                : AppColors.primaryBlue,
            size: 20,
          ),
        ),
        title: Text(
          l10n.settingsDarkMode,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        subtitle: Text(
          isDarkMode ? l10n.settingsDarkThemeEnabled : l10n.settingsLightThemeEnabled,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Switch(
          value: isDarkMode,
          onChanged: (_) => onToggle(),
          activeThumbColor: AppColors.primaryBlue,
          activeTrackColor: AppColors.primaryBlueLight,
        ),
        onTap: onToggle,
      ),
    );
  }
}
