import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/format.dart';
import '../state/app_scope.dart';
import '../theme.dart';

/// Rounded white surface with a soft shadow — the web's `.card`.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.onTap,
    this.radius = 24,
    this.color,
    this.shadow = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final double radius;
  final Color? color;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color ?? palette.surface,
        borderRadius: borderRadius,
        border: Border.all(color: palette.border),
        boxShadow: shadow ? palette.cardShadow : null,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

/// Small rounded label above a heading — the web's `.eyebrow`.
class EyebrowPill extends StatelessWidget {
  const EyebrowPill({
    super.key,
    required this.label,
    this.icon,
    this.onDark = false,
  });

  final String label;
  final IconData? icon;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final foreground = onDark ? Colors.white : palette.brand;
    final pill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: onDark ? Colors.white.withValues(alpha: 0.1) : palette.brandSoft,
        borderRadius: BorderRadius.circular(99),
        border: onDark
            ? Border.all(color: Colors.white.withValues(alpha: 0.2))
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: onDark ? AppColors.secondary : palette.brand,
            ),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Text(
              context.isUrdu ? label : label.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: context.text.labelSmall?.copyWith(color: foreground),
            ),
          ),
        ],
      ),
    );
    // Hug the label even when a list hands down a full-width constraint.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      widthFactor: 1,
      heightFactor: 1,
      child: pill,
    );
  }
}

/// A heading with one highlighted phrase, e.g. "Making A Real **Difference**".
class HighlightTitle extends StatelessWidget {
  const HighlightTitle({
    super.key,
    required this.lead,
    required this.highlight,
    this.tail,
    this.style,
    this.color,
    this.highlightColor,
    this.textAlign,
  });

  final String lead;
  final String highlight;
  final String? tail;
  final TextStyle? style;
  final Color? color;
  final Color? highlightColor;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final base = (style ?? context.text.headlineSmall)!.copyWith(color: color);
    return Text.rich(
      TextSpan(
        style: base,
        children: [
          TextSpan(text: '$lead '),
          TextSpan(
            text: highlight,
            style: TextStyle(color: highlightColor ?? context.palette.brand),
          ),
          if (tail != null) TextSpan(text: ' $tail'),
        ],
      ),
      textAlign: textAlign,
    );
  }
}

/// Section title row with an optional trailing action.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.text.titleLarge),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: context.text.bodySmall),
              ],
            ],
          ),
        ),
        if (actionLabel != null)
          TextButton(
            onPressed: onAction,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              visualDensity: VisualDensity.compact,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  actionLabel!,
                  style: context.text.labelMedium?.copyWith(
                    color: context.palette.brand,
                  ),
                ),
                const SizedBox(width: 2),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: context.palette.brand,
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Rounded progress bar that fills with the brand gradient, start to end.
class GradientProgressBar extends StatelessWidget {
  const GradientProgressBar({
    super.key,
    required this.value,
    this.height = 8,
    this.gradient = AppColors.brandGradient,
    this.trackColor,
  });

  final double value;
  final double height;
  final Gradient gradient;
  final Color? trackColor;

