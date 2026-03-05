import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/life_insurance_plan.dart';
import '../providers/life_insurance_provider.dart';
import 'life_insurance_help_page.dart';

/// Recommended cover page: Congratulations, sum assured slider, cover till age, Talk To Us, Continue.
class LifeInsuranceCoverPage extends ConsumerStatefulWidget {
  const LifeInsuranceCoverPage({super.key});

  @override
  ConsumerState<LifeInsuranceCoverPage> createState() =>
      _LifeInsuranceCoverPageState();
}

class _LifeInsuranceCoverPageState extends ConsumerState<LifeInsuranceCoverPage> {
  static const int minLakhs = 25;
  static const int maxLakhs = 300;

  static String _formatCover(int lakhs) {
    if (lakhs >= 100) return '₹${lakhs ~/ 100} Crore';
    return '₹$lakhs Lakh';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final coverState = ref.watch(lifeCoverProvider);
    final selectedLakhs = ref.watch(lifeSelectedSumAssuredLakhsProvider);
    final coverTillAge = ref.watch(lifeCoverTillAgeProvider);

    if (coverState is! LifeCoverSuccess) {
      return Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Life Insurance',
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
          child: coverState is LifeCoverLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Complete the previous step to see your cover.',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Back'),
                    ),
                  ],
                ),
        ),
      );
    }

    final result = (coverState as LifeCoverSuccess).result;
    final currentLakhs = (selectedLakhs ?? result.recommendedCoverLakhs)
        .clamp(minLakhs, maxLakhs);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Life Insurance',
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
                  builder: (_) => const LifeInsuranceHelpPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            children: [
              const SizedBox(height: 16),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Congratulations!',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Your recommended cover is here',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'Based on the details provided, you are eligible for up to ${_formatCover(result.maxCoverLakhs)} cover amount',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Select Sum Assured',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatCover(currentLakhs),
                        style: textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              size: 20,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Ideal recommended cover is ${_formatCover(result.recommendedCoverLakhs)}, which is 10x of income',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: colorScheme.primary,
                          inactiveTrackColor: colorScheme.surfaceContainerHighest,
                          thumbColor: colorScheme.primary,
                          overlayColor: colorScheme.primary.withValues(alpha: 0.2),
                        ),
                        child: Slider(
                          value: currentLakhs.toDouble(),
                          min: minLakhs.toDouble(),
                          max: maxLakhs.toDouble(),
                          divisions: (maxLakhs - minLakhs) ~/ 5,
                          onChanged: (v) {
                            ref.read(lifeSelectedSumAssuredLakhsProvider.notifier).state =
                                v.round();
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Min ₹25 Lakh',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            'Max ₹3 Crore',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Recommended cover till age',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: coverTillAge,
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: colorScheme.onSurface,
                    ),
                    items: lifeCoverTillAgeOptions
                        .map((age) => DropdownMenuItem<int>(
                              value: age,
                              child: Text('$age years'),
                            ))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        ref.read(lifeCoverTillAgeProvider.notifier).state = v;
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 80,
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              color: colorScheme.primary,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.headset_mic_rounded,
                        color: colorScheme.onPrimary,
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Talk To Us',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Continue to plan selection'),
                  ),
                );
              },
              child: const Text('Continue'),
            ),
          ),
        ),
      ),
    );
  }
}
