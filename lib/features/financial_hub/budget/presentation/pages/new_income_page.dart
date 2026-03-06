import 'package:flutter/material.dart';
import '../../data/budget_data.dart';

/// Shows the New income UI as an adjustable bottom sheet (draggable to resize).
Future<void> showNewIncomeSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.35,
      maxChildSize: 0.95,
      builder: (context, scrollController) => _NewIncomeSheetContent(
        scrollController: scrollController,
        onClose: () => Navigator.of(context).pop(),
      ),
    ),
  );
}

/// Content of the New income bottom sheet.
class _NewIncomeSheetContent extends StatefulWidget {
  const _NewIncomeSheetContent({
    required this.scrollController,
    required this.onClose,
  });

  final ScrollController scrollController;
  final VoidCallback onClose;

  @override
  State<_NewIncomeSheetContent> createState() => _NewIncomeSheetContentState();
}

class _NewIncomeSheetContentState extends State<_NewIncomeSheetContent> {
  final _amountController = TextEditingController(text: '0');
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  bool _showCategories = false;
  String? _selectedCategoryName;

  static final List<({String name, IconData icon, Color color})> _categories = [
    (
      name: 'Deposites',
      icon: Icons.savings_rounded,
      color: const Color(0xFFFF9800),
    ),
    (name: 'Salary', icon: Icons.money, color: const Color(0xFF2196F3)),
    (
      name: 'Business',
      icon: Icons.checkroom_rounded,
      color: const Color(0xFFE91E63),
    ),
    (name: 'Savings', icon: Icons.save_rounded, color: const Color(0xFF4CAF50)),
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 8),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Material(
            color: Colors.blueGrey.shade700,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                child: Center(
                  child: Text(
                    'New income',
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: ListView(
              controller: widget.scrollController,
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Material(
                  color: Colors.grey.shade200,
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null)
                        setState(() => _selectedDate = picked);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatDate(_selectedDate),
                            style: textTheme.bodyLarge?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Income Amount",
                        style: textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          label: Text("Amount"),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade400),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade400),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_rounded,
                            size: 20,
                            color: Colors.grey.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Note',
                            style: textTheme.bodyMedium?.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _noteController,
                        decoration: InputDecoration(
                          hintText: 'Add a note',
                          hintStyle: TextStyle(color: Colors.grey.shade500),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          isDense: true,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: Builder(
                      builder: (context) {
                        final list = _categories
                            .where((c) => c.name == _selectedCategoryName)
                            .toList();
                        final selectedCategory = list.isNotEmpty
                            ? list.first
                            : null;
                        final bgColor = selectedCategory != null
                            ? selectedCategory.color.withValues(alpha: 0.2)
                            : Colors.grey.shade300;
                        final fgColor = selectedCategory != null
                            ? selectedCategory.color
                            : Colors.grey.shade700;
                        return TextButton.icon(
                          onPressed: () {
                            setState(() => _showCategories = !_showCategories);
                          },
                          icon: selectedCategory != null
                              ? Icon(
                                  selectedCategory.icon,
                                  size: 22,
                                  color: fgColor,
                                )
                              : Icon(
                                  Icons.category_rounded,
                                  size: 22,
                                  color: fgColor,
                                ),
                          label: Text(
                            _selectedCategoryName ?? 'CHOOSE CATEGORY',
                            style: TextStyle(
                              color: fgColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            backgroundColor: bgColor,
                            foregroundColor: fgColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 20,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                if (_showCategories) ...[
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Select category',
                      style: textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.82,
                      children: _categories.map((c) {
                        final isSelected = _selectedCategoryName == c.name;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategoryName = c.name;
                              _showCategories = false;
                            });
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: c.color.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(14),
                                  border: isSelected
                                      ? Border.all(color: c.color, width: 2)
                                      : null,
                                ),
                                child: Icon(c.icon, size: 28, color: c.color),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c.name,
                                style: textTheme.labelSmall?.copyWith(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_selectedCategoryName != null) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final raw = _amountController.text.trim();
                          final amount = double.tryParse(raw) ?? 0;
                          if (amount <= 0 || _selectedCategoryName == null) {
                            Navigator.of(context).pop();
                            return;
                          }
                          const months = [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ];
                          final dateLabel =
                              '${_selectedDate.day} ${months[_selectedDate.month - 1]}';
                          defaultBudgetTransactions.insert(
                            0,
                            BudgetTransaction(
                              title: _selectedCategoryName!,
                              dateTime: dateLabel,
                              amount: amount,
                              icon: _iconForIncomeCategory(
                                _selectedCategoryName!,
                              ),
                              note: _noteController.text.trim().isEmpty
                                  ? null
                                  : _noteController.text.trim(),
                              date: _selectedDate,
                            ),
                          );
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Add income'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconForIncomeCategory(String name) {
  switch (name) {
    case 'Deposites':
      return Icons.savings_rounded;
    case 'Salary':
      return Icons.attach_money_rounded;
    case 'Business':
      return Icons.storefront_rounded;
    case 'Savings':
      return Icons.savings_rounded;
    default:
      return Icons.more_horiz_rounded;
  }
}

/// Full-page New expense (kept for optional use).
class NewExpensePage extends StatefulWidget {
  const NewExpensePage({super.key});

  @override
  State<NewExpensePage> createState() => _NewExpensePageState();
}

class _NewExpensePageState extends State<NewExpensePage> {
  final _amountController = TextEditingController(text: '0');
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  static const _green = Color(0xFF00C853);

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'New expense',
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: _green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Date row
          Material(
            color: Colors.grey.shade200,
            child: InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _formatDate(_selectedDate),
                      style: textTheme.bodyLarge?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Amount input bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                // VISA / INR
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'VISA',
                        style: textTheme.labelMedium?.copyWith(
                          color: _green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'INR',
                        style: textTheme.bodySmall?.copyWith(color: _green),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    style: textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: '0',
                      hintStyle: TextStyle(color: Colors.white54),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                  onPressed: () {
                    _amountController.clear();
                    _amountController.text = '0';
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          // Note
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 20,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Note',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    hintText: 'Add a note',
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          // Add calculator (replaces full keypad)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: OutlinedButton.icon(
              onPressed: () {
                // Optional: show calculator or secondary action
              },
              icon: const Icon(Icons.calculate_rounded, size: 20),
              label: const Text('Add calculator'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _green,
                side: const BorderSide(color: _green),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const Spacer(),
          // CHOOSE CATEGORY
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.grey.shade700,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('CHOOSE CATEGORY'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
