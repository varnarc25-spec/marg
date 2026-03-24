import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/fastag_api_exceptions.dart';
import '../providers/fastag_provider.dart';

/// Polls `GET /api/recharges/fastag/recharge/status/{id}`.
class FastagRechargeStatusPage extends ConsumerStatefulWidget {
  const FastagRechargeStatusPage({
    super.key,
    required this.transactionId,
  });

  final String transactionId;

  @override
  ConsumerState<FastagRechargeStatusPage> createState() =>
      _FastagRechargeStatusPageState();
}

class _FastagRechargeStatusPageState
    extends ConsumerState<FastagRechargeStatusPage> {
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final map = await ref
          .read(fastagRepositoryProvider)
          .getRechargeStatus(widget.transactionId);
      if (mounted) {
        setState(() {
          _data = map;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = fastagApiUserMessage(e);
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Recharge status'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(onPressed: _load, child: const Text('Retry')),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transaction ${widget.transactionId}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SelectableText(
                            _data?.toString() ?? '{}',
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Shape depends on backend; map fields in UI when contract is fixed.',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
