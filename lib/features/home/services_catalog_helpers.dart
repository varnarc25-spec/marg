import 'package:flutter/material.dart';
import '../../shared/models/services_catalog.dart';
import '../recharges/mobile/presentation/routes/mobile_recharge_routes.dart';
import '../recharges/dth/presentation/routes/dth_recharge_routes.dart';
import '../utilities/electricity/presentation/routes/electricity_routes.dart';
import '../utilities/broadband/presentation/routes/broadband_routes.dart';
import '../credit_card/presentation/routes/credit_card_routes.dart';
import '../fastag/presentation/routes/fastag_routes.dart';
import '../education/presentation/routes/education_routes.dart';
import '../government_bills/presentation/routes/government_bills_routes.dart';

/// Navigate to the screen for the given catalog service [slug].
/// Known slugs are mapped to existing routes; unknown slugs show a placeholder.
void navigateToServiceBySlug(BuildContext context, String slug) {
  final route = _slugToRoute(slug);
  if (route != null) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => route));
  } else {
    _showComingSoon(context, slug);
  }
}

Widget? _slugToRoute(String slug) {
  switch (slug) {
    case 'mobile-recharge':
      return MobileRechargeRoutes.entryPage();
    case 'dth':
      return DthRechargeRoutes.entryPage();
    case 'fastag-recharge':
      return FastagRoutes.entryPage();
    case 'electricity':
      return ElectricityRoutes.entryPage();
    case 'broadband-landline':
      return BroadbandRoutes.entryPage();
    case 'credit-card-bill':
    case 'loan-repayment':
      return CreditCardRoutes.entryPage();
    case 'education-fee':
      return EducationRoutes.entryPage();
    case 'municipal-tax':
      return GovernmentBillsRoutes.entryPage();
    default:
      return null;
  }
}

void _showComingSoon(BuildContext context, String slug) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$slug – coming soon'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// Map API icon_name to Material [IconData]. Defaults to [Icons.widgets_rounded].
IconData iconForCatalogItem(CatalogItem item) {
  final name = (item.iconName ?? '').toLowerCase();
  switch (name) {
    case 'mobile':
    case 'phone':
      return Icons.phone_android_rounded;
    case 'tv':
      return Icons.tv_rounded;
    case 'fastag':
    case 'car':
      return Icons.directions_car_rounded;
    case 'electricity':
    case 'bolt':
      return Icons.bolt_rounded;
    case 'broadband':
    case 'wifi':
      return Icons.wifi_rounded;
    case 'credit-card':
      return Icons.credit_card_rounded;
    case 'education':
    case 'school':
      return Icons.school_rounded;
    case 'municipal':
    case 'water':
      return Icons.water_drop_rounded;
    case 'loan':
      return Icons.account_balance_rounded;
    case 'globe':
      return Icons.public_rounded;
    case 'cylinder':
      return Icons.local_gas_station_rounded;
    case 'donation':
      return Icons.volunteer_activism_rounded;
    case 'insurance':
      return Icons.shield_rounded;
    case 'ev':
      return Icons.ev_station_rounded;
    case 'echallan':
      return Icons.receipt_long_rounded;
    case 'sim':
      return Icons.sim_card_rounded;
    default:
      return Icons.widgets_rounded;
  }
}
