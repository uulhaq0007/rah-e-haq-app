import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../theme.dart';

enum AppButtonVariant {
  /// Teal-to-emerald gradient, the web's `.btn-primary`.
  brand,

  /// Solid amber, the web's `.btn-amber` donate button.
  amber,

  /// Teal outline, the web's `.btn-outline`.
  outline,

  /// Translucent white, for use on the dark hero gradient.
  glass,

  /// Tinted teal background.
  soft,
}

/// Pill-shaped button used throughout the app.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.trailingIcon,
    this.variant = AppButtonVariant.brand,
    this.loading = false,
    this.expand = true,
    this.height = 52,
    this.horizontalPadding = 18,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final IconData? trailingIcon;
  final AppButtonVariant variant;
  final bool loading;
  final bool expand;
  final double height;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final enabled = onPressed != null && !loading;

    final Color foreground = switch (variant) {
      AppButtonVariant.brand ||
      AppButtonVariant.amber ||
      AppButtonVariant.glass => Colors.white,
      AppButtonVariant.outline || AppButtonVariant.soft => palette.brand,
    };

    final decoration = switch (variant) {
      AppButtonVariant.brand => BoxDecoration(
        gradient: AppColors.brandGradient,
        borderRadius: BorderRadius.circular(height),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.32),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      AppButtonVariant.amber => BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(height),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      AppButtonVariant.outline => BoxDecoration(
        borderRadius: BorderRadius.circular(height),
        border: Border.all(
          color: palette.brand.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      AppButtonVariant.glass => BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(height),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.32),
          width: 1.5,
        ),
      ),
      AppButtonVariant.soft => BoxDecoration(
        color: palette.brandSoft,
        borderRadius: BorderRadius.circular(height),
      ),
    };

    final labelStyle = context.text.labelLarge?.copyWith(color: foreground);

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: foreground,
            ),
          )
        else if (icon != null)
          Icon(icon, size: 19, color: foreground),
        if (loading || icon != null) const SizedBox(width: 8),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label, style: labelStyle, maxLines: 1),
          ),
        ),
        if (trailingIcon != null) ...[
          const SizedBox(width: 8),
          Icon(trailingIcon, size: 18, color: foreground),
        ],
      ],
    );

    final button = AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: onPressed == null ? 0.5 : 1,
      child: DecoratedBox(
        decoration: decoration,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: const StadiumBorder(),
            splashColor: foreground.withValues(alpha: 0.12),
            child: SizedBox(
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(child: content),
              ),
            ),
          ),
        ),
      ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}

/// Round translucent icon button for the hero headers.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white.withValues(alpha: 0.12),
        shape: CircleBorder(
          side: BorderSide(color: Colors.white.withValues(alpha: 0.22)),
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onPressed,
          child: SizedBox.square(
            dimension: 42,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }
}
