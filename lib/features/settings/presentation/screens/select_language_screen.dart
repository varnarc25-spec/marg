import 'package:flutter/material.dart';

/// Screen 124: Select Language
const Color _langPurple = Color(0xFF6C63FF);

class _LanguageOption {
  final String name;
  final String flagEmoji;
  const _LanguageOption({required this.name, required this.flagEmoji});
}

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key});

  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  int _selectedIndex = 0;

  static const List<_LanguageOption> _languages = [
    _LanguageOption(name: 'English (USA)', flagEmoji: '🇺🇸'),
    _LanguageOption(name: 'English (UK)', flagEmoji: '🇬🇧'),
    _LanguageOption(name: 'Indonesia', flagEmoji: '🇮🇩'),
    _LanguageOption(name: 'Espanol', flagEmoji: '🇪🇸'),
    _LanguageOption(name: 'Francais', flagEmoji: '🇫🇷'),
    _LanguageOption(name: 'Italiano', flagEmoji: '🇮🇹'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() => _query = _searchController.text));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_LanguageOption> get _filtered {
    if (_query.isEmpty) return _languages;
    final q = _query.toLowerCase();
    return _languages.where((l) => l.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Language'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search language',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    size: 22,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = filtered[index];
                  final originalIndex = _languages.indexWhere((l) => l.name == option.name);
                  return _LanguageCard(
                    option: option,
                    value: originalIndex,
                    groupValue: _selectedIndex,
                    onTap: () => setState(() => _selectedIndex = originalIndex),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: _langPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Change Language'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final _LanguageOption option;
  final int value;
  final int groupValue;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.option,
    required this.value,
    required this.groupValue,
    required this.onTap,
  });

  bool get selected => groupValue == value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? _langPurple
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.12),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(option.flagEmoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  option.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ),
              Radio<int>(
                value: value,
                groupValue: groupValue,
                onChanged: (_) => onTap(),
                activeColor: _langPurple,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
