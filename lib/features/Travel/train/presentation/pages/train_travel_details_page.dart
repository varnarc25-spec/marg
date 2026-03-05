import 'package:flutter/material.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../data/train_list_data.dart';
import 'train_booking_details_page.dart';

/// Travel Details page: shown after tapping a bookable class (SL, 2S, etc.) on train results.
/// Includes train summary, cancellation notice, Free Cancellation section, IRCTC User ID,
/// Traveller Details, Contact Information, Additional Preferences, GST toggle,
/// Travel Insurance & Refund policy checkboxes, Proceed to Book. Uses app theme.
class TrainTravelDetailsPage extends StatefulWidget {
  const TrainTravelDetailsPage({
    super.key,
    required this.train,
    required this.selectedClass,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.dateLabel,
  });

  final TrainResultItem train;
  final TrainClassOption selectedClass;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final String dateLabel;

  @override
  State<TrainTravelDetailsPage> createState() => _TrainTravelDetailsPageState();
}

class _TrainTravelDetailsPageState extends State<TrainTravelDetailsPage> {
  bool _freeCancellation = true;
  bool _travelInsurance = true;
  bool _agreeRefundPolicy = true;
  bool _gstEnabled = false;
  bool _additionalPrefExpanded = false;
  final _mobileController = TextEditingController(text: '7036294243');
  final _emailController = TextEditingController(text: 'Sasikumaryadav240@gmail.com');
  final List<bool> _travellerSelected = [false, false, false];

  static const _travellers = [
    ('Shasi Kumar', 'Adult • Male • 21 yr • No pref'),
    ('Lohith R', 'Adult • Male • 22 yr • No pref'),
    ('Sanju', 'Adult • Male • 21 yr • No pref'),
    ('Sushmanth', 'Adult • Male • 20 yr • No pref'),
  ];

