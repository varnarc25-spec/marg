import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// Invest card used on Buy Gold / Buy Silver screens.
/// Shows two tabs: One Time and SIP, and automatically sizes to fit content.
class InvestCard extends StatefulWidget {
  final Color accent;
  final String investTitle;
  final String purityText;
  final bool buyInRupees;
  final TextEditingController amountController;
  final ValueChanged<bool> onBuyInRupeesChanged;
  final void Function(int amount) onQuickAmount;
  final bool hasAmount;

  const InvestCard({
    super.key,
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
  State<InvestCard> createState() => _InvestCardState();
}

class _InvestCardState extends State<InvestCard>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accent = widget.accent;
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            labelColor: accent,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: accent,
            tabs: const [
              Tab(text: 'One Time'),
              Tab(text: 'SIP'),
            ],
          ),
          const SizedBox(height: 10),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: IndexedStack(
              index: _tabController.index,
              children: [
                _OneTimeTab(
                  accent: accent,
                  buyInRupees: widget.buyInRupees,
                  amountController: widget.amountController,
                  onBuyInRupeesChanged: widget.onBuyInRupeesChanged,
                  onQuickAmount: widget.onQuickAmount,
                  hasAmount: widget.hasAmount,
                  investTitle: widget.investTitle,
                  purityText: widget.purityText,
                ),
                _SipTab(accent: accent),
              ],
            ),
          ),
        ],
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Min. ₹1',
            style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _QuickAmountChip(
                label: '+ ₹100',
                onTap: () => onQuickAmount(100),
              ),
              _QuickAmountChip(
                label: '+ ₹500',
                onTap: () => onQuickAmount(500),
              ),
              _QuickAmountChip(
                label: '+ ₹1000',
                onTap: () => onQuickAmount(1000),
              ),
              _QuickAmountChip(
                label: '+ ₹5000',
                onTap: () => onQuickAmount(5000),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount Payable',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '₹0.00',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '(Incl. 3% GST)',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: hasAmount
                          ? accent
                          : accent.withValues(alpha: 0.25),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    onPressed: hasAmount ? () {} : null,
                    child: const Text(
                      'Buy Now',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Note: $purityText',
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
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
          const _Field(label: 'Frequency', value: 'Monthly'),
          const SizedBox(height: 12),
          const _Field(label: 'Date', value: '5th'),
          const SizedBox(height: 12),
          const _Field(label: 'Amount', value: '₹500'),
          const SizedBox(height: 16),
          SizedBox(
            height: 44,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text(
                'Start SIP',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
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
            child: Text(
              label,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(width: 6),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}

