import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/card_repay_api_exceptions.dart';
import '../providers/card_repay_provider.dart';
import 'pay_your_credit_card_bill_page.dart';

/// Add a saved credit-card account (`POST /utilities/credit-card/accounts`).
class AddBankCreditCardPage extends ConsumerStatefulWidget {
  const AddBankCreditCardPage({super.key});

  @override
  ConsumerState<AddBankCreditCardPage> createState() => _AddBankCreditCardPageState();
}

class _AddBankCreditCardPageState extends ConsumerState<AddBankCreditCardPage> {
  bool _saving = false;

  final _last4Controller = TextEditingController();
  final _mobileController = TextEditingController(text: '7036294243');
  final _nickNameController = TextEditingController();

  bool _mobileEditable = false;
  String? _selectedRelation;

  @override
  void dispose() {
    _last4Controller.dispose();
    _mobileController.dispose();
    _nickNameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final biller = ref.read(selectedCardRepayBillerProvider);
    if (biller == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select a bank first in Credit Card Repay')),
      );
      return;
    }

    final last4 = _last4Controller.text.trim();
    if (last4.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter last 4 digits of your credit card')),
      );
      return;
    }

    final mobile = _mobileController.text.trim();
    if (mobile.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid bank linked mobile number')),
      );
      return;
    }

    final relationLabel = switch (_selectedRelation) {
      null => 'My card',
      'Custom' => (_nickNameController.text.trim().isNotEmpty ? _nickNameController.text.trim() : 'My card'),
      _ => _selectedRelation!,
    };

    setState(() => _saving = true);
    try {
      await ref.read(cardRepayRepositoryProvider).createAccount(
            accountNumber: last4,
            label: relationLabel,
            billerId: biller.id,
            billerName: biller.name,
            consumerName: mobile,
            isAutopay: false,
          );
      ref.invalidate(cardRepaySavedAccountsProvider);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<void>(builder: (_) => const PayYourCreditCardBillPage()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cardRepayApiUserMessage(e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  bool get _canProceed {
    final last4 = _last4Controller.text.trim();
    final mobile = _mobileController.text.trim();
    return last4.length == 4 && mobile.length >= 10 && !_saving;
  }

  @override
  Widget build(BuildContext context) {
    final biller = ref.watch(selectedCardRepayBillerProvider);
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Add ${biller?.name ?? ''} Credit Card'.trim()),
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimary,
        actions: [
          TextButton(onPressed: () {}, child: const Text('View All')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_rounded, color: AppColors.primaryBlue, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Unlock ₹40 cashback for FASTag',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text('View All')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 160,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1B2A8A), Color(0xFF7B3FE4)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(16),
            child: Stack(
              children: [
                Positioned(
                  right: -40,
                  top: -40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.credit_card_rounded, color: Colors.white, size: 28),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'SECURE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: const Text(
                    'Credit Card',
                    style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w700),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 0,
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _last4Controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(4)],
            decoration: const InputDecoration(
              hintText: 'Enter last 4 digits of your credit card',
              labelText: 'Last 4 digits',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _mobileController,
            keyboardType: TextInputType.phone,
            readOnly: !_mobileEditable,
            decoration: InputDecoration(
              labelText: 'Bank Linked Mobile Number',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(
                  _mobileEditable ? Icons.check_circle_rounded : Icons.edit_rounded,
                  color: AppColors.primaryBlue,
                ),
                onPressed: () {
                  setState(() => _mobileEditable = !_mobileEditable);
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Select relation',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ChoiceChip(
                label: const Text('Mom'),
                selected: _selectedRelation == 'Mom',
                onSelected: (_) => setState(() => _selectedRelation = 'Mom'),
              ),
              ChoiceChip(
                label: const Text('Dad'),
                selected: _selectedRelation == 'Dad',
                onSelected: (_) => setState(() => _selectedRelation = 'Dad'),
              ),
              ChoiceChip(
                label: const Text('Spouse'),
                selected: _selectedRelation == 'Spouse',
                onSelected: (_) => setState(() => _selectedRelation = 'Spouse'),
              ),
              ActionChip(
                label: const Text('+ Add NickName'),
                backgroundColor: _selectedRelation == 'Custom'
                    ? AppColors.primaryBlue.withValues(alpha: 0.12)
                    : null,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: AppColors.primaryBlue.withValues(alpha: 0.7),
                  ),
                ),
                onPressed: () => setState(() => _selectedRelation = 'Custom'),
              ),
            ],
          ),
          if (_selectedRelation == 'Custom') ...[
            const SizedBox(height: 10),
            TextField(
              controller: _nickNameController,
              decoration: const InputDecoration(
                labelText: 'NickName',
                border: OutlineInputBorder(),
              ),
            ),
          ],
          const SizedBox(height: 20),
          Text(
            'By proceeding you allow Paytm to fetch bills & send reminders',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _canProceed ? _save : null,
            child: _saving
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Proceed'),
          ),
        ],
      ),
    );
  }
}
