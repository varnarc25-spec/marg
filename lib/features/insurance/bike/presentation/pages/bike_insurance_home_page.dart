import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bike_biller_provider.dart';
import '../providers/bike_accounts_provider.dart';
import '../providers/bike_vehicle_provider.dart';
import '../widgets/bike_home_find_plans_section.dart';
import '../widgets/bike_home_footer_link.dart';
import '../widgets/bike_home_payment_history_preview.dart';
import '../widgets/bike_home_payment_history_utils.dart';
import '../widgets/bike_home_saved_accounts_preview.dart';
import '../widgets/bike_home_steps_progress.dart';
import '../widgets/bike_home_testimonial_card.dart';
import '../widgets/bike_home_trusted_partners.dart';
import 'bike_insurance_help_page.dart';
import 'bike_insurance_payment_history_page.dart';
import 'bike_insurance_saved_accounts_page.dart';
import 'find_your_bike_page.dart';

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
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const FindYourBikePage()));
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
            'Choose from trusted insurers!',
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
              borderRadius: BorderRadius.circular(26),
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
                hintText: 'Enter your vehicle registration number',
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
          const SizedBox(height: 16),
          BikeHomeFindPlansSection(
            vehicleState: ref.watch(bikeVehicleProvider),
            onFindPlans: () {
              final number = _vehicleNumberController.text;
              ref.read(bikeVehicleNumberProvider.notifier).state = number;
              ref.read(bikeVehicleProvider.notifier).checkDetails(number);
            },
          ),
          Consumer(
            builder: (context, ref, _) {
              final async = ref.watch(
                bikePaymentHistoryProvider(
                  const BikePaymentHistoryQuery(limit: 50, offset: 0),
                ),
              );
              return async.when(
                data: (items) {
                  final paidItems =
                      items.where(bikeHomeIsPaidLikeHistoryStatus).toList();

                  if (paidItems.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  return BikeHomePaymentHistoryPreview(
                    items: paidItems.take(3).toList(),
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const BikeInsurancePaymentHistoryPage(),
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
                          bikePaymentHistoryProvider(
                            const BikePaymentHistoryQuery(limit: 50, offset: 0),
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
          const SizedBox(height: 20),
          Consumer(
            builder: (context, ref, _) {
              final async = ref.watch(bikeSavedAccountsProvider);
              final selectedId = ref.watch(selectedBikeSavedAccountIdProvider);

              return async.when(
                data: (accounts) {
                  if (accounts.isEmpty) return const SizedBox.shrink();
                  return BikeHomeSavedAccountsPreview(
                    accounts: accounts.take(3).toList(),
                    selectedId: selectedId,
                    onSelect: (id) =>
                        ref
                                .read(
                                  selectedBikeSavedAccountIdProvider.notifier,
                                )
                                .state =
                            id,
                    onViewAll: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const BikeInsuranceSavedAccountsPage(),
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
                        onPressed: () =>
                            ref.invalidate(bikeSavedAccountsProvider),
                        icon: const Icon(Icons.refresh_rounded, size: 20),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
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
                return BikeHomeTestimonialCard(
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
          Consumer(
            builder: (context, ref, _) {
              final async = ref.watch(bikeBillersProvider);
              return async.when(
                data: (billers) => BikeHomeTrustedPartnersFromApi(billers: billers),
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => BikeHomeTrustedPartnersLoadFailed(
                  message: e.toString().replaceFirst('Exception: ', ''),
                  onRetry: () => ref.invalidate(bikeBillersProvider),
                ),
              );
            },
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
          const BikeHomeStepsProgress(currentStep: 1),
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
              BikeHomeFooterLink(label: 'T&Cs', onTap: () {}),
              BikeHomeFooterLink(label: 'Privacy Policy', onTap: () {}),
              BikeHomeFooterLink(label: 'Grievance Policy', onTap: () {}),
              BikeHomeFooterLink(label: 'KYC Consent', onTap: () {}),
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
