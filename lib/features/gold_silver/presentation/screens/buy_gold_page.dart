import 'package:flutter/material.dart';
import 'gold_silver_common.dart';

class BuyGoldPage extends StatelessWidget {
  const BuyGoldPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyMetalPage(config: MetalConfig.gold);
  }
}

