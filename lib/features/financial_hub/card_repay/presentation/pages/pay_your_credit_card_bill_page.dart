import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_api_exceptions.dart';
import '../../data/models/card_repay_biller.dart';
import '../providers/card_repay_provider.dart';
import 'add_bank_credit_card_page.dart';
import 'card_repay_fetch_bill_page.dart';

/// Saved cards page (`showHistory=false`) or payment history (`showHistory=true`).
class PayYourCreditCardBillPage extends ConsumerWidget {
  const PayYourCreditCardBillPage({super.key, this.showHistory = false});

  final bool showHistory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return showHistory ? _HistoryView() : _SavedCardsView();
  }
}

class _SavedCardsView extends ConsumerWidget {
  const _SavedCardsView();

  Widget _lateFeeBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_rounded, color: AppColors.primaryBlue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Late Fee Protection, Only on Paytm.',
              style: ThemeData.light().textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _helpCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need help?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Paytm reminds you about bill due dates and late fee protection.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cardRepaySavedAccountsProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Pay Credit Card Bill'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: async.when(
        data: (accounts) {
          final top = Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.card_giftcard_rounded, color: AppColors.primaryBlue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Unlock ₹40 cashback for FASTag',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('View All'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _lateFeeBanner(),
                const SizedBox(height: 12),
                Text(
                  'Cards saved on Paytm',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );

          if (accounts.isEmpty) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
              children: [
                top,
                const SizedBox(height: 10),
                FilledButton(
                  onPressed: () => Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => const AddBankCreditCardPage(),
                    ),
                  ),
                  child: const Text('Add your first card'),
                ),
                const SizedBox(height: 16),
                _helpCard(context),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
            children: [
              top,
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: accounts.length,
                itemBuilder: (_, i) {
                  final a = accounts[i];
                  final bankName = (a.billerName ?? a.label ?? 'Card').toString();
                  final letter = bankName.isNotEmpty ? bankName[0].toUpperCase() : 'C';
                  final cardEnding = a.accountNumber;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: AppColors.surfaceLight,
                            child: Text(letter, style: const TextStyle(fontWeight: FontWeight.w700)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bankName.toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text('Card ending •••• $cardEnding'),
                                if (a.isAutopay) const SizedBox(height: 6),
                                if (a.isAutopay)
                                  Text(
                                    'Autopay enabled',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primaryBlue),
                                  ),
                                const SizedBox(height: 12),
                                FilledButton(
                                  onPressed: () {
                                    if (a.billerId == null ||
                                        a.billerName == null ||
                                        a.billerId!.isEmpty ||
                                        a.billerName!.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Bank details not available for this card.'),
                                        ),
                                      );
                                      return;
                                    }
                                    ref
                                        .read(selectedCardRepaySavedAccountIdProvider.notifier)
                                        .state = a.id;
                                    ref.read(cardRepayConsumerNumberProvider.notifier).state = a.accountNumber;
                                    ref.read(selectedCardRepayBillerProvider.notifier).state = CardRepayBiller(
                                          id: a.billerId!,
                                          name: a.billerName!,
                                        );
                                    // Continue with fetch bill -> bill breakdown -> pay.
                                    Navigator.push<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (_) => const CardRepayFetchBillPage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Pay Bill'),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () async {
                              await ref.read(cardRepayRepositoryProvider).deleteSavedAccount(a.id);
                              ref.invalidate(cardRepaySavedAccountsProvider);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              FilledButton.icon(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const AddBankCreditCardPage(),
                  ),
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add another credit card'),
              ),
              const SizedBox(height: 12),
              _helpCard(context),
              const SizedBox(height: 12),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(cardRepayApiUserMessage(e))),
      ),
    );
  }
}

class _HistoryView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cardRepayHistoryProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Payment History'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
      ),
      body: async.when(
        data: (items) {
          if (items.isEmpty) return const Center(child: Text('No payments yet'));
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final e = items[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const Icon(Icons.receipt_long_rounded),
                  title: Text('₹${e.amount.toStringAsFixed(2)}'),
                  subtitle: Text(
                    [
                      if (e.billerName != null) e.billerName!,
                      if (e.status != null) e.status!,
                    ].join(' · '),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(cardRepayApiUserMessage(e))),
      ),
    );
  }
}
