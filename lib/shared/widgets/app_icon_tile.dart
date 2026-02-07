import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// App-wide styled icon tile: rounded square with optional label and drop shadow.
///
/// Matches the design: light pastel background, white icon centered,
/// dark label below, subtle shadow. Use for feature icons, social icons, etc.
class AppIconTile extends StatelessWidget {
  /// Icon to show (drawn in [iconColor] on [backgroundColor]).
  final IconData? icon;

  /// Custom child instead of [icon] (e.g. brand logo image or text).
  /// When set, [icon] is ignored.
  final Widget? child;

  /// Label shown below the icon container. Omit for icon-only.
  final String? label;

  /// Size of the rounded square container.
  final double size;

  /// Background color of the rounded square. Default [AppColors.iconTileBackground].
  final Color? backgroundColor;

  /// Color of the icon. Default [Colors.white]. Ignored if [child] is set.
  final Color? iconColor;

  /// Corner radius as fraction of [size] (e.g. 0.25 = 25%). Default ~0.25 (squircle-like).
  final double cornerRadiusFraction;

  /// Optional tap callback. When null, the tile is non-interactive.
  final VoidCallback? onTap;

  const AppIconTile({
    super.key,
    this.icon,
    this.child,
    this.label,
    this.size = 56,
    this.backgroundColor,
    this.iconColor,
    this.cornerRadiusFraction = 0.25,
    this.onTap,
  }) : assert(icon != null || child != null, 'Provide either icon or child');

  /// Soft drop shadow for the icon container.
  static List<BoxShadow> get _containerShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          spreadRadius: 0,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 4,
          spreadRadius: 0,
          offset: const Offset(0, 1),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.iconTileBackground;
    final radius = size * cornerRadiusFraction;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: _containerShadow,
          ),
          child: Center(
            child: child ??
                (icon != null
                    ? Icon(
                        icon,
                        size: size * 0.5,
                        color: iconColor ?? Colors.white,
                      )
                    : const SizedBox.shrink()),
          ),
        ),
        if (label != null && label!.isNotEmpty) ...[
          SizedBox(height: size * 0.14),
          Text(
            label!,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }
    return content;
  }
}
