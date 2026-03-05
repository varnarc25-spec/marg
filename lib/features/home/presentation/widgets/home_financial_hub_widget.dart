import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'home_icon_grid_widget.dart';
import '../../../financial_hub/card_repay/presentation/pages/pay_credit_card_bill_page.dart';
import '../../../financial_hub/budget/presentation/pages/mybudget_page.dart';
import '../../../financial_hub/invest/presentation/pages/invest_page.dart';
import '../../../financial_hub/crypto/presentation/pages/crypto_wallet_page.dart';

/// Financial Hub: Card Repay, Savings, Invest, Crypto.
class HomeFinancialHub extends ConsumerWidget {
  const HomeFinancialHub({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(l10nProvider);
    final items = [
      HomeIconGridItem(
        Icons.credit_card_rounded,
        l10n.homeIconCardRepay,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const PayCreditCardBillPage(),
            ),
          );
        },
      ),
      HomeIconGridItem(
        Icons.savings_rounded,
        l10n.homeIconSavings,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const MybudgetPage(),
            ),
          );
        },
      ),
      HomeIconGridItem(
        Icons.trending_up_rounded,
        l10n.homeIconInvest,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const InvestPage(),
            ),
          );
        },
      ),
      HomeIconGridItem(
        Icons.currency_bitcoin_rounded,
        l10n.homeIconExchange,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const CryptoWalletPage(),
            ),
          );
        },
      ),
    ];
    return HomeIconGrid(items: items, columns: 4);
  }
}
