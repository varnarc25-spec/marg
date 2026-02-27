import 'package:flutter/material.dart';
import 'home_icon_grid_widget.dart';

/// Recharges & Bills hub: Mobile, DTH, FASTag, Electricity/Water/Gas,
/// Broadband, Credit Card, School fees, Municipal tax, Loan EMIs.
/// [items] must be provided from HomeScreen with onTap for each entry.
class HomeRechargesBillsHub extends StatelessWidget {
  const HomeRechargesBillsHub({super.key, required this.items});

  final List<HomeIconGridItem> items;

  @override
  Widget build(BuildContext context) {
    return HomeIconGrid(items: items, columns: 4, maxItems: 4);
  }
}
