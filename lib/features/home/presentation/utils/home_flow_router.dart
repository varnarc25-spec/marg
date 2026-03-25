import 'package:flutter/material.dart';
import '../../../Travel/flight/presentation/pages/travel_flight_page.dart';
import '../../../insurance/life/presentation/pages/life_insurance_home_page.dart';
import '../../../recharges/mobile/presentation/routes/mobile_recharge_routes.dart';
import '../../../utilities/electricity/presentation/routes/electricity_routes.dart';
import '../screens/gold_silver_all_services_screen.dart';

void routeByFlowType(BuildContext context, String flowType) {
  Widget? page;
  switch (flowType) {
    case 'recharge_flow':
      page = MobileRechargeRoutes.entryPage();
      break;
    case 'bbps_flow':
      page = ElectricityRoutes.entryPage();
      break;
    case 'investment_flow':
      page = const GoldSilverAllServicesScreen();
      break;
    case 'booking_flow':
      page = const TravelFlightPage();
      break;
    case 'insurance_flow':
      page = const LifeInsuranceHomePage();
      break;
    default:
      page = null;
  }

  if (page != null) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page!));
    return;
  }

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('$flowType is coming soon'),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
