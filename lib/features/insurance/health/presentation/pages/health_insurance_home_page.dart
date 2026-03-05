import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/health_insurance_provider.dart';
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
          // Lowest Price Promise
          Text(
            'Lowest Price Promise',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'If you find a lower price, we pay the difference',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: () {},
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
          // Insurance made simple
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
                  child: _MemberChip(
                    label: label,
                    icon: _memberIcon(key),
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
          _FindPlansSection(
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
          _TrustedPartnersGrid(colorScheme: colorScheme, textTheme: textTheme),
          const SizedBox(height: 24),
          // Real Stories, Real Support
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
                return _TestimonialCard(
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
          // THE PHONEPE ADVANTAGE (beige section)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE PHONEPE ADVANTAGE',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(7, (i) => Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colorScheme.primary.withValues(alpha: 0.2),
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    )),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Expert Advisors',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Our advisors help you pick the right plan and save more.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Lowest Premium',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '30+ plans. Incredible deals. Easy monthly payments.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Relationship Manager',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your 24/7 RM handles everything from queries to claims',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
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
          _StepsProgress(currentStep: 1, colorScheme: colorScheme, textTheme: textTheme),
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
              _FooterLink(label: 'T&Cs', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              _FooterLink(label: 'Privacy Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              _FooterLink(label: 'Grievance Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
              _FooterLink(label: 'KYC Policy', onTap: () {}, colorScheme: colorScheme, textTheme: textTheme),
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

  IconData _memberIcon(String key) {
    switch (key) {
      case 'Myself':
        return Icons.person_rounded;
      case 'Spouse':
        return Icons.favorite_rounded;
      case 'Children':
        return Icons.child_care_rounded;
      case 'Parents':
        return Icons.elderly_rounded;
      default:
        return Icons.person_rounded;
    }
  }
}

class _MemberChip extends StatelessWidget {
  const _MemberChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                  border: Border.all(
                    color: isSelected ? colorScheme.primary : colorScheme.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(icon, size: 28, color: colorScheme.onSurface),
              ),
              if (isSelected)
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: colorScheme.surface, width: 1),
                  ),
                  child: Icon(Icons.check_rounded, size: 14, color: colorScheme.onPrimary),
                ),
            ],
          ),
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
    );
  }
}

class _FindPlansSection extends StatelessWidget {
  const _FindPlansSection({
    required this.onFindPlans,
    this.enabled = true,
  });

  final VoidCallback onFindPlans;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: enabled ? onFindPlans : null,
            child: const Text('Find Plans'),
          ),
        ),
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final Color avatarColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    required this.avatarColor,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    final parts = author.split(' ').where((e) => e.isNotEmpty).take(2);
    final initial = parts.isEmpty ? '?' : parts.map((e) => e[0].toUpperCase()).join();

    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.surface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  Icons.format_quote_rounded,
                  size: 24,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              quote,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              author,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TrustedPartnersGrid extends StatelessWidget {
  const _TrustedPartnersGrid({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  static const List<String> _partners = [
    'Aditya Birla Health',
    'Bajaj Allianz',
    'Digit',
    'ICICI Lombard',
    'Reliance General',
    'Star Health',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: _partners.map((name) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: Text(
                name,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StepsProgress extends StatelessWidget {
  final int currentStep;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _StepsProgress({
    required this.currentStep,
    required this.colorScheme,
    required this.textTheme,
  });

  static const _stepLabels = [
    'Choose policy plan',
    'Submit details',
    'Complete KYC',
    'Get your policy',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (index) {
        final isActive = index + 1 <= currentStep;
        final isLast = index == 3;
        return Expanded(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isActive
                              ? colorScheme.onPrimary
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _stepLabels[index],
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 28),
                    color: colorScheme.surfaceContainerHighest,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _FooterLink({
    required this.label,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

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
        style: textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
