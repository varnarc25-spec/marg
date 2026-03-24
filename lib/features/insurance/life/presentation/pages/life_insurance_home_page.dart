import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/life_insurance_provider.dart';
import '../widgets/life_home_benefits.dart';
import '../widgets/life_home_feature_card.dart';
import '../widgets/life_home_footer_link.dart';
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
    final bootstrap = ref.watch(lifeHomeBootstrapProvider);

    final partnerLabel = bootstrap.maybeWhen(
      data: (b) =>
          b.partners.isEmpty ? '8+ Top Insurers' : '${b.partners.length}+ Top Insurers',
      orElse: () => '8+ Top Insurers',
    );

    ref.listen<LifeCoverState>(lifeCoverProvider, (prev, next) {
      if (!mounted) return;
      if (next is LifeCoverSuccess) {
        ref.read(lifeSelectedSumAssuredLakhsProvider.notifier).state =
            next.result.recommendedCoverLakhs;
        final till = next.result.defaultCoverTillAge;
        if (till != null && lifeCoverTillAgeOptions.contains(till)) {
          ref.read(lifeCoverTillAgeProvider.notifier).state = till;
        }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LifeInsuranceCoverPage()),
        );
      } else if (next is LifeCoverError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
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
            bootstrap.maybeWhen(
              data: (b) => b.promos.isNotEmpty && (b.promos.first.title?.isNotEmpty ?? false)
                  ? b.promos.first.title!
                  : 'GST on Life Insurance drops to 0%',
              orElse: () => 'GST on Life Insurance drops to 0%',
            ),
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          if (bootstrap.maybeWhen(
            data: (b) =>
                b.promos.isNotEmpty && (b.promos.first.subtitle?.isNotEmpty ?? false),
            orElse: () => false,
          )) ...[
            const SizedBox(height: 8),
            Text(
              bootstrap.maybeWhen(
                data: (b) => b.promos.first.subtitle ?? '',
                orElse: () => '',
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
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
                child: LifeHomeFeatureCard(
                  icon: Icons.savings_rounded,
                  label: partnerLabel,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LifeHomeFeatureCard(
                  icon: Icons.person_rounded,
                  label: 'Relationship manager',
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LifeHomeFeatureCard(
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
                              switch (income) {
                                case final int i when i > 0:
                                  ref
                                      .read(lifeCoverProvider.notifier)
                                      .calculateCover(
                                        dateOfBirth: _selectedDob!,
                                        annualIncome: i,
                                      );
                                default:
                                  break;
                              }
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
          bootstrap.when(
            data: (b) => b.benefits.isEmpty
                ? LifeHomeBenefitsGrid(colorScheme: colorScheme, textTheme: textTheme)
                : LifeHomeBenefitsFromApi(
                    items: b.benefits,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
            loading: () =>
                LifeHomeBenefitsGrid(colorScheme: colorScheme, textTheme: textTheme),
            error: (_, __) =>
                LifeHomeBenefitsGrid(colorScheme: colorScheme, textTheme: textTheme),
          ),
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
              LifeHomeFooterLink(
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
              LifeHomeFooterLink(
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
              LifeHomeFooterLink(
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
