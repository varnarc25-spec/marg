import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../data/models/trade_history.dart';

/// Trade Detail Screen
/// Shows detailed view of a single trade with emotion and notes
class TradeDetailScreen extends StatefulWidget {
  final TradeHistory trade;

  const TradeDetailScreen({super.key, required this.trade});

  @override
  State<TradeDetailScreen> createState() => _TradeDetailScreenState();
}

class _TradeDetailScreenState extends State<TradeDetailScreen> {
  String selectedEmotion = '';
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedEmotion = widget.trade.emotion;
    _notesController.text = widget.trade.note;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trade.symbol),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TradeInfoCard(trade: widget.trade),
            const SizedBox(height: 16),
            _EmotionSelector(
              selectedEmotion: selectedEmotion,
              onEmotionSelected: (emotion) {
                setState(() {
                  selectedEmotion = emotion;
                });
              },
            ),
            const SizedBox(height: 16),
            _NotesInput(controller: _notesController),
            const SizedBox(height: 16),
            _AiExplanationCard(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // In real app, save the updated trade
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Trade updated successfully'),
                  ),
                );
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TradeInfoCard extends StatelessWidget {
  final TradeHistory trade;

  const _TradeInfoCard({required this.trade});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  trade.symbol,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: trade.isProfit
                        ? AppColors.accentGreen.withOpacity(0.1)
                        : AppColors.accentRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '₹${trade.pnl.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: trade.isProfit
                              ? AppColors.accentGreen
                              : AppColors.accentRed,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _InfoRow(label: 'Strategy', value: trade.strategy),
            const SizedBox(height: 8),
            _InfoRow(label: 'Type', value: trade.type),
            const SizedBox(height: 8),
            _InfoRow(label: 'Trade ID', value: trade.tradeId),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _EmotionSelector extends StatelessWidget {
  final String selectedEmotion;
  final Function(String) onEmotionSelected;

  const _EmotionSelector({
    required this.selectedEmotion,
    required this.onEmotionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final emotions = [
      {'name': 'Happy', 'emoji': '😄', 'value': 'happy'},
      {'name': 'Neutral', 'emoji': '😐', 'value': 'neutral'},
      {'name': 'Anxious', 'emoji': '😟', 'value': 'anxious'},
      {'name': 'Confident', 'emoji': '😊', 'value': 'confident'},
      {'name': 'Regretful', 'emoji': '😔', 'value': 'regretful'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.journalEmotion,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: emotions.map((emotion) {
                final isSelected = selectedEmotion == emotion['value'];
                return InkWell(
                  onTap: () => onEmotionSelected(emotion['value'] as String),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : AppColors.surfaceLight,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryBlue
                            : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          emotion['emoji'] as String,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          emotion['name'] as String,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotesInput extends StatelessWidget {
  final TextEditingController controller;

  const _NotesInput({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.journalNotes,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Add your thoughts about this trade...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiExplanationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.primaryBlue.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.psychology,
                  color: AppColors.primaryBlue,
                ),
                const SizedBox(width: 8),
                Text(
                  AppStrings.journalAiExplanation,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'This trade shows a common pattern. The loss occurred because the trade was entered without checking implied volatility (IV). High IV environments can lead to unexpected outcomes. Consider waiting for lower IV periods or adjusting your strategy accordingly.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
