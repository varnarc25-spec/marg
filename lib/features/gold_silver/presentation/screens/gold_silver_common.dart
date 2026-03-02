import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

/// Base scaffold used for Gold & Silver placeholder pages.
class GoldSilverFeaturePlaceholderPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const GoldSilverFeaturePlaceholderPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(title),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.iconTilePastelBlue,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const Spacer(),
            const Text(
              'This is a placeholder screen. Integrate your gold & silver flows, APIs and KYC checks here.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class MetalConfig {
  final String appBarTitle;
  final String balanceTitle;
  final String investTitle;
  final String buyPriceLabel;
  final String buyPriceValue;
  final String buyPriceMeta;
  final String riseText;
  final String purityText;
  final Color appBarColor;
  final Color accentColor;
  final Color chartFill;

  const MetalConfig({
    required this.appBarTitle,
    required this.balanceTitle,
    required this.investTitle,
    required this.buyPriceLabel,
    required this.buyPriceValue,
    required this.buyPriceMeta,
    required this.riseText,
    required this.purityText,
    required this.appBarColor,
    required this.accentColor,
    required this.chartFill,
  });

  static const gold = MetalConfig(
    appBarTitle: 'eSwarna Digital Gold',
    balanceTitle: 'My Gold Balance',
    investTitle: 'Invest in 24k Gold',
    buyPriceLabel: 'Buying Price:',
    buyPriceValue: '₹16334.18/gm',
    buyPriceMeta: '(+3% GST)',
    riseText: '245.8% Gold price rise in last 5 years',
    purityText: 'You will be purchasing gold of 24K | 99.9% purity',
    appBarColor: Color(0xFF1876B6),
    accentColor: Color(0xFF1876B6),
    chartFill: Color(0xFFFFC107),
  );

  static const silver999 = MetalConfig(
    appBarTitle: 'Digital Silver (999)',
    balanceTitle: 'My Silver Balance',
    investTitle: 'Invest in 999 Silver',
    buyPriceLabel: 'Buying Price:',
    buyPriceValue: '₹120.50/gm',
    buyPriceMeta: '(+3% GST)',
    riseText: '112.4% Silver price rise in last 5 years',
    purityText: 'You will be purchasing silver of 999 | 99.9% purity',
    appBarColor: Color(0xFF374151),
    accentColor: Color(0xFF374151),
    chartFill: Color(0xFFB0BEC5),
  );
}

/// Full buy flow page (used by Buy Gold / Buy Silver).
class BuyMetalPage extends StatefulWidget {
  final MetalConfig config;

  const BuyMetalPage({super.key, required this.config});

  @override
  State<BuyMetalPage> createState() => _BuyMetalPageState();
}

