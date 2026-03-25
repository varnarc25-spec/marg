import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../providers/dth_recharge_provider.dart';
import 'dth_plan_list_page.dart';

/// Subscriber ID / VC number input for DTH recharge.
class DthNumberInputPage extends ConsumerStatefulWidget {
  const DthNumberInputPage({super.key});

  @override
  ConsumerState<DthNumberInputPage> createState() => _DthNumberInputPageState();
}

class _DthNumberInputPageState extends ConsumerState<DthNumberInputPage> {
  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    final existing = ref.read(dthSubscriberIdProvider);
    if (existing.isNotEmpty) {
      _controller.text = existing;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _proceed() {
    final id = _controller.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter subscriber ID / VC number')),
      );
      return;
    }
    ref.read(dthSubscriberIdProvider.notifier).state = id;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const DthPlanListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final op = ref.watch(selectedDthOperatorProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Enter subscriber ID'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (op != null)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primaryBlueLight,
                  child: op.logoUrl != null && op.logoUrl!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            op.logoUrl!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Text(
                              op.name.isNotEmpty
                                  ? op.name.substring(0, 1).toUpperCase()
                                  : 'D',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : Text(
                          op.name.isNotEmpty
                              ? op.name.substring(0, 1).toUpperCase()
                              : 'D',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
                title: Text(op.name),
                subtitle: const Text('DTH'),
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
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter subscriber ID or VC number',
              prefixIcon: Icon(Icons.tv_rounded),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _proceed,
              child: const Text('View plans'),
            ),
          ),
        ],
      ),
    );
  }
}
