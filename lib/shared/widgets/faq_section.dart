import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../../core/theme/app_theme.dart';

/// Reusable FAQ section widget.
/// - Loads FAQs from [faqProvider] using [sectionKey] (e.g. 'gold_buy').
/// - Shows first 3 questions by default, with a "View All" button to expand.
class FaqSection extends ConsumerStatefulWidget {
  final String sectionKey;
  final String title;

  const FaqSection({
    super.key,
    required this.sectionKey,
    this.title = 'Frequently Asked Questions',
  });

  @override
  ConsumerState<FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends ConsumerState<FaqSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final asyncFaqs = ref.watch(faqProvider(widget.sectionKey));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: asyncFaqs.when(
        loading: () => const Center(
          child: SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        error: (_, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Frequently Asked Questions',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 8),
            Text(
              'Unable to load FAQs right now. Please try again later.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        data: (items) {
          if (items.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Frequently Asked Questions',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 8),
                Text(
                  'No FAQs available yet for this section.',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            );
          }

          final visible = _showAll ? items : items.take(3).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              ...visible.map(
                (f) => _FaqTile(
                  q: f.question,
                  a: f.answer,
                ),
              ),
              if (items.length > 3) ...[
                const SizedBox(height: 10),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAll = !_showAll;
                      });
                    },
                    icon: Icon(
                      _showAll
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                    label: Text(_showAll ? 'View Less' : 'View All'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String q;
  final String a;
  const _FaqTile({required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 10),
      title: Text(
        q,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            a,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

