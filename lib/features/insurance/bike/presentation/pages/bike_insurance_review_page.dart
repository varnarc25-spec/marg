import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/bike_insurance_plan.dart';
import '../../data/models/bike_vehicle_model.dart';
import '../../data/models/bike_saved_account_model.dart';
import '../providers/bike_biller_provider.dart';
import '../providers/bike_accounts_provider.dart';
import '../providers/bike_vehicle_provider.dart';
import '../../../../../shared/providers/app_providers.dart';
import 'bike_insurance_help_page.dart';
import 'bike_insurance_payment_success_page.dart';

/// Review selected plan and proceed to payment.
class BikeInsuranceReviewPage extends ConsumerStatefulWidget {
  const BikeInsuranceReviewPage({super.key});

  @override
  ConsumerState<BikeInsuranceReviewPage> createState() =>
      _BikeInsuranceReviewPageState();
}

class _BikeInsuranceReviewPageState extends ConsumerState<BikeInsuranceReviewPage> {
  bool _submitting = false;

  static String _paymentModeFromAccountType(String accountType) {
    final t = accountType.toLowerCase();
    if (t.contains('upi')) return 'UPI';
    if (t.contains('card') || t.contains('credit') || t.contains('debit')) {
      return 'CARD';
    }
    // Fallback. Backend may support other modes; keep a reasonable default.
    return 'UPI';
  }

  static String _formatDate(DateTime? d) {
    if (d == null) return '—';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final vehicleState = ref.watch(bikeVehicleProvider);
    final selectedPlan = ref.watch(selectedBikePlanProvider);

    if (selectedPlan == null || vehicleState is! BikeVehicleSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: Text(
            'Review and buy',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
          elevation: 0,
        ),
        body: Center(
          child: Text(
            'No plan selected. Go back and select a plan.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final vehicle = vehicleState.vehicle;
    final totalPrice =
        selectedPlan.price + 0; // Optional: add GST or other fees

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Review and buy',
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
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedPlan.insurerName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  if (selectedPlan.insurerCode != null &&
                      selectedPlan.insurerCode!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      selectedPlan.insurerCode!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '1 Year Comprehensive',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'IDV: ₹${_formatIdv(selectedPlan.idv)} • ₹${selectedPlan.price}/yr',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Bike Details',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _ReviewDetailRow(
                    label: 'Registration No.',
                    value: vehicle.registrationNumber,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Owner',
                    value: vehicle.ownerName,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Model',
                    value: vehicle.model,
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Registration Date',
                    value: _formatDate(vehicle.registrationDate),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  _ReviewDetailRow(
                    label: 'Insurance Expiry',
                    value: _formatDate(vehicle.insuranceExpiry),
                    textTheme: textTheme,
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'By clicking on \'Buy Plan\', I do hereby confirm that I have read and understood the Product Features/Benefits/Exclusions and agree to T&C and allow the insurer to fetch and process CKYC details for performing KYC. I hereby confirm that the details provided are correct and have a valid PUC certificate.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colorScheme.primary,
                ),
                child: Text(
                  'Product Features/Benefits/Exclusions',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              Text(
                ' and ',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: colorScheme.primary,
                ),
                child: Text(
                  'T&C',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '₹$totalPrice',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Inclusive of GST',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: _submitting
                      ? null
                      : () => _buyPlan(
                            vehicle: vehicle,
                            selectedPlan: selectedPlan,
                            totalPrice: totalPrice,
                          ),
                  child: _submitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('BUY PLAN'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _buyPlan({
    required BikeVehicleModel vehicle,
    required BikeInsurancePlan selectedPlan,
    required int totalPrice,
  }) async {
    setState(() => _submitting = true);
    try {
      final auth = ref.read(firebaseAuthServiceProvider);
      if (!auth.isLoggedIn()) {
        throw Exception('Please login again to continue');
      }
      final idToken = await auth.getIdToken();
      if (idToken == null || idToken.isEmpty) {
        throw Exception('Session expired. Please login again');
      }
      final accounts = await ref.read(bikeSavedAccountsProvider.future);
      if (accounts.isEmpty) {
        throw Exception('No saved payment accounts found.');
      }

      final selectedAccountId = ref.read(selectedBikeSavedAccountIdProvider);
      final BikeSavedAccount selectedAccount = selectedAccountId == null
          ? accounts.first
          : accounts.firstWhere(
              (a) => a.id == selectedAccountId,
              orElse: () => accounts.first,
            );

      final paymentMode = _paymentModeFromAccountType(selectedAccount.accountType);

      final api = ref.read(bikeInsuranceApiServiceProvider);
      final bill = await api.fetchBill(
        registrationNumber: vehicle.registrationNumber,
        insurerCode: selectedPlan.insurerCode ?? selectedPlan.insurerName,
        insurerId: selectedPlan.id,
        amount: totalPrice,
        idToken: idToken,
      );
      final payment = await api.pay(
        bill: bill,
        registrationNumber: vehicle.registrationNumber,
        insurerCode: selectedPlan.insurerCode ?? selectedPlan.insurerName,
        billerId: selectedPlan.id,
        consumerName: vehicle.ownerName,
        accountId: selectedAccount.id,
        paymentMode: paymentMode,
        idToken: idToken,
      );

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BikeInsurancePaymentSuccessPage(
            amountInRupees: payment.amount,
            transactionId: payment.transactionId,
            paymentDate: payment.paymentDate,
            status: payment.status,
            paymentMethod: payment.paymentMethod,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  static String _formatIdv(int idv) {
    if (idv >= 1000) {
      return '${idv ~/ 1000},${idv % 1000}';
    }
    return idv.toString();
  }
}

class _ReviewDetailRow extends StatelessWidget {
  const _ReviewDetailRow({
    required this.label,
    required this.value,
    required this.textTheme,
    required this.colorScheme,
  });

  final String label;
  final String value;
  final TextTheme textTheme;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          ),
        ),
      ],
    );
  }
}