class _BuyMetalPageState extends State<BuyMetalPage> {
  final _amountController = TextEditingController();
  bool _buyInRupees = true;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _setQuickAmount(int amount) {
    _amountController.text = amount.toString();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final amountText = _amountController.text.trim();
    final hasAmount = amountText.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(c.appBarTitle),
        backgroundColor: c.appBarColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          _BalanceCard(
            title: c.balanceTitle,
            accent: c.accentColor,
          ),
          const SizedBox(height: 12),
          _LiveBuyPriceCard(
            label: c.buyPriceLabel,
            value: c.buyPriceValue,
            meta: c.buyPriceMeta,
          ),
          const SizedBox(height: 12),
          _ChartCard(
            accent: c.accentColor,
            fill: c.chartFill,
            riseText: c.riseText,
          ),
          const SizedBox(height: 12),
          _InvestCard(
            accent: c.accentColor,
            investTitle: c.investTitle,
            purityText: c.purityText,
            buyInRupees: _buyInRupees,
            amountController: _amountController,
            onBuyInRupeesChanged: (v) => setState(() => _buyInRupees = v),
            onQuickAmount: _setQuickAmount,
            hasAmount: hasAmount,
          ),
          const SizedBox(height: 16),
          _InfoIconsRow(accent: c.accentColor),
          const SizedBox(height: 16),
          const _ShopSection(),
          const SizedBox(height: 16),
          const _FaqSection(),
          const SizedBox(height: 16),
          const _TrendsSection(),
          const SizedBox(height: 24),
          const _PoweredByFooter(),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  const _CardShell({required this.child, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final String title;
  final Color accent;

  const _BalanceCard({required this.title, required this.accent});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('In Grams', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Color(0xFFFFC107)),
                        SizedBox(width: 8),
                        Text('0.0000 gms', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 44, color: const Color(0xFFE5E7EB)),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Current Value*', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.circle, size: 10, color: Color(0xFFFFC107)),
                        SizedBox(width: 8),
                        Text('₹0.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('*Value based on sell price', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Text(
                  'Manage Your Gold Savings',
                  style: TextStyle(color: accent, fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, color: accent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBuyPriceCard extends StatelessWidget {
  final String label;
  final String value;
  final String meta;

  const _LiveBuyPriceCard({
    required this.label,
    required this.value,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Live',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13),
                children: [
                  TextSpan(text: '$label '),
                  TextSpan(text: value, style: const TextStyle(fontWeight: FontWeight.w800)),
                  const TextSpan(text: ' '),
                  TextSpan(text: meta, style: const TextStyle(color: AppColors.textSecondary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final Color accent;
  final Color fill;
  final String riseText;

  const _ChartCard({required this.accent, required this.fill, required this.riseText});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              children: [
                Icon(Icons.trending_up_rounded, color: accent, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    riseText,
                    style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                  ),
                ),
                Icon(Icons.keyboard_arrow_up_rounded, color: accent),
              ],
            ),
          ),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SparkLinePainter(color: fill),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _RangeChip('1M'),
                        _RangeChip('6M'),
                        _RangeChip('1Y'),
                        _RangeChip('3Y'),
                        _RangeChip('5Y', selected: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Text(
              'Note: The chart is based on past data. Past performance is not an indicator of future returns.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _RangeChip(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFC107) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: selected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _SparkLinePainter extends CustomPainter {
  final Color color;
  _SparkLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final fillPaint = Paint()
      ..color = color.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    final p = Path();
    final fp = Path();

    Offset pt(double x, double y) => Offset(x * size.width, (1 - y) * size.height);

    final points = <Offset>[
      pt(0.00, 0.20),
      pt(0.12, 0.22),
      pt(0.26, 0.26),
      pt(0.38, 0.30),
      pt(0.54, 0.36),
      pt(0.68, 0.48),
      pt(0.80, 0.60),
      pt(0.90, 0.72),
      pt(1.00, 0.85),
    ];

    p.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final cp1 = Offset((prev.dx + curr.dx) / 2, prev.dy);
      final cp2 = Offset((prev.dx + curr.dx) / 2, curr.dy);
      p.cubicTo(cp1.dx, cp1.dy, cp2.dx, cp2.dy, curr.dx, curr.dy);
    }

    fp.addPath(p, Offset.zero);
    fp.lineTo(size.width, size.height);
    fp.lineTo(0, size.height);
    fp.close();

    canvas.drawPath(fp, fillPaint);
    canvas.drawPath(p, paint);
  }

  @override
  bool shouldRepaint(covariant _SparkLinePainter oldDelegate) => oldDelegate.color != color;
}

class _InvestCard extends StatelessWidget {
  final Color accent;
  final String investTitle;
  final String purityText;
  final bool buyInRupees;
  final TextEditingController amountController;
  final ValueChanged<bool> onBuyInRupeesChanged;
  final void Function(int amount) onQuickAmount;
  final bool hasAmount;

  const _InvestCard({
    required this.accent,
    required this.investTitle,
    required this.purityText,
    required this.buyInRupees,
    required this.amountController,
    required this.onBuyInRupeesChanged,
    required this.onQuickAmount,
    required this.hasAmount,
  });

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      padding: const EdgeInsets.all(12),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TabBar(
              labelColor: accent,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: accent,
              tabs: const [
                Tab(text: 'One Time'),
                Tab(text: 'SIP'),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 270,
              child: TabBarView(
                children: [
                  _OneTimeTab(
                    accent: accent,
                    buyInRupees: buyInRupees,
                    amountController: amountController,
                    onBuyInRupeesChanged: onBuyInRupeesChanged,
                    onQuickAmount: onQuickAmount,
                    hasAmount: hasAmount,
                    investTitle: investTitle,
                    purityText: purityText,
                  ),
                  _SipTab(accent: accent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OneTimeTab extends StatelessWidget {
  final Color accent;
  final bool buyInRupees;
  final TextEditingController amountController;
  final ValueChanged<bool> onBuyInRupeesChanged;
  final void Function(int amount) onQuickAmount;
  final bool hasAmount;
  final String investTitle;
  final String purityText;

  const _OneTimeTab({
    required this.accent,
    required this.buyInRupees,
    required this.amountController,
    required this.onBuyInRupeesChanged,
    required this.onQuickAmount,
    required this.hasAmount,
    required this.investTitle,
    required this.purityText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              investTitle,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () => onBuyInRupeesChanged(true),
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: buyInRupees,
                        activeColor: accent,
                        onChanged: (v) => onBuyInRupeesChanged(v ?? true),
                      ),
                      const Text('Buy In Rupees'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () => onBuyInRupeesChanged(false),
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: buyInRupees,
                        activeColor: accent,
                        onChanged: (v) => onBuyInRupeesChanged(v ?? false),
                      ),
                      const Text('Buy In Grams'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: buyInRupees ? '₹ ' : '',
              hintText: buyInRupees ? 'Enter amount' : 'Enter grams',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
          ),
          const SizedBox(height: 6),
          const Text('Min. ₹1', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickAmountChip(label: '+ ₹100', onTap: () => onQuickAmount(100)),
              _QuickAmountChip(label: '+ ₹500', onTap: () => onQuickAmount(500)),
              _QuickAmountChip(label: '+ ₹1000', onTap: () => onQuickAmount(1000)),
              _QuickAmountChip(label: '+ ₹5000', onTap: () => onQuickAmount(5000)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount Payable', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    SizedBox(height: 2),
                    Text('₹0.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                    SizedBox(height: 2),
                    Text('(Incl. 3% GST)', style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAmount ? accent : accent.withValues(alpha: 0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    onPressed: hasAmount ? () {} : null,
                    child: const Text('Buy Now', style: TextStyle(fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Note: $purityText',
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _QuickAmountChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _QuickAmountChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Color(0xFFE5E7EB)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      ),
      child: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}

class _SipTab extends StatelessWidget {
  final Color accent;
  const _SipTab({required this.accent});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 14, 4, 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Set up SIP',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Auto-invest on a schedule. (UI placeholder)',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _Field(label: 'Frequency', value: 'Monthly'),
          const SizedBox(height: 12),
          _Field(label: 'Date', value: '5th'),
          const SizedBox(height: 12),
          _Field(label: 'Amount', value: '₹500'),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text('Start SIP', style: TextStyle(fontWeight: FontWeight.w800)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String value;
  const _Field({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(width: 6),
          const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _InfoIconsRow extends StatelessWidget {
  final Color accent;
  const _InfoIconsRow({required this.accent});

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          const Text(
            'Safe, secure and transparent',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _InfoIcon(
                icon: Icons.thumb_up_alt_outlined,
                title: '99.99%',
                subtitle: 'Purity',
                accent: accent,
              ),
              _InfoIcon(
                icon: Icons.shield_outlined,
                title: 'Low-Risk',
                subtitle: 'Investment',
                accent: accent,
              ),
              _InfoIcon(
                icon: Icons.verified_user_outlined,
                title: 'Safe &',
                subtitle: 'Secure',
                accent: accent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoIcon extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  const _InfoIcon({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: accent),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ShopSection extends StatelessWidget {
  const _ShopSection();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Shop for Gold Coins & Jewellery', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _MiniFeatureCard('Guaranteed Purity\nWith BIS Hallmark', Icons.verified_outlined)),
              SizedBox(width: 10),
              Expanded(child: _MiniFeatureCard('Tamper-Proof\nPackaging & Secure\nDelivery', Icons.local_shipping_outlined)),
              SizedBox(width: 10),
              Expanded(child: _MiniFeatureCard('Simple & Transparent\nProcess', Icons.thumb_up_alt_outlined)),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _ProductCard(title: 'Link Chain', meta: '7.0gms | 22K', price: '₹1,05,355.47')),
              SizedBox(width: 10),
              Expanded(child: _ProductCard(title: 'Ring', meta: '5.0gms | 22K', price: '₹75,137.23')),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('Shop Now', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primaryBlue),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {},
                  child: const Text('Go To Cart', style: TextStyle(fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniFeatureCard extends StatelessWidget {
  final String text;
  final IconData icon;
  const _MiniFeatureCard(this.text, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryBlue),
          const SizedBox(height: 6),
          Text(
            text,
            style: const TextStyle(fontSize: 10, color: AppColors.textSecondary, height: 1.2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String title;
  final String meta;
  final String price;

  const _ProductCard({
    required this.title,
    required this.meta,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Container(
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFC107), size: 30),
            ),
          ),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          Text(meta, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          const SizedBox(height: 8),
          Text(price, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () {},
            child: const Text('Add To Cart'),
          ),
        ],
      ),
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Frequently Asked Questions', style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          const _FaqTile(q: 'What is Digital Gold?', a: 'Digital gold lets you buy and hold gold online in small amounts.'),
          const _FaqTile(q: 'Can I convert to coins or jewellery?', a: 'Yes, conversion can be supported via partner fulfilment.'),
          const _FaqTile(q: 'What is the purity?', a: 'Gold: 24K 99.9%. Silver: 999 99.9% (as applicable).'),
          const SizedBox(height: 10),
          Center(
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.arrow_forward_rounded),
              label: const Text('View All'),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FaqTile extends StatelessWidget {
  final String q;
  final String a;
  const _FaqTile({required this.q, required this.a});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      childrenPadding: const EdgeInsets.only(bottom: 10),
      title: Text(q, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(a, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ),
      ],
    );
  }
}

class _TrendsSection extends StatelessWidget {
  const _TrendsSection();

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Read On The Latest Trends', style: TextStyle(fontWeight: FontWeight.w800)),
          SizedBox(height: 10),
          _TrendTile('Digital Gold is for all financial goals'),
          _TrendTile('Top 5 benefits of investing in Digital Gold'),
          _TrendTile('How to grow your gold with Digital Gold SIP?'),
        ],
      ),
    );
  }
}

class _TrendTile extends StatelessWidget {
  final String text;
  const _TrendTile(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const _TrendIcon(),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Color(0xFFF3F4F6),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Icon(Icons.article_outlined, color: AppColors.primaryBlue, size: 18),
    );
  }
}

class _PoweredByFooter extends StatelessWidget {
  const _PoweredByFooter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Powered by Marg Metals Partner', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        SizedBox(height: 6),
        Icon(Icons.verified_rounded, color: AppColors.textSecondary),
      ],
    );
  }
}

