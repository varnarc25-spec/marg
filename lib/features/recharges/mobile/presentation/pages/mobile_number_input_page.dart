import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../../../../../../shared/providers/app_providers.dart';
import '../providers/mobile_recharge_provider.dart';
import '../utils/mobile_recharge_phone_utils.dart';
import '../widgets/family_numbers_section.dart';
import 'mobile_plan_list_page.dart';

/// Number / account input for mobile recharge.
class MobileNumberInputPage extends ConsumerStatefulWidget {
  const MobileNumberInputPage({super.key});

  @override
  ConsumerState<MobileNumberInputPage> createState() => _MobileNumberInputPageState();
}

class _MobileNumberInputPageState extends ConsumerState<MobileNumberInputPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _prefilled = false;
  String? _lastDetectOperatorDigits;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onNumberChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prefilled || !mounted) return;
      final number = ref.read(mobileRechargeNumberProvider);
      if (number.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = number;
        _prefilled = true;
      }
    });
  }

  void _onNumberChanged() {
    final ten = tenDigitMobileFromInput(_controller.text);
    if (ten == null) {
      _lastDetectOperatorDigits = null;
      return;
    }
    if (ten == _lastDetectOperatorDigits) return;
    _lastDetectOperatorDigits = ten;
    _fetchDetectOperator(ten);
  }

  Future<void> _fetchDetectOperator(String tenDigits) async {
    final auth = ref.read(firebaseAuthServiceProvider);
    final token = await auth.getIdToken();
    if (token == null || token.isEmpty) {
      debugPrint('detect-operator: skipped (not signed in)');
      return;
    }
    final api = ref.read(margApiServiceProvider);
    try {
      final json = await api.detectMobileOperator(
        idToken: token,
        mobileNumber: tenDigits,
      );
      debugPrint('detect-operator: $json');
    } catch (e, st) {
      debugPrint('detect-operator error: $e\n$st');
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onNumberChanged);
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _proceed() {
    final number = _controller.text.trim().replaceAll(RegExp(r'\D'), '');
    if (number.length >= 10) {
      ref.read(mobileRechargeNumberProvider.notifier).state = number;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const MobilePlanListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 10-digit mobile number')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final operator = ref.watch(selectedMobileOperatorProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Enter number'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (operator != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryBlueLight,
                  child: Text(
                    operator.name.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(operator.name),
                subtitle: Text(operator.circle),
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Mobile number',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _controller,
            focusNode: _focus,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            decoration: const InputDecoration(
              hintText: '10-digit mobile number',
              prefixIcon: Icon(Icons.phone_android_rounded),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _proceed,
              child: const Text('View plans'),
            ),
          ),
          const SizedBox(height: 32),
          const FamilyNumbersSection(),
        ],
      ),
    );
  }
}
