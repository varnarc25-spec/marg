import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/car_vehicle_provider.dart';
import '../providers/car_accounts_provider.dart';
import '../providers/car_payment_history_provider.dart';
import 'car_insurance_saved_accounts_page.dart';
import '../widgets/car_home_find_plans_section.dart';
import '../widgets/car_home_footer_link.dart';
import '../widgets/car_home_payment_history_preview.dart';
import '../widgets/car_home_payment_history_utils.dart';
import '../widgets/car_home_saved_accounts_preview.dart';
import '../widgets/car_home_steps_progress.dart';
import '../widgets/car_home_testimonial_card.dart';
import '../widgets/car_home_trusted_partners_grid.dart';
import 'find_your_car_page.dart';
import 'car_insurance_help_page.dart';
import 'car_insurance_payment_history_page.dart';

/// Car Insurance main page: vehicle input, Find Plans. On success navigates to Select Plan page.
/// Same structure and widget style as bike insurance; uses theme colorScheme throughout.
class CarInsuranceHomePage extends ConsumerStatefulWidget {
  const CarInsuranceHomePage({super.key});

  @override
  ConsumerState<CarInsuranceHomePage> createState() =>
      _CarInsuranceHomePageState();
}

class _CarInsuranceHomePageState extends ConsumerState<CarInsuranceHomePage> {
  final _vehicleNumberController = TextEditingController();

  static const String _legalText = '''
PhonePe Insurance Broking Services Private Limited. IRDAI Direct Broker (Life & General) Reg. 766 and Broker Registration Code IRDA/DB 822/20 Valid till 10/08/2027.

Reg. Address - Office-2, Floor 4,5,6,7, Wing A, Block A, Salarpuria Softzone, Service Road, Green Glen Layout, Bellandur, Bengaluru, Karnataka-KA Pin- 560103. All savings are provided by insurers as per IRDAI approved insurance plans. *Third-party covers premium for less than 1000CC cars. Premium is payable on an annual basis. ^Under S. 146/196 of the Motor Vehicle Act. **Upto 91% discount is offered on the Own damage premium only, for select Comprehensive insurance plans by select Insurers. Prices displayed on the quote page are after applying the discount. CIN: U66000KA2020PTC132814.
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

    ref.listen<CarVehicleState>(carVehicleProvider, (prev, next) {
      if (next is CarVehicleSuccess && mounted) {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FindYourCarPage()));
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
          'Car Insurance',
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
                MaterialPageRoute(builder: (_) => const CarInsuranceHelpPage()),
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
            'Season Sale: Up to 20% off',
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
          Text(
            'Enter car number',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Compare plans from multiple insurers',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(24),
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
          CarHomeFindPlansSection(
            vehicleState: ref.watch(carVehicleProvider),
            onFindPlans: () {
              final number = _vehicleNumberController.text;
              ref.read(carVehicleNumberProvider.notifier).state = number;
              ref.read(carVehicleProvider.notifier).checkDetails(number);
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
          Consumer(
            builder: (context, ref, _) {
              final async = ref.watch(
                carPaymentHistoryProvider(
                  const CarPaymentHistoryQuery(limit: 50, offset: 0),
                ),
              );

              return async.when(
                data: (items) {
                  final paidItems =
                      items.where(carHomeIsPaidLikeHistoryStatus).toList();

                  if (paidItems.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return CarHomePaymentHistoryPreview(
                    items: paidItems.take(3).toList(),
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CarInsurancePaymentHistoryPage(),
                        ),
                      );
                    },
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, __) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Could not load payment history.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (e.toString().isNotEmpty)
                        Text(
                          e.toString().replaceFirst('Exception: ', ''),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(
                          carPaymentHistoryProvider(
                            const CarPaymentHistoryQuery(limit: 50, offset: 0),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final async = ref.watch(carSavedAccountsProvider);
              final selectedId = ref.watch(selectedCarSavedAccountIdProvider);

              return async.when(
                data: (accounts) {
                  if (accounts.isEmpty) return const SizedBox.shrink();
                  return CarHomeSavedAccountsPreview(
                    accounts: accounts.take(3).toList(),
                    selectedId: selectedId,
                    onSelect: (id) => ref
                        .read(selectedCarSavedAccountIdProvider.notifier)
                        .state = id,
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CarInsuranceSavedAccountsPage(),
                        ),
                      );
                    },
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (e, __) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Could not load saved accounts.',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.error,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (e.toString().isNotEmpty)
                        Text(
                          e.toString().replaceFirst('Exception: ', ''),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => ref.invalidate(carSavedAccountsProvider),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            },
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
                          'Buying a brand new car?',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Save up to ₹40,000',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: colorScheme.primary,
                          ),
                          child: Text(
                            'Insure Now',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.directions_car_rounded,
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
                return CarHomeTestimonialCard(
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
          const CarHomeTrustedPartnersGrid(),
          const SizedBox(height: 24),
          Text(
            'Faster Insurance, Fewer Steps',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          const CarHomeStepsProgress(currentStep: 1),
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
              CarHomeFooterLink(label: 'T&Cs', onTap: () {}),
              CarHomeFooterLink(label: 'Privacy Policy', onTap: () {}),
              CarHomeFooterLink(label: 'Grievance Policy', onTap: () {}),
              CarHomeFooterLink(label: 'KYC Consent', onTap: () {}),
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
