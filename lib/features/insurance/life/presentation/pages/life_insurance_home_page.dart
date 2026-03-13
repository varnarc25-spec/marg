import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/life_insurance_provider.dart';
import 'life_insurance_cover_page.dart';
import 'life_insurance_help_page.dart';

/// Term Life Insurance home: GST banner, calculate cover (DOB, income), benefits, footer.
/// Same structure as car/bike/health; uses theme colorScheme.
class LifeInsuranceHomePage extends ConsumerStatefulWidget {
  const LifeInsuranceHomePage({super.key});

  @override
  ConsumerState<LifeInsuranceHomePage> createState() =>
      _LifeInsuranceHomePageState();
}

class _LifeInsuranceHomePageState extends ConsumerState<LifeInsuranceHomePage> {
  final _incomeController = TextEditingController();
  DateTime? _selectedDob;

  static const String _legalText = '''
By proceeding, you agree to our Terms and Conditions, Privacy Policy & Grievance Policy Apply.

PhonePe Insurance Broking Services Private Limited. IRDAI Direct Broker (Life & General) Reg. 766. Valid till 10/08/2027. Reg. office - Bengaluru, Karnataka.

Premiums presented are for an 18-year-old healthy non-smoker male for a Sum Assured of ₹1 Cr and cover till the age of 50 years. Discounts provided by select insurers on select plans. GST exemption is subject to fulfilment of conditions. Income documents are not required at the proposal stage. Policy is subject to acceptance by the respective insurer. CIN: U66000KA2020PTC132814.
''';

  @override
  void initState() {
    super.initState();
    _selectedDob = ref.read(lifeDateOfBirthProvider);
    _incomeController.text = ref.read(lifeAnnualIncomeProvider);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  int? _parseIncome(String text) {
    final cleaned = text.replaceAll(RegExp(r'[,\s]'), '');
    if (cleaned.isEmpty) return null;
    return int.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final coverState = ref.watch(lifeCoverProvider);
    final advisoryConsent = ref.watch(lifeAdvisoryConsentProvider);

    ref.listen<LifeCoverState>(lifeCoverProvider, (prev, next) {
      if (next is LifeCoverSuccess && mounted) {
        ref.read(lifeSelectedSumAssuredLakhsProvider.notifier).state =
            next.result.recommendedCoverLakhs;
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LifeInsuranceCoverPage()),
        );
      }
    });

    final dob = ref.watch(lifeDateOfBirthProvider);
    _selectedDob ??= dob;

    final incomeStr = _incomeController.text;
    final income = _parseIncome(incomeStr);
    final canCheck = _selectedDob != null && income != null && income > 0;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Life Insurance',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.help_outline_rounded,
              size: 24,
              color: colorScheme.onSurface,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const LifeInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 12),
          Text(
            'TERM LIFE INSURANCE',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'GST on Life Insurance drops to 0%',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.2),
                  colorScheme.secondary.withValues(alpha: 0.25),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.percent_rounded,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '0%',
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  icon: Icons.savings_rounded,
                  label: '8+ Top Insurers',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeatureCard(
                  icon: Icons.person_rounded,
                  label: 'Relationship manager',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeatureCard(
                  icon: Icons.discount_rounded,
                  label: 'Upto 10% discount',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Calculate your cover amount',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Enter details to calculate your sum assured',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Date of Birth',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDob ?? DateTime(1990, 1, 1),
                        firstDate: DateTime(1920),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && mounted) {
                        setState(() => _selectedDob = picked);
                        ref.read(lifeDateOfBirthProvider.notifier).state =
                            picked;
                      }
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.5,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.outline.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDob != null
                                  ? '${_selectedDob!.day.toString().padLeft(2, '0')}/${_selectedDob!.month.toString().padLeft(2, '0')}/${_selectedDob!.year}'
                                  : 'DD/MM/YYYY',
                              style: textTheme.bodyLarge?.copyWith(
                                color: _selectedDob != null
                                    ? colorScheme.onSurface
                                    : colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Annual Income',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: TextField(
                      controller: _incomeController,
                      keyboardType: TextInputType.number,
                      onChanged: (v) {
                        ref.read(lifeAnnualIncomeProvider.notifier).state = v;
                      },
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Eg: 10,00,000',
                        hintStyle: textTheme.bodyLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            '₹',
                            style: textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This will help us calculate your cover amount',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: canCheck && coverState is! LifeCoverLoading
                          ? () {
                              if (_selectedDob == null ||
                                  income == null ||
                                  income <= 0)
                                return;
                              ref
                                  .read(lifeCoverProvider.notifier)
                                  .calculateCover(
                                    dateOfBirth: _selectedDob!,
                                    annualIncome: income,
                                  );
                            }
                          : null,
                      style: FilledButton.styleFrom(
                        backgroundColor: canCheck
                            ? colorScheme.primary
                            : colorScheme.surfaceContainerHighest,
                        foregroundColor: canCheck
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                      child: coverState is LifeCoverLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('CHECK NOW'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Get personalised support from expert advisors',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: () {
              ref.read(lifeAdvisoryConsentProvider.notifier).state = !ref.read(
                lifeAdvisoryConsentProvider,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: advisoryConsent
                        ? colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: advisoryConsent
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: advisoryConsent
                      ? Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: colorScheme.onPrimary,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "I would like to receive a call from PhonePe's expert advisors to help me with this purchase.",
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Why buy term life insurance from us?',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Benefits of buying term life from us',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          _BenefitsGrid(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 24),
          Text(
            _legalText,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FooterLink(
                label: 'Terms and Conditions',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              Text(
                ' ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              _FooterLink(
                label: 'Privacy Policy',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
              Text(
                ' ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              _FooterLink(
                label: 'Grievance Policy',
                onTap: () {},
                colorScheme: colorScheme,
                textTheme: textTheme,
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.colorScheme,
    required this.textTheme,
  });

  final IconData icon;
  final String label;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: colorScheme.primary),
            const SizedBox(height: 8),
            Text(
              label,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

class _BenefitsGrid extends StatelessWidget {
  const _BenefitsGrid({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const List<MapEntry<String, IconData>> _items = [
    MapEntry('Pre-approved Offers', Icons.verified_user_rounded),
    MapEntry('Zero Cost Insurance', Icons.money_off_rounded),
    MapEntry('Upto 10% discount', Icons.discount_rounded),
    MapEntry('Relationship Manager', Icons.support_agent_rounded),
    MapEntry('Claims Support', Icons.shield_rounded),
    MapEntry('Customizable Payment Options', Icons.payment_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.95,
      children: _items.map((e) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(e.value, size: 28, color: colorScheme.primary),
                const SizedBox(height: 8),
                Text(
                  e.key,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({
    required this.label,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 0),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label,
        style: textTheme.bodySmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
