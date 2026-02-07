import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../data/datasources/languages_asset_datasource.dart';
import '../../data/models/language_option.dart';
import 'user_goal_selection_screen.dart';

/// Language Selection Screen
/// Grid of pastel language buttons with native script and English name; green checkmark for selected.
/// Languages are loaded from onboarding/data (assets/onboarding/data/languages.json).
class LanguageSelectionScreen extends ConsumerStatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  ConsumerState<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends ConsumerState<LanguageSelectionScreen> {
  List<LanguageOption> _options = [];
  bool _loading = true;
  String _selectedCode = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    try {
      final options = await LanguagesAssetDatasource.loadLanguages();
      if (mounted) {
        setState(() {
          _options = options;
          _loading = false;
        });
        _syncSelectedFromProvider();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  void _syncSelectedFromProvider() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final current = ref.read(languageProvider);
        if (current.isNotEmpty && _options.any((o) => o.code == current)) {
          setState(() => _selectedCode = current);
        }
      } catch (_) {}
    });
  }

  void _onLanguageSelected(String code) {
    setState(() => _selectedCode = code);
    ref.read(languageProvider.notifier).setLanguage(code);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const UserGoalSelectionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.watch(l10nProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Text(
                l10n.selectLanguage,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.changeLanguageLater,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView(
                        padding: const EdgeInsets.only(bottom: 24),
                        children: [
                          for (var i = 0; i < _options.length; i += 2) ...[
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: 7,
                                        bottom: i + 2 < _options.length ? 14 : 0,
                                      ),
                                      child: LanguageGridTile(
                                        option: _options[i],
                                        selected: _selectedCode == _options[i].code,
                                        onTap: () => _onLanguageSelected(_options[i].code),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        left: 7,
                                        bottom: i + 2 < _options.length ? 14 : 0,
                                      ),
                                      child: i + 1 < _options.length
                                          ? LanguageGridTile(
                                              option: _options[i + 1],
                                              selected: _selectedCode == _options[i + 1].code,
                                              onTap: () => _onLanguageSelected(_options[i + 1].code),
                                            )
                                          : const SizedBox.shrink(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LanguageGridTile extends StatelessWidget {
  final LanguageOption option;
  final bool selected;
  final VoidCallback onTap;

  const LanguageGridTile({
    super.key,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: option.color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    option.nativeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    option.englishName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (selected)
              Positioned(
                top: 10,
                right: 10,
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.accentGreen,
                  size: 26,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
