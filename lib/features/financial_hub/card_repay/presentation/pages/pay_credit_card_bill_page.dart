import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_api_exceptions.dart';
import '../../data/card_repay_data.dart';
import '../../data/models/card_repay_biller.dart';
import '../providers/card_repay_provider.dart';
import 'pay_your_credit_card_bill_page.dart';
import 'add_bank_credit_card_page.dart';

/// Financial Hub entry page for Credit Card Repay.
class PayCreditCardBillPage extends ConsumerWidget {
  const PayCreditCardBillPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billersAsync = ref.watch(cardRepayBillersProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Credit Card Repay'),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            tooltip: 'Payment history',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PayYourCreditCardBillPage(showHistory: true),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet_rounded),
            tooltip: 'Saved cards',
            onPressed: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => const PayYourCreditCardBillPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: billersAsync.when(
        data: (billers) {
          final gridItems = billers.isNotEmpty
              ? billers
                  .map((b) => CardRepayBank(name: b.name, logoLetter: b.name.isNotEmpty ? b.name[0] : null))
                  .toList()
              : popularBanks;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_offer_rounded, color: AppColors.primaryBlue, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Unlock ₹40 cashback for FASTag',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('View All')),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: gridItems.length + 1, // +1 for "View More"
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  if (index == gridItems.length) {
                    return _ViewMoreBanksTile(onTap: () {});
                  }
                  final bank = gridItems[index];
                  return _BankGridTile(
                    bankName: bank.name,
                    displayLetter: bank.displayLetter.toUpperCase(),
                    onTap: () {
                      // Find matching API biller if available, otherwise use a dummy id.
                      CardRepayBiller? selected;
                      if (billers.isNotEmpty) {
                        selected = billers.firstWhere(
                          (x) => x.name.toLowerCase() == bank.name.toLowerCase(),
                          orElse: () => billers.first,
                        );
                      }
                      if (selected == null) return;
                      ref.read(selectedCardRepayBillerProvider.notifier).state = selected;
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(builder: (_) => const AddBankCreditCardPage()),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: cardRepayServices.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final s = cardRepayServices[i];
                    return Container(
                      width: 170,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.backgroundLight,
                            child: Icon(s.icon, color: AppColors.primaryBlue),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(s.title, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                Text(s.subtitle, style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 18),
              _RecommendedCard(model: recommendedCreditCard),
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

class _BankGridTile extends StatelessWidget {
  final String bankName;
  final String displayLetter;
  final VoidCallback onTap;

  const _BankGridTile({
    required this.bankName,
    required this.displayLetter,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surfaceLight,
            child: Text(
              displayLetter,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            bankName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _ViewMoreBanksTile extends StatelessWidget {
  final VoidCallback onTap;
  const _ViewMoreBanksTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.surfaceLight,
            child: const Icon(Icons.chevron_right_rounded, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            'View More Banks',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _RecommendedCard extends StatelessWidget {
  final CardRepayRecommended model;
  const _RecommendedCard({required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surfaceLight,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(model.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(model.tags, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            ...model.benefits.take(2).map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(b.icon, size: 18, color: AppColors.primaryBlue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        b.text,
                        style: Theme.of(context).textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () {},
              child: Text(model.ctaLabel),
            ),
          ],
        ),
      ),
    );
  }
}
