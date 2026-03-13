import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/card_repay_data.dart';
import '../providers/card_repay_provider.dart';
import 'pay_your_credit_card_bill_page.dart';

/// Add [bankName] Credit Card: last 4 digits, mobile number, relationship tags, Proceed.
/// On Proceed adds card and navigates to Pay Your Credit Card Bill (saved cards).
class AddBankCreditCardPage extends ConsumerStatefulWidget {
  const AddBankCreditCardPage({super.key, required this.bankName});

  final String bankName;

  @override
  ConsumerState<AddBankCreditCardPage> createState() =>
      _AddBankCreditCardPageState();
}

class _AddBankCreditCardPageState extends ConsumerState<AddBankCreditCardPage> {
  final _lastFourController = TextEditingController();
  final _mobileController = TextEditingController(text: '7036294243');
  String? _selectedRelation;

  @override
  void dispose() {
    _lastFourController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    final last4 = _lastFourController.text.trim();
    final mobile = _mobileController.text.trim();
    return last4.length == 4 && mobile.length >= 10;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withValues(
        alpha: 0.3,
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: null,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const PayYourCreditCardBillPage(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        children: [
          const SizedBox(height: 8),
          Text(
            'Add ${widget.bankName} Credit Card',
            style: textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 4,
            width: 48,
            decoration: BoxDecoration(
              color: colorScheme.secondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          _CardVisual(bankName: widget.bankName, colorScheme: colorScheme),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter last 4 digits of your credit card',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _lastFourController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Enter last 4 digits of your credit card',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: colorScheme.onSecondary),
                      ),
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Eg: Enter 1234 for card XXXX XXXX XX23 1234',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Bank Linked Mobile Number',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mobileController,
                    keyboardType: TextInputType.phone,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        Icons.person_outline_rounded,
                        color: colorScheme.onSurfaceVariant,
                        size: 22,
                      ),
                    ),
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Relationship / Nickname',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 8,
                    children: [
                      _RelationChip(
                        label: 'Mom',
                        selected: _selectedRelation == 'Mom',
                        onTap: () => setState(() => _selectedRelation = 'Mom'),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      _RelationChip(
                        label: 'Dad',
                        selected: _selectedRelation == 'Dad',
                        onTap: () => setState(() => _selectedRelation = 'Dad'),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      _RelationChip(
                        label: 'Spouse',
                        selected: _selectedRelation == 'Spouse',
                        onTap: () =>
                            setState(() => _selectedRelation = 'Spouse'),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                      _RelationChip(
                        label: '+ Add NickName',
                        selected: false,
                        isAdd: true,
                        onTap: () =>
                            setState(() => _selectedRelation = 'Custom'),
                        colorScheme: colorScheme,
                        textTheme: textTheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'By proceeding you allow Paytm to fetch bills & send reminders',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: _canProceed
                  ? () {
                      final last4 = _lastFourController.text.trim();
                      ref
                          .read(savedCreditCardsProvider.notifier)
                          .add(
                            SavedCreditCard(
                              bankName: widget.bankName,
                              lastFourDigits: last4,
                              network: 'Mastercard',
                            ),
                          );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (_) => const PayYourCreditCardBillPage(),
                        ),
                        (route) => route.isFirst,
                      );
                    }
                  : null,
              style: FilledButton.styleFrom(
                backgroundColor: _canProceed
                    ? colorScheme.primary
                    : colorScheme.surfaceContainerHighest,
                foregroundColor: _canProceed
                    ? colorScheme.onPrimary
                    : colorScheme.onSurfaceVariant,
              ),
              child: const Text('Proceed'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardVisual extends StatelessWidget {
  const _CardVisual({required this.bankName, required this.colorScheme});

  final String bankName;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.85),
            colorScheme.primary.withValues(alpha: 0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      bankName.isNotEmpty ? bankName[0] : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  bankName.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 20,
            bottom: 50,
            child: Icon(
              Icons.sim_card_rounded,
              color: Colors.white54,
              size: 32,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 50,
            child: Icon(
              Icons.credit_card_rounded,
              color: Colors.white24,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationChip extends StatelessWidget {
  const _RelationChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.colorScheme,
    required this.textTheme,
    this.isAdd = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final bool isAdd;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primaryContainer
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(20),
            border: isAdd
                ? Border.all(color: colorScheme.outline.withValues(alpha: 0.5))
                : null,
          ),
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: selected ? colorScheme.primary : colorScheme.onSurface,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
