import 'package:flutter/material.dart';

import '../data/sample_data.dart';
import '../state/app_scope.dart';
import '../theme.dart';

/// The web heroes' deep teal gradient with soft amber and green glows.
class HeroBackground extends StatelessWidget {
  const HeroBackground({
    super.key,
    required this.child,
    this.radius = 32,
    this.image,
  });

  final Widget child;
  final double radius;

  /// Optional photo blended faintly under the gradient.
  final String? image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(radius)),
      child: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: Stack(
          children: [
            if (image != null)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(image!, fit: BoxFit.cover),
                ),
              ),
            const PositionedDirectional(
              start: -110,
              top: 10,
              child: _Glow(color: AppColors.accent, size: 300, alpha: 0.28),
            ),
            const PositionedDirectional(
              end: -120,
              bottom: -110,
              child: _Glow(color: AppColors.secondary, size: 340, alpha: 0.26),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size, required this.alpha});

  final Color color;
  final double size;
  final double alpha;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: alpha),
              color.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }
}

/// Translucent rounded panel for use on the hero gradient.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 22,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
      ),
      child: child,
    );
  }
}

/// Logo in a white disc, optionally followed by the name and tagline.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 42, this.showName = true, this.onDark = true});

  final double size;
  final bool showName;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final s = context.s;
    final nameColor = onDark ? Colors.white : context.palette.strong;
    final taglineColor =
        onDark ? Colors.white.withValues(alpha: 0.7) : context.palette.muted;
    final logo = Container(
      width: size,
      height: size,
      padding: EdgeInsets.all(size * 0.14),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(SampleData.logo, fit: BoxFit.contain),
    );
    if (!showName) return logo;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        logo,
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              s.appName,
              style: context.text.titleMedium?.copyWith(
                color: nameColor,
                fontWeight: FontWeight.w700,
                height: context.isUrdu ? 1.6 : 1.2,
              ),
            ),
            Text(
              s.tagline,
              style: context.text.bodySmall?.copyWith(
                color: taglineColor,
                height: context.isUrdu ? 1.6 : 1.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Switches between English and Urdu. The label always names the other
/// language, written in that language's own script.
class LanguagePill extends StatelessWidget {
  const LanguagePill({super.key, this.onDark = true});

  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final settings = context.settings;
    final foreground = onDark ? Colors.white : context.palette.brand;
    final label = settings.isUrdu
        ? AppFonts.body(fontSize: 13, fontWeight: FontWeight.w600, color: foreground)
        : AppFonts.urdu(fontSize: 13, fontWeight: FontWeight.w600, color: foreground, height: 1.5);
    return Material(
      color: onDark
          ? Colors.white.withValues(alpha: 0.12)
          : context.palette.brandSoft,
      shape: StadiumBorder(
        side: onDark
            ? BorderSide(color: Colors.white.withValues(alpha: 0.22))
            : BorderSide.none,
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: settings.toggleLanguage,
        child: Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.translate_rounded, size: 17, color: foreground),
              const SizedBox(width: 6),
              Text(settings.strings.switchLanguage, style: label),
            ],
          ),
        ),
      ),
    );
  }
}
