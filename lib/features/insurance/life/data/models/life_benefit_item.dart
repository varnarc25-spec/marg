import 'package:flutter/material.dart';

/// Item for "Why buy from us" from `GET /api/insurance/life/benefits`.
class LifeBenefitItem {
  const LifeBenefitItem({
    required this.title,
    this.iconName,
    this.description,
  });

  factory LifeBenefitItem.fromJson(Map<String, dynamic> json) {
    return LifeBenefitItem(
      title: (json['title'] ?? json['label'] ?? json['name'] ?? '').toString(),
      iconName: json['icon']?.toString() ?? json['iconName']?.toString(),
      description: json['description']?.toString(),
    );
  }

  final String title;
  final String? iconName;
  final String? description;

  IconData resolveIcon() {
    final k = iconName?.toLowerCase() ?? '';
    if (k.contains('shield') || k.contains('claim')) return Icons.shield_rounded;
    if (k.contains('discount') || k.contains('percent')) return Icons.discount_rounded;
    if (k.contains('support') || k.contains('manager')) return Icons.support_agent_rounded;
    if (k.contains('money') || k.contains('zero')) return Icons.money_off_rounded;
    if (k.contains('verified') || k.contains('offer')) return Icons.verified_user_rounded;
    if (k.contains('payment')) return Icons.payment_rounded;
    return Icons.check_circle_outline_rounded;
  }
}
