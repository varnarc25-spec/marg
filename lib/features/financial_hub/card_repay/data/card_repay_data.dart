import 'package:flutter/material.dart';

/// Bank option for Pay Credit Card Bill — select bank to pay bill.
class CardRepayBank {
  final String name;
  final String? logoLetter;

  const CardRepayBank({required this.name, this.logoLetter});

  String get displayLetter => logoLetter ?? (name.isNotEmpty ? name[0] : '?');
}

/// Popular banks for the bank selection grid.
const List<CardRepayBank> popularBanks = [
  CardRepayBank(name: 'HDFC Bank'),
  CardRepayBank(name: 'SBI'),
  CardRepayBank(name: 'Axis Bank'),
  CardRepayBank(name: 'ICICI Bank'),
  CardRepayBank(name: 'RBL Bank'),
  CardRepayBank(name: 'Kotak Mahindra'),
  CardRepayBank(name: 'IndusInd Bank'),
  CardRepayBank(name: 'Yes Bank'),
  CardRepayBank(name: 'Bank of Baroda'),
];

/// A saved credit card for "Pay Your Credit Card Bill" (cards saved on Paytm).
class SavedCreditCard {
  final String bankName;
  final String lastFourDigits;
  final String network; // e.g. 'Mastercard', 'Visa', 'RuPay'

  const SavedCreditCard({
    required this.bankName,
    required this.lastFourDigits,
    this.network = 'Mastercard',
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedCreditCard &&
          bankName == other.bankName &&
          lastFourDigits == other.lastFourDigits;

  @override
  int get hashCode => Object.hash(bankName, lastFourDigits);
}

/// Horizontal service card (e.g. Paytm Money, Paytm Gold style).
class CardRepayService {
  final String title;
  final String subtitle;
  final IconData icon;

  const CardRepayService({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

const List<CardRepayService> cardRepayServices = [
  CardRepayService(
    title: 'Paytm Money',
    subtitle: 'Pay Only ₹10',
    icon: Icons.account_balance_wallet_rounded,
  ),
  CardRepayService(
    title: 'Paytm Gold',
    subtitle: 'Flat 5% off',
    icon: Icons.diamond_rounded,
  ),
];

/// Benefit item for recommended credit card.
class CardRepayBenefit {
  final String text;
  final IconData icon;

  const CardRepayBenefit({required this.text, required this.icon});
}

/// Recommended credit card product.
class CardRepayRecommended {
  final String title;
  final String tags;
  final List<CardRepayBenefit> benefits;
  final String joiningFee;
  final String ctaLabel;

  const CardRepayRecommended({
    required this.title,
    required this.tags,
    required this.benefits,
    required this.joiningFee,
    required this.ctaLabel,
  });
}

const CardRepayRecommended recommendedCreditCard = CardRepayRecommended(
  title: 'IDFC First Bank First Earn Virtual Credit Card',
  tags: 'UPI SPENDS • MOVIES',
  benefits: [
    CardRepayBenefit(
      text: 'Assured FD backed credit card, minimum FD of ₹5,000',
      icon: Icons.credit_card_rounded,
    ),
    CardRepayBenefit(
      text: '1% Cashback on UPI spends on IDFC App*',
      icon: Icons.card_giftcard_rounded,
    ),
    CardRepayBenefit(
      text: '100% cashback upto ₹200 via IDFC FIRST mobile app',
      icon: Icons.savings_rounded,
    ),
    CardRepayBenefit(
      text: 'Complimentary Roadside Assistance worth ₹1,399',
      icon: Icons.directions_car_rounded,
    ),
  ],
  joiningFee: '₹499 + GST',
  ctaLabel: 'Get Card Now',
);

/// Recommended services for horizontal row.
class CardRepayRecommendedService {
  final String label;
  final IconData icon;

  const CardRepayRecommendedService({required this.label, required this.icon});
}

const List<CardRepayRecommendedService> recommendedServicesList = [
  CardRepayRecommendedService(label: 'Personal Loan', icon: Icons.currency_rupee_rounded),
  CardRepayRecommendedService(label: 'Paytm Money', icon: Icons.trending_up_rounded),
  CardRepayRecommendedService(label: 'Save in Gold', icon: Icons.diamond_rounded),
  CardRepayRecommendedService(label: 'Get Credit Card', icon: Icons.credit_card_rounded),
];
