import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Wraps any input (e.g. [TextField], [TextFormField]) in a pill-shaped white
/// container with a visible drop shadow. Use this when you want the shadow
/// on a custom input that isn't [AppPillInput].
class AppPillInputShadow extends StatelessWidget {
  const AppPillInputShadow({super.key, required this.child});

  final Widget child;

  static const double radius = 28;

  static List<BoxShadow> get shadow => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 16,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 6,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

/// Pill-shaped text field matching the sample style: white background, soft
/// drop shadow, rounded corners, dark text (Mulish). Use [showCheckmark: true]
/// for a success checkmark on the right (e.g. valid email). For password fields,
/// pass [obscureText: true] and [decoration].suffixIcon as an eye/visibility
/// toggle icon.
class AppPillInput extends StatelessWidget {
  const AppPillInput({
    super.key,
    this.controller,
    this.decoration,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.showCheckmark = false,
    this.validator,
    this.autovalidateMode,
  });

  final TextEditingController? controller;
  final InputDecoration? decoration;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool showCheckmark;
  final String? Function(String?)? validator;
  final AutovalidateMode? autovalidateMode;

  static const double _radius = 28;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suffixIcon = showCheckmark
        ? Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Icon(
              Icons.check_rounded,
              color: AppColors.inputText,
              size: 24,
            ),
          )
        : decoration?.suffixIcon;

    final inputDecoration = InputDecoration(
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.accentRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(_radius),
        borderSide: const BorderSide(color: AppColors.accentRed, width: 2),
      ),
      filled: true,
      fillColor: Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintText: decoration?.hintText,
      labelText: decoration?.labelText,
      prefixIcon: decoration?.prefixIcon,
      suffixIcon: suffixIcon,
    ).applyDefaults(theme.inputDecorationTheme);

    final child = TextFormField(
      controller: controller,
      decoration: inputDecoration,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      obscureText: obscureText,
      readOnly: readOnly,
      validator: validator,
      autovalidateMode: autovalidateMode,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: AppColors.inputText,
        fontFamily: theme.textTheme.bodyLarge?.fontFamily,
      ),
    );

    return AppPillInputShadow(
      child: child,
    );
  }
}
