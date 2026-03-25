import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marg/features/insurance/health/data/models/health_network_hospital.dart';
import 'package:marg/shared/providers/app_providers.dart';

import '../providers/health_insurance_provider.dart';
import 'health_insurance_select_plan_page.dart';
import 'health_insurance_help_page.dart';

/// "Let's find your perfect plan" — form fields change based on selected family members.
/// Flow: Home (select members) → Find Plans → this page → View Plans → Select Plan.
class HealthInsuranceDetailsPage extends ConsumerStatefulWidget {
  const HealthInsuranceDetailsPage({super.key});

  @override
  ConsumerState<HealthInsuranceDetailsPage> createState() =>
      _HealthInsuranceDetailsPageState();
}

class _HealthInsuranceDetailsPageState
    extends ConsumerState<HealthInsuranceDetailsPage> {
  final _elderAgeController = TextEditingController();
  final _pincodeController = TextEditingController();
  final List<TextEditingController> _parentAgeControllers = [];

  Timer? _hospitalDebounce;
  bool _loadingHospitals = false;
  List<HealthNetworkHospital> _hospitals = const [];
  String? _hospitalError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncFormToControllers();
      final p = ref.read(healthDetailsFormProvider).pincode.trim();
      if (p.length == 6) _scheduleHospitalLoad(p);
    });
  }

  void _syncFormToControllers() {
    final form = ref.read(healthDetailsFormProvider);
    _elderAgeController.text = form.elderAge ?? '';
    _pincodeController.text = form.pincode;
    while (_parentAgeControllers.length < form.parentAges.length) {
      _parentAgeControllers.add(TextEditingController());
    }
    for (
      var i = 0;
      i < form.parentAges.length && i < _parentAgeControllers.length;
      i++
    ) {
      _parentAgeControllers[i].text = form.parentAges[i] ?? '';
    }
  }

  @override
  void dispose() {
    _hospitalDebounce?.cancel();
    _elderAgeController.dispose();
    _pincodeController.dispose();
    for (final c in _parentAgeControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _scheduleHospitalLoad(String pin) {
    _hospitalDebounce?.cancel();
    if (pin.trim().length != 6) {
      setState(() {
        _hospitals = const [];
        _hospitalError = null;
        _loadingHospitals = false;
      });
      return;
    }
    setState(() {
      _loadingHospitals = true;
      _hospitalError = null;
    });
    _hospitalDebounce = Timer(const Duration(milliseconds: 500), () async {
      final api = ref.read(healthInsuranceApiServiceProvider);
      final auth = ref.read(firebaseAuthServiceProvider);
      try {
        final token = await auth.getIdToken();
        final list = await api.getNetworkHospitals(pin.trim(), idToken: token);
        if (!mounted) return;
        setState(() {
          _hospitals = list;
          _loadingHospitals = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _hospitalError = e.toString();
          _loadingHospitals = false;
          _hospitals = const [];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final selectedMembers = ref.watch(healthSelectedMembersProvider);
    final form = ref.watch(healthDetailsFormProvider);
    final plansState = ref.watch(healthPlansProvider);

    final hasSelfOrSpouse =
        selectedMembers.contains('Myself') ||
        selectedMembers.contains('Spouse');
    final hasChildren = selectedMembers.contains('Children');
    final hasParents = selectedMembers.contains('Parents');

    if (hasParents && form.parentAges.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(healthDetailsFormProvider.notifier).state = form.copyWith(
          parentAges: [null],
        );
      });
    }
    if (hasParents &&
        _parentAgeControllers.length <
            (form.parentAges.isEmpty ? 1 : form.parentAges.length)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          final n = form.parentAges.isEmpty ? 1 : form.parentAges.length;
          while (_parentAgeControllers.length < n) {
            final idx = _parentAgeControllers.length;
            final t = form.parentAges.length > idx
                ? form.parentAges[idx]
                : null;
            _parentAgeControllers.add(TextEditingController(text: t));
          }
        });
      });
    }

    ref.listen<HealthPlansState>(healthPlansProvider, (prev, next) {
      if (next is HealthPlansSuccess && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => const HealthInsuranceSelectPlanPage(),
          ),
        );
      }
    });

    bool canSubmit() {
      if (form.pincode.isEmpty) return false;
      if (form.preExistingDisease == null) return false;
      if (hasSelfOrSpouse &&
          (form.elderAge == null || form.elderAge!.isEmpty)) {
        return false;
      }
      if (hasParents && form.parentAges.isEmpty) return false;
      if (hasParents) {
        for (final a in form.parentAges) {
          if (a == null || a.isEmpty) return false;
        }
      }
      return true;
    }

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
            "Let's find your perfect plan",
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter details for customised experience.',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 28),

          if (hasSelfOrSpouse) ...[
            Text(
              'Age of the elder member (among self & spouse)',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            _InputField(
              controller: _elderAgeController,
              hint: 'Enter age',
              onChanged: (v) {
                ref.read(healthDetailsFormProvider.notifier).state = ref
                    .read(healthDetailsFormProvider)
                    .copyWith(elderAge: v.isEmpty ? null : v);
              },
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: 24),
          ],

          if (hasChildren) ...[
            Text(
              'Children',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add number of children',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            _StepperRow(
              value: form.childrenCount,
              onDecrement: () {
                final f = ref.read(healthDetailsFormProvider);
                if (f.childrenCount > 0) {
                  ref.read(healthDetailsFormProvider.notifier).state = f
                      .copyWith(childrenCount: f.childrenCount - 1);
                }
              },
              onIncrement: () {
                final f = ref.read(healthDetailsFormProvider);
                ref.read(healthDetailsFormProvider.notifier).state = f.copyWith(
                  childrenCount: f.childrenCount + 1,
                );
              },
              colorScheme: colorScheme,
              textTheme: textTheme,
            ),
            const SizedBox(height: 24),
          ],

          if (hasParents) ...[
            ...List.generate(
              form.parentAges.isEmpty ? 1 : form.parentAges.length,
              (i) {
                if (i >= _parentAgeControllers.length) {
                  return const SizedBox.shrink();
                }
                final controller = _parentAgeControllers[i];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Age of parent ${i + 1}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _InputField(
                        controller: controller,
                        hint: 'Enter age',
                        onChanged: (v) {
                          final f = ref.read(healthDetailsFormProvider);
                          final list = List<String?>.from(f.parentAges);
                          while (list.length <= i) {
                            list.add(null);
                          }
                          list[i] = v.isEmpty ? null : v;
                          ref.read(healthDetailsFormProvider.notifier).state = f
                              .copyWith(parentAges: list);
                        },
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () {
                final f = ref.read(healthDetailsFormProvider);
                final list = List<String?>.from(f.parentAges);
                if (list.isEmpty) list.add(null);
                list.add(null);
                ref.read(healthDetailsFormProvider.notifier).state = f.copyWith(
                  parentAges: list,
                );
                setState(() {
                  _parentAgeControllers.add(TextEditingController());
                });
              },
              child: Text(
                'Add Parents/In-law',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],

          Text(
            'Current Address Pincode',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Helps find best cashless hospitals near you',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _InputField(
            controller: _pincodeController,
            hint: 'Eg: 244901',
            suffixIcon: Icon(
              Icons.my_location_rounded,
              size: 22,
              color: colorScheme.onSurfaceVariant,
            ),
            onChanged: (v) {
              ref.read(healthDetailsFormProvider.notifier).state = ref
                  .read(healthDetailsFormProvider)
                  .copyWith(pincode: v);
              _scheduleHospitalLoad(v);
            },
            colorScheme: colorScheme,
            textTheme: textTheme,
          ),
          if (_loadingHospitals) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Loading cashless hospitals…',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ] else if (_hospitalError != null) ...[
            const SizedBox(height: 8),
            Text(
              'Hospitals: ${_hospitalError!}',
              style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
            ),
          ] else if (_hospitals.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Cashless hospitals near you',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            ..._hospitals.take(5).map(
                  (h) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      h.address != null && h.address!.isNotEmpty
                          ? '${h.name} — ${h.address}'
                          : h.name,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            if (_hospitals.length > 5)
              Text(
                '+ ${_hospitals.length - 5} more',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
          const SizedBox(height: 24),

          Text(
            'Does any member have any pre-existing disease?',
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Like diabetes, High BP, heart diseases, etc.',
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _YesNoChip(
                  label: 'Yes',
                  selected: form.preExistingDisease == true,
                  onTap: () {
                    ref.read(healthDetailsFormProvider.notifier).state = ref
                        .read(healthDetailsFormProvider)
                        .copyWith(preExistingDisease: true);
                  },
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _YesNoChip(
                  label: 'No',
                  selected: form.preExistingDisease == false,
                  onTap: () {
                    ref.read(healthDetailsFormProvider.notifier).state = ref
                        .read(healthDetailsFormProvider)
                        .copyWith(preExistingDisease: false);
                  },
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          Text(
            'PHONEPE ADVISORY',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Get personalised support from our health advisors',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.headset_mic_rounded,
                size: 40,
                color: colorScheme.primary.withValues(alpha: 0.8),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              final f = ref.read(healthDetailsFormProvider);
              ref.read(healthDetailsFormProvider.notifier).state = f.copyWith(
                advisoryConsent: !f.advisoryConsent,
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: form.advisoryConsent
                        ? colorScheme.primary
                        : Colors.transparent,
                    border: Border.all(
                      color: form.advisoryConsent
                          ? colorScheme.primary
                          : colorScheme.outline,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: form.advisoryConsent
                      ? Icon(
                          Icons.check_rounded,
                          size: 18,
                          color: colorScheme.onPrimary,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I am okay to receive calls from an expert health advisor from PhonePe',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          if (plansState is HealthPlansLoading)
            const Center(child: CircularProgressIndicator())
          else
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: canSubmit()
                    ? () {
                        final f = ref.read(healthDetailsFormProvider);
                        final updatedForm = f.copyWith(
                          elderAge: hasSelfOrSpouse
                              ? _elderAgeController.text.trim()
                              : null,
                          pincode: _pincodeController.text.trim(),
                          parentAges: hasParents
                              ? _parentAgeControllers
                                    .map(
                                      (c) => c.text.trim().isEmpty
                                          ? null
                                          : c.text.trim(),
                                    )
                                    .toList()
                              : f.parentAges,
                        );
                        ref.read(healthDetailsFormProvider.notifier).state =
                            updatedForm;
                        ref.read(healthPlansProvider.notifier).fetchQuotedPlans(
                              memberTypes: selectedMembers,
                              form: updatedForm,
                            );
                      }
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: canSubmit()
                      ? colorScheme.primary
                      : colorScheme.surfaceContainerHighest,
                  foregroundColor: canSubmit()
                      ? colorScheme.onPrimary
                      : colorScheme.onSurfaceVariant,
                ),
                child: const Text('View Plans'),
              ),
            ),
          if (plansState is HealthPlansError) ...[
            const SizedBox(height: 12),
            Text(
              plansState.message,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.error),
            ),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    required this.onChanged,
    required this.colorScheme,
    required this.textTheme,
  });

  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final void Function(String) onChanged;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          suffixIcon: suffixIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: suffixIcon,
                )
              : null,
        ),
      ),
    );
  }
}

class _StepperRow extends StatelessWidget {
  const _StepperRow({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.colorScheme,
    required this.textTheme,
  });

  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onDecrement,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Icon(Icons.remove_rounded, color: colorScheme.onSurface),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              '$value',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Material(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
              onTap: onIncrement,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Icon(Icons.add_rounded, color: colorScheme.onPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _YesNoChip extends StatelessWidget {
  const _YesNoChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? colorScheme.primary.withValues(alpha: 0.15)
          : colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.5),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? colorScheme.primary : colorScheme.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
