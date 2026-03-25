import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';

/// Meal selection tab with food items, filter chips, and add buttons.
class FlightMealSelectionTab extends StatefulWidget {
  const FlightMealSelectionTab({
    super.key,
    required this.passengerName,
    required this.routeLabel,
    required this.selectedMeal,
    required this.onMealSelected,
  });

  final String passengerName;
  final String routeLabel;
  final String? selectedMeal;
  final void Function(String mealName, int price) onMealSelected;

  @override
  State<FlightMealSelectionTab> createState() => _FlightMealSelectionTabState();
}

class _FlightMealSelectionTabState extends State<FlightMealSelectionTab> {
  int _filterIndex = 0; // 0 = Show All, 1 = Veg, 2 = Non-Veg

  static const _meals = [
    _MealItem(
      name: 'Chicken Junglee Sandwich',
      originalPrice: 400,
      price: 250,
      badge: 'Bestseller',
      isVeg: false,
      icon: Icons.lunch_dining_rounded,
    ),
    _MealItem(
      name: 'Shondesh Tiramisu',
      originalPrice: 250,
      price: 125,
      isVeg: true,
      icon: Icons.cake_rounded,
    ),
    _MealItem(
      name: 'Feta Vegetable Salad with Vinaigrette',
      originalPrice: 350,
      price: 200,
      isVeg: true,
      icon: Icons.restaurant_rounded,
    ),
    _MealItem(
      name: 'Paneer Tikka Wrap',
      originalPrice: 300,
      price: 180,
      isVeg: true,
      icon: Icons.lunch_dining_rounded,
    ),
    _MealItem(
      name: 'Chicken Biryani',
      originalPrice: 450,
      price: 280,
      badge: 'Popular',
      isVeg: false,
      icon: Icons.rice_bowl_rounded,
    ),
    _MealItem(
      name: 'Masala Dosa',
      originalPrice: 250,
      price: 150,
      isVeg: true,
      icon: Icons.breakfast_dining_rounded,
    ),
    _MealItem(
      name: 'Chocolate Brownie',
      originalPrice: 200,
      price: 120,
      isVeg: true,
      icon: Icons.cookie_rounded,
    ),
  ];

  List<_MealItem> get _filteredMeals {
    if (_filterIndex == 1) return _meals.where((m) => m.isVeg).toList();
    if (_filterIndex == 2) return _meals.where((m) => !m.isVeg).toList();
    return _meals;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final meals = _filteredMeals;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select your inflight meals',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Filter chips
              Row(
                children: [
                  _FilterChip(
                    label: 'Show All',
                    selected: _filterIndex == 0,
                    onTap: () => setState(() => _filterIndex = 0),
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Veg',
                    selected: _filterIndex == 1,
                    onTap: () => setState(() => _filterIndex = 1),
                    icon: Icons.circle,
                    iconColor: AppColors.accentGreen,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Non-Veg',
                    selected: _filterIndex == 2,
                    onTap: () => setState(() => _filterIndex = 2),
                    icon: Icons.circle,
                    iconColor: AppColors.accentRed,
                    colorScheme: colorScheme,
                    textTheme: textTheme,
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Route + passenger
              Row(
                children: [
                  Icon(Icons.flight_rounded, size: 18, color: colorScheme.primary),
                  const SizedBox(width: 6),
                  Text(
                    widget.routeLabel,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryBlue.withValues(alpha: 0.5),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.passengerName,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      widget.selectedMeal ?? 'Add Meal',
                      style: textTheme.bodySmall?.copyWith(
                        color: widget.selectedMeal != null
                            ? AppColors.accentGreen
                            : AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // Meal list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: meals.length + 1,
            separatorBuilder: (_, __) => Divider(
              color: colorScheme.outline.withValues(alpha: 0.12),
              height: 1,
            ),
            itemBuilder: (context, i) {
              if (i == meals.length) {
                return _OfferBanner(colorScheme: colorScheme, textTheme: textTheme);
              }
              final meal = meals[i];
              final isSelected = widget.selectedMeal == meal.name;
              return _MealRow(
                meal: meal,
                isSelected: isSelected,
                onAdd: () => widget.onMealSelected(meal.name, meal.price),
                colorScheme: colorScheme,
                textTheme: textTheme,
              );
            },
          ),
        ),
      ],
    );
  }
}

// ── Filter chip ──

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
    this.iconColor,
    required this.colorScheme,
    required this.textTheme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? iconColor;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.primaryBlue
                : colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 10, color: selected ? Colors.white : iconColor),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: textTheme.labelMedium?.copyWith(
                color: selected ? Colors.white : colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Meal row ──

class _MealRow extends StatelessWidget {
  const _MealRow({
    required this.meal,
    required this.isSelected,
    required this.onAdd,
    required this.colorScheme,
    required this.textTheme,
  });

  final _MealItem meal;
  final bool isSelected;
  final VoidCallback onAdd;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Food icon placeholder
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: [
                Center(child: Icon(meal.icon, size: 32, color: AppColors.accentOrange)),
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: meal.isVeg ? AppColors.accentGreen : AppColors.accentRed,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: meal.isVeg ? AppColors.accentGreen : AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (meal.badge != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      meal.badge!,
                      style: textTheme.labelSmall?.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                      ),
                    ),
                  ),
                Text(
                  meal.name,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '₹${meal.originalPrice}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${meal.price}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.accentGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Add / Added button
          isSelected
              ? Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.accentGreen),
                  ),
                  child: Text(
                    'Added',
                    style: textTheme.labelMedium?.copyWith(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.primaryBlue.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, size: 14, color: AppColors.primaryBlue),
                        Text(
                          'Add',
                          style: textTheme.labelMedium?.copyWith(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

// ── Offer banner ──

class _OfferBanner extends StatelessWidget {
  const _OfferBanner({required this.colorScheme, required this.textTheme});

  final ColorScheme colorScheme;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.accentGreen.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.local_offer_rounded, size: 18, color: AppColors.accentGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Limited time offer',
                  style: textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  '50% off on all Air India Express meals',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Meal item data ──

class _MealItem {
  const _MealItem({
    required this.name,
    required this.originalPrice,
    required this.price,
    this.badge,
    required this.isVeg,
    required this.icon,
  });

  final String name;
  final int originalPrice;
  final int price;
  final String? badge;
  final bool isVeg;
  final IconData icon;
}