  @override
  void dispose() {
    _mobileController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return '₹$s';
    final buf = StringBuffer();
    var i = 0;
    final len = s.length;
    while (i < len) {
      if (i > 0) buf.write(',');
      final end = i + 3 > len ? len : i + 3;
      buf.write(s.substring(i, end));
      i = end;
    }
    return '₹${buf.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Travel Details',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                24 + MediaQuery.paddingOf(context).bottom,
              ),
              children: [
                // Train summary card
                _TrainSummaryCard(
                  train: widget.train,
                  fromCode: widget.fromCode,
                  fromName: widget.fromName,
                  toCode: widget.toCode,
                  toName: widget.toName,
                  selectedClass: widget.selectedClass,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 16),
                // Free Cancellation section
                _FreeCancellationSection(
                  freeCancellation: _freeCancellation,
                  onChanged: (v) => setState(() => _freeCancellation = v),
                  pricePerPerson: 28,
                  originalPrice: 37,
                  refundAmount: widget.selectedClass.price,
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                  formatPrice: _formatPrice,
                ),
                const SizedBox(height: 12),
                _CancellationNotice(colorScheme: colorScheme, textTheme: textTheme),
                const SizedBox(height: 20),
                // IRCTC User ID card
                _IrctcUserCard(
                  colorScheme: colorScheme,
                  textTheme: textTheme,
                ),
                const SizedBox(height: 20),
                // Traveller Details
                Text(
                  'Traveller Details',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose from Saved List or Add New Traveller.',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_travellers.length, (i) {
                  final t = _travellers[i];
                  final selected = i < _travellerSelected.length && _travellerSelected[i];
                  return _TravellerTile(
                    name: t.$1,
                    details: t.$2,
                    selected: selected,
                    onChanged: (v) {
                      setState(() {
                        while (_travellerSelected.length <= i) {
                          _travellerSelected.add(false);
                        }
                        _travellerSelected[i] = v ?? false;
                      });
                    },
                    onMenuTap: () {},
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  );
                }),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: colorScheme.primary,
                      ),
                      label: Text(
                        'View All',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.add_rounded, size: 20, color: colorScheme.primary),
                      label: Text(
                        'Add New Traveller',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Contact Information
                Text(
                  'Contact Information',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your ticket will be sent to below mobile number and email ID',
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _mobileController,
                  decoration: InputDecoration(
                    hintText: 'Enter Mobile Number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter Email Address',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                // Additional Preferences
                InkWell(
                  onTap: () => setState(() => _additionalPrefExpanded = !_additionalPrefExpanded),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          'Additional Preferences',
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'optional',
                          style: textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _additionalPrefExpanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // GST details
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Enter GST details to claim tax benefits',
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'optional',
                            style: textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _gstEnabled,
                      onChanged: (v) => setState(() => _gstEnabled = v),
                      activeColor: colorScheme.primary,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Travel Insurance
                CheckboxListTile(
                  value: _travelInsurance,
                  onChanged: (v) => setState(() => _travelInsurance = v ?? true),
                  activeColor: colorScheme.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Travel Insurance charges: Rs. 0.45/person',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  secondary: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View T&C',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Refund policy
                CheckboxListTile(
                  value: _agreeRefundPolicy,
                  onChanged: (v) => setState(() => _agreeRefundPolicy = v ?? true),
                  activeColor: colorScheme.primary,
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'I agree to the cancellation and Refund Policy',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                  secondary: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      'View',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed: () {
                    final selectedIndex = _travellerSelected.indexOf(true);
                    final idx = selectedIndex >= 0 ? selectedIndex : 0;
                    final t = _travellers[idx];
                    final name = t.$1;
                    final details = t.$2;
                    // Show as "Shasi Kumar (21 • M)" and "No preference"
                    final ageMatch = RegExp(r'(\d+)\s*yr').firstMatch(details);
                    final genderMatch = RegExp(r'(Male|Female)').firstMatch(details);
                    final age = ageMatch?.group(1) ?? '21';
                    final gender = genderMatch?.group(1)?.substring(0, 1) ?? 'M';
                    final passengerName = '$name ($age • $gender)';
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => TrainBookingDetailsPage(
                          train: widget.train,
                          selectedClass: widget.selectedClass,
                          fromCode: widget.fromCode,
                          fromName: widget.fromName,
                          toCode: widget.toCode,
                          toName: widget.toName,
                          passengerName: passengerName,
                          passengerDetails: 'No preference',
                          email: _emailController.text.trim().isEmpty
                              ? 'Sasikumaryadav240@gmail.com'
                              : _emailController.text.trim(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Proceed to Book'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrainSummaryCard extends StatelessWidget {
  const _TrainSummaryCard({
    required this.train,
    required this.fromCode,
    required this.fromName,
    required this.toCode,
    required this.toName,
    required this.selectedClass,
    required this.colorScheme,
    required this.textTheme,
  });

  final TrainResultItem train;
  final String fromCode;
  final String fromName;
  final String toCode;
  final String toName;
  final TrainClassOption selectedClass;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${train.trainName} (${train.trainNumber})',
              style: textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${train.departureTime}, ${train.departureDate}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$fromCode ($fromName)',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Change Boarding Station',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    children: [
                      Text(
                        train.duration,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${train.arrivalDate}, ${train.arrivalTime}',
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$toCode ($toName)',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedClass.classCode}, General Quota',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Curr AVL 463',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FreeCancellationSection extends StatelessWidget {
  const _FreeCancellationSection({
    required this.freeCancellation,
    required this.onChanged,
    required this.pricePerPerson,
    required this.originalPrice,
    required this.refundAmount,
    required this.colorScheme,
    required this.textTheme,
    required this.formatPrice,
  });

  final bool freeCancellation;
  final ValueChanged<bool> onChanged;
  final int pricePerPerson;
  final int originalPrice;
  final int refundAmount;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final String Function(int) formatPrice;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withValues(alpha: 0.08),
              colorScheme.surface,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Get Full Train Fare Refund on cancellation',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, size: 16, color: Colors.white),
                        const SizedBox(width: 6),
                        Text(
                          'FREE Cancellation',
                          style: textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Only at ${formatPrice(originalPrice)} ${formatPrice(pricePerPerson)} per person',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurface,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.textSecondary,
                ),
              ),
              Text(
                '${formatPrice(pricePerPerson)} per person',
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, size: 18, color: AppColors.accentGreen),
                    const SizedBox(width: 8),
                    Text(
                      'Enjoy 25% discount on Free Cancellation',
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              RadioListTile<bool>(
                value: true,
                groupValue: freeCancellation,
                onChanged: (v) => onChanged(true),
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Yes, I want Free Cancellation',
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentGreen),
                          const SizedBox(width: 6),
                          Text(
                            'Get full refund of ${formatPrice(refundAmount)}',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Know more',
                              style: textTheme.labelSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentGreen),
                          const SizedBox(width: 6),
                          Text(
                            '₹0 Cancellation fee',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accentGreen),
                          const SizedBox(width: 6),
                          Text(
                            'Instant full refund',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              RadioListTile<bool>(
                value: false,
                groupValue: freeCancellation,
                onChanged: (v) => onChanged(false),
                activeColor: colorScheme.primary,
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'No, I don\'t want Free Cancellation',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CancellationNotice extends StatelessWidget {
  const _CancellationNotice({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.info_outline_rounded,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Valid on cancellation upto 30 minutes before scheduled departure',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _IrctcUserCard extends StatelessWidget {
  const _IrctcUserCard({
    required this.colorScheme,
    required this.textTheme,
  });

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'IRCTC User ID',
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Change',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'shasi4243',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.train_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'IRCTC Password will be required to complete booking.',
                    style: textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot?',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TravellerTile extends StatelessWidget {
  const _TravellerTile({
    required this.name,
    required this.details,
    required this.selected,
    required this.onChanged,
    required this.onMenuTap,
    required this.colorScheme,
    required this.textTheme,
  });

  final String name;
  final String details;
  final bool selected;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onMenuTap;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: CheckboxListTile(
        value: selected,
        onChanged: onChanged,
        activeColor: colorScheme.primary,
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          name,
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          details,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        secondary: IconButton(
          icon: const Icon(Icons.more_vert_rounded),
          onPressed: onMenuTap,
        ),
      ),
    );
  }
}