  @override
  Widget build(BuildContext context) {
    final track =
        trackColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppColors.slate700
            : AppColors.slate100);
    return ClipRRect(
      borderRadius: BorderRadius.circular(height),
      child: SizedBox(
        height: height,
        child: ColoredBox(
          color: track,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: value.clamp(0, 1)),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOutCubic,
            builder: (context, animated, _) => FractionallySizedBox(
              alignment: AlignmentDirectional.centerStart,
              widthFactor: animated,
              heightFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(height),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Coloured rounded square holding an icon.
class IconTile extends StatelessWidget {
  const IconTile({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.gradient,
    this.solid = false,
  });

  final IconData icon;
  final Color color;
  final double size;
  final List<Color>? gradient;

  /// Solid fill with a white icon instead of a soft tint.
  final bool solid;

  @override
  Widget build(BuildContext context) {
    final filled = solid || gradient != null;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: gradient == null
            ? (filled ? color : color.withValues(alpha: 0.13))
            : null,
        gradient: gradient == null
            ? null
            : LinearGradient(
                begin: AlignmentDirectional.topStart,
                end: AlignmentDirectional.bottomEnd,
                colors: gradient!,
              ),
        borderRadius: BorderRadius.circular(size * 0.32),
        boxShadow: gradient == null
            ? null
            : [
                BoxShadow(
                  color: gradient!.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Icon(icon, size: size * 0.5, color: filled ? Colors.white : color),
    );
  }
}

/// Toggleable pill used for amounts, skills and filters.
class SelectChip extends StatelessWidget {
  const SelectChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.figure = false,
    this.showCheck = true,
    this.onDark = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  /// Render the label in the Poppins figure style (for amounts).
  final bool figure;
  final bool showCheck;

  /// Glass styling for chips placed on the brand gradient.
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final Color foreground;
    final BoxDecoration decoration;
    if (onDark) {
      foreground = selected ? AppColors.primary : Colors.white;
      decoration = BoxDecoration(
        color: selected ? Colors.white : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: selected ? Colors.white : Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      );
    } else {
      foreground = selected ? Colors.white : palette.body;
      decoration = BoxDecoration(
        gradient: selected ? AppColors.brandGradient : null,
        color: selected ? null : palette.surface,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: selected ? Colors.transparent : palette.border,
          width: 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      );
    }
    final style = figure
        ? AppTheme.figure(13.5, weight: FontWeight.w600, color: foreground)
        : context.text.labelMedium?.copyWith(color: foreground);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: decoration,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          customBorder: const StadiumBorder(),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14,
              vertical: context.isUrdu && !figure ? 5 : 9,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected && showCheck) ...[
                  Icon(Icons.check_rounded, size: 16, color: foreground),
                  const SizedBox(width: 5),
                ],
                Text(
                  label,
                  style: style,
                  textDirection: figure ? TextDirection.ltr : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label above an input, with a red asterisk for required fields.
class FieldLabel extends StatelessWidget {
  const FieldLabel(
    this.label, {
    super.key,
    this.required = false,
    this.optional,
  });

  final String label;
  final bool required;
  final String? optional;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text.rich(
        TextSpan(
          text: label,
          style: context.text.titleSmall,
          children: [
            if (required)
              const TextSpan(
                text: ' *',
                style: TextStyle(color: AppColors.red500),
              ),
            if (optional != null)
              TextSpan(text: ' $optional', style: context.text.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Labelled text field matching the web form styling.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.required = false,
    this.optional,
    this.keyboardType,
    this.prefixIcon,
    this.prefixText,
    this.suffixText,
    this.maxLines = 1,
    this.errorText,
    this.ltr = false,
    this.onChanged,
    this.inputFormatters,
    this.helper,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool required;
  final String? optional;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final String? prefixText;
  final String? suffixText;
  final int maxLines;
  final String? errorText;

  /// Emails, phone numbers and amounts stay left-to-right in Urdu too.
  final bool ltr;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? helper;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final style = ltr
        ? AppFonts.body(fontSize: 15, color: palette.strong, height: 1.4)
        : context.text.bodyLarge?.copyWith(color: palette.strong);
    final field = TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: maxLines > 1 ? maxLines : null,
      style: style,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, size: 20, color: palette.muted),
        prefixText: prefixText,
        prefixStyle: AppTheme.figure(
          15,
          weight: FontWeight.w600,
          color: palette.muted,
        ),
        suffixText: suffixText,
        suffixStyle: context.text.bodySmall,
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FieldLabel(label, required: required, optional: optional),
        // Values such as "Rs. 1,500" or an email read left-to-right even in
        // Urdu, so the whole field (prefix and suffix too) flips to LTR.
        if (ltr)
          Directionality(textDirection: TextDirection.ltr, child: field)
        else
          field,
        if (helper != null) ...[const SizedBox(height: 6), helper!],
      ],
    );
  }
}

/// Inline error banner — the web's `<Alert variant="error">`.
class ErrorBanner extends StatelessWidget {
  const ErrorBanner(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.red500.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.red500.withValues(alpha: 0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.red500,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: context.text.bodyMedium?.copyWith(color: AppColors.red500),
            ),
          ),
        ],
      ),
    );
  }
}

/// A label/value row whose value can be copied — payment details, references.
class CopyRow extends StatelessWidget {
  const CopyRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Material(
      color: palette.surfaceAlt,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => copyToClipboard(context, value, label),
        child: Container(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.isUrdu ? label : label.toUpperCase(),
                      style: context.text.labelSmall,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textDirection: TextDirection.ltr,
                      style: AppTheme.figure(
                        14.5,
                        weight: FontWeight.w600,
                        color: palette.strong,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: palette.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.content_copy_rounded,
                  size: 17,
                  color: palette.brand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> copyToClipboard(
  BuildContext context,
  String value,
  String label,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final message = context.s.copied(label);
  try {
    await Clipboard.setData(ClipboardData(text: value));
  } on PlatformException {
    // Clipboard access can be blocked; the value is still visible to select.
  }
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Label on the start side, value on the end side.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.valueStyle,
    this.figure = false,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  /// Render the value in Poppins, left-to-right (amounts, references).
  final bool figure;

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: context.text.bodyMedium),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              textDirection: figure ? TextDirection.ltr : null,
              style:
                  valueStyle ??
                  (figure
                      ? AppTheme.figure(
                          14,
                          weight: FontWeight.w600,
                          color: palette.strong,
                        )
                      : context.text.titleSmall),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws a dashed rounded border, for the screenshot upload target.
class DashedBorder extends StatelessWidget {
  const DashedBorder({
    super.key,
    required this.child,
    required this.color,
    this.radius = 20,
  });

  final Widget child;
  final Color color;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(color: color, radius: radius),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  _DashedPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, Radius.circular(radius)),
      );
    for (final ui.PathMetric metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 7), paint);
        distance += 12;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}

/// Keeps rupee inputs readable while typing: 150000 -> 150,000.
class GroupedDigitsFormatter extends TextInputFormatter {
  const GroupedDigitsFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) return TextEditingValue.empty;
    if (digits.length > 10) digits = digits.substring(0, 10);
    final text = groupDigits(int.parse(digits));
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

/// Thin divider with a little breathing room.
class SoftDivider extends StatelessWidget {
  const SoftDivider({super.key, this.height = 24});

  final double height;

  @override
  Widget build(BuildContext context) =>
      Divider(height: height, color: context.palette.border);
}
