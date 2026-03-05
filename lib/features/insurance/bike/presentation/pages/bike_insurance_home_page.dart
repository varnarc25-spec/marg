import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/bike_vehicle_provider.dart';
import 'find_your_bike_page.dart';
import 'bike_insurance_help_page.dart';

/// Bike Insurance main page: vehicle input, Find Plans. On success navigates to Select Plan page.
class BikeInsuranceHomePage extends ConsumerStatefulWidget {
  const BikeInsuranceHomePage({super.key});

  @override
  ConsumerState<BikeInsuranceHomePage> createState() =>
      _BikeInsuranceHomePageState();
}

class _BikeInsuranceHomePageState extends ConsumerState<BikeInsuranceHomePage> {
  final _vehicleNumberController = TextEditingController();

  static const String _legalText = '''
PhonePe Insurance Broking Services Private Limited. IRDAI Direct Broker (Life & General) Reg. 766 and Broker Registration Code IRDA/DB 822/20 Valid till 10/08/2027. CIN-U66000KA2020PTC132814.

The mentioned starting price of ₹538/yr is exclusive of taxes and applicable to less than 75CC two wheeler vehicle's owners seeking Third party only insurance cover.

Upto 95% discount is offered on the Own damage premium only. Estimated savings of Rs. 4,000 is based on the highest and lowest premium quoted. Under S. 146/196 of the Motor Vehicle Act.

Lowest price on PhonePe platform. By proceeding, I consent to the terms and conditions.
''';

  @override
  void dispose() {
    _vehicleNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    ref.listen<BikeVehicleState>(bikeVehicleProvider, (prev, next) {
      if (next is BikeVehicleSuccess && mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => const FindYourBikePage(),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Bike Insurance',
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
                  builder: (_) => const BikeInsuranceHelpPage(),
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
            'Compare & save up to 95%*',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 8),
          Text(
            'Choose from 20+ Insurers!',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Get Expert Help with Claims',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: _vehicleNumberController,
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurface,
              ),
              decoration: InputDecoration(
                hintText: 'Eg. KA01KA1234',
                hintStyle: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          _FindPlansSection(
            vehicleState: ref.watch(bikeVehicleProvider),
            onFindPlans: () {
              final number = _vehicleNumberController.text;
              ref.read(bikeVehicleNumberProvider.notifier).state = number;
              ref.read(bikeVehicleProvider.notifier).checkDetails(number);
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '1.2 Cr+ vehicles insured on PhonePe',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buying a brand new bike?',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save up to 95%',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Compare plans from multiple insurers',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.two_wheeler_rounded,
                    size: 56,
                    color: colorScheme.primary.withValues(alpha: 0.6),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '1 Cr+ Indians chose us',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Hear what our customers have to say',
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
                        'PhonePe\'s claim process was excellent. I\'ve already renewed for next year. I will insure my other vehicles here too!',
                        'Shahjahan',
                        colorScheme.secondary,
                      )
                    : (
                        'Great experience with quick policy issuance. Would recommend to everyone.',
                        'Rajkumar',
                        colorScheme.primary,
                      );
                return _TestimonialCard(
                  quote: testimonial.$1,
                  author: testimonial.$2,
                  avatarColor: testimonial.$3,
                );
              },
            ),
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
          _TrustedPartnersGrid(),
          const SizedBox(height: 24),
          Text(
            'Faster Insurance, Fewer Steps',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _StepsProgress(currentStep: 1),
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
              _FooterLink(label: 'T&Cs', onTap: () {}),
              _FooterLink(label: 'Privacy Policy', onTap: () {}),
              _FooterLink(label: 'Grievance Policy', onTap: () {}),
              _FooterLink(label: 'KYC Consent', onTap: () {}),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'By proceeding, you allow us to call you to provide insurance assistance',
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

class _FindPlansSection extends StatelessWidget {
  const _FindPlansSection({
    required this.vehicleState,
    required this.onFindPlans,
  });

  final BikeVehicleState vehicleState;
  final VoidCallback onFindPlans;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: vehicleState is BikeVehicleLoading ? null : onFindPlans,
            child: const Text('Find Plans'),
          ),
        ),
        if (vehicleState is BikeVehicleLoading) ...[
          const SizedBox(height: 16),
          const Center(child: CircularProgressIndicator()),
        ],
        if (vehicleState is BikeVehicleError) ...[
          const SizedBox(height: 12),
          Text(
            (vehicleState as BikeVehicleError).message,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.error,
            ),
          ),
        ],
      ],
    );
  }
}

class _TestimonialCard extends StatelessWidget {
  final String quote;
  final String author;
  final Color avatarColor;

  const _TestimonialCard({
    required this.quote,
    required this.author,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final initial = author.isNotEmpty ? author[0].toUpperCase() : '?';

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
                    borderRadius: BorderRadius.circular(12),
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
  final List<String> _partners = [
    'ACKO',
    'Bajaj General',
    'Generali',
    'The New India Assurance',
    'Oriental Insurance',
    'IndusInd General',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

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

  const _StepsProgress({required this.currentStep});

  static const _stepLabels = [
    'Choose plan',
    'Submit details',
    'Complete KYC',
    'Get your policy',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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

  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
