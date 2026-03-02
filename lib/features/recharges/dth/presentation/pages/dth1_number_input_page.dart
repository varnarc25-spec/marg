import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_plan_list_page.dart';

/// Number / subscriber ID input for DTH recharge.
class Dth1NumberInputPage extends ConsumerStatefulWidget {
  const Dth1NumberInputPage({super.key});

  @override
  ConsumerState<Dth1NumberInputPage> createState() => _Dth1NumberInputPageState();
}

class _Dth1NumberInputPageState extends ConsumerState<Dth1NumberInputPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();
  bool _prefilled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_prefilled || !mounted) return;
      final number = ref.read(dthSubscriberIdProvider);
      if (number.isNotEmpty && _controller.text.isEmpty) {
        _controller.text = number;
        _prefilled = true;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _proceed() {
    final number = _controller.text.trim().replaceAll(RegExp(r'\D'), '');
    if (number.length >= 10) {
      ref.read(dthSubscriberIdProvider.notifier).state = number;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const DthPlanListPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid 10-digit subscriber ID')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final operator = ref.watch(selectedDthOperatorProvider);

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
              ),
            ),
          const SizedBox(height: 24),
          const Text(
            'Subscriber ID / VC number',
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
        ],
      ),
    );
  }
}
