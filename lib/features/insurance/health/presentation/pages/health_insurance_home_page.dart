import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/features/insurance/health/data/health_insurance_plan.dart';

import '../providers/health_insurance_provider.dart';
import '../widgets/health_home_find_plans_section.dart';
import '../widgets/health_home_footer_link.dart';
import '../widgets/health_home_how_it_works_sheet.dart';
import '../widgets/health_home_member_chip.dart';
import '../widgets/health_home_member_utils.dart';
import '../widgets/health_home_phonepe_advantage.dart';
import '../widgets/health_home_steps_progress.dart';
import '../widgets/health_home_testimonial_card.dart';
import '../widgets/health_home_trusted_partners_grid.dart';
import 'health_insurance_details_page.dart';
import 'health_insurance_help_page.dart';

/// Health Insurance main page: Lowest Price Promise, family member selection, Find Plans.
/// Structure and styling aligned with screenshots; uses theme colorScheme.
class HealthInsuranceHomePage extends ConsumerStatefulWidget {
  const HealthInsuranceHomePage({super.key});

  @override
  ConsumerState<HealthInsuranceHomePage> createState() =>
      _HealthInsuranceHomePageState();
}

class _HealthInsuranceHomePageState extends ConsumerState<HealthInsuranceHomePage> {
  static const List<String> _memberKeys = [
    'Myself',
    'Spouse',
    'Children',
    'Parents',
  ];

  static const String _legalText = '''
PhonePe Insurance Broking Services Private Limited (IRDAI Reg. 766 - Direct Broker - Life and General) valid till 10/8/2027. CIN-U66000KA2020PTC132814.

Reg. office - Office-2, Floor 4, Wing A, Salarpuria Softzone, Bellandur, Bengaluru, Karnataka-560103.

Please read the sales brochure of the respective insurer carefully before concluding a sale. *The Discount available on the PhonePe platform may vary from insurer to insurer. ^₹224/month plan for a healthy individual of 18 years of age and a cover of 5 lakh. Insurance plans are scored by ILM Research. By proceeding, I consent to the policies below.
''';

  void _toggleMember(String key) {
    final current = List<String>.from(ref.read(healthSelectedMembersProvider));
    if (current.contains(key)) {
      if (key == 'Myself' && current.length == 1) return;
      current.remove(key);
    } else {
      current.add(key);
    }
    ref.read(healthSelectedMembersProvider.notifier).state = current;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final selectedMembers = ref.watch(healthSelectedMembersProvider);
    final homeAsync = ref.watch(healthHomeBootstrapProvider);
    final pricePromise = homeAsync.maybeWhen(
      data: (d) => d.pricePromise,
      orElse: () => null,
    );
    final partnerPlans = homeAsync.maybeWhen(
      data: (d) => d.partners,
      orElse: () => <HealthInsurancePlan>[],
    );

    final priceTitle = pricePromise?.title ?? 'Lowest Price Promise';
    final priceSubtitle = pricePromise?.subtitle ??
        'If you find a lower price, we pay the difference';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Health Insurance',
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
                  builder: (_) => const HealthInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 20),
          Text(
            priceTitle,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            priceSubtitle,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () => showHealthHowItWorksBottomSheet(
              context,
              pricePromise?.howItWorks ?? pricePromise?.disclaimer,
            ),
            child: Text(
              'Know how it works',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.25),
                  colorScheme.primary.withValues(alpha: 0.45),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(
                Icons.trending_down_rounded,
                size: 56,
                color: colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            'Insurance made simple!',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pick the family members you want to insure',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: _memberKeys.map((key) {
              final isSelected = selectedMembers.contains(key);
              final label = key == 'Parents' ? 'Parents/\nIn-laws' : key;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: HealthHomeMemberChip(
                    label: label,
                    icon: healthHomeMemberIcon(key),
                    isSelected: isSelected,
                    onTap: () => _toggleMember(key),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          HealthHomeFindPlansSection(
            enabled: selectedMembers.isNotEmpty,
            onFindPlans: () {
              if (selectedMembers.isEmpty) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const HealthInsuranceDetailsPage(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'OUR TRUSTED PARTNERS',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          HealthHomeTrustedPartnersGrid(
            colorScheme: colorScheme,
            textTheme: textTheme,
            partners: partnerPlans,
            isLoading: homeAsync.isLoading,
          ),
          const SizedBox(height: 24),
          Text(
            'Real Stories, Real Support',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Turning stressful claims into simple success stories',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final testimonial = index == 0
                    ? (
                        'PhonePe\'s team helped me till the end and resolved my health insurance claim in a day.',
                        'B Pratik Kumar',
                        colorScheme.secondary,
                      )
                    : (
                        'PhonePe really supported with my claim.',
                        'Anurag Janbandhu',
                        colorScheme.primary,
                      );
                return HealthHomeTestimonialCard(
                  quote: testimonial.$1,
                  author: testimonial.$2,
                  avatarColor: testimonial.$3,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          HealthHomePhonePeAdvantage(
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 24),
          Text(
            'Faster Insurance, Fewer Steps',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          HealthHomeStepsProgress(
            currentStep: 1,
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _legalText,
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: [
              HealthHomeFooterLink(label: 'T&Cs', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              HealthHomeFooterLink(label: 'Privacy Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              HealthHomeFooterLink(label: 'Grievance Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              HealthHomeFooterLink(label: 'KYC Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'By proceeding, I consent to the policies below.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
