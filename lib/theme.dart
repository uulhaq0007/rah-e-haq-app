import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand colours from the web platform's Tailwind config.
abstract final class AppColors {
  static const primary = Color(0xFF0F766E); // teal-700
  static const teal400 = Color(0xFF2DD4BF);
  static const teal500 = Color(0xFF14B8A6);
  static const emerald400 = Color(0xFF34D399);
  static const emerald600 = Color(0xFF059669);
  static const emerald700 = Color(0xFF047857);
  static const emerald800 = Color(0xFF065F46);
  static const secondary = Color(0xFFF59E0B); // amber-500
  static const amber300 = Color(0xFFFCD34D);
  static const amber400 = Color(0xFFFBBF24);
  static const amber600 = Color(0xFFD97706);
  static const accent = Color(0xFF22C55E); // green-500
  static const red500 = Color(0xFFEF4444);
  static const blue500 = Color(0xFF3B82F6);

  static const slate50 = Color(0xFFF8FAFC);
  static const slate100 = Color(0xFFF1F5F9);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate400 = Color(0xFF94A3B8);
  static const slate500 = Color(0xFF64748B);
  static const slate600 = Color(0xFF475569);
  static const slate700 = Color(0xFF334155);
  static const slate800 = Color(0xFF1E293B);
  static const slate900 = Color(0xFF0F172A);
  static const slate950 = Color(0xFF020617);

  /// `bg-gradient-to-r from-primary to-emerald-600` — buttons and highlights.
  static const brandGradient = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [primary, emerald600],
  );

  /// `from-primary via-emerald-800 to-slate-900` — the page heroes.
  static const heroGradient = LinearGradient(
    begin: AlignmentDirectional.topStart,
    end: AlignmentDirectional.bottomEnd,
    colors: [primary, emerald800, slate900],
    stops: [0, 0.6, 1],
  );

  static const amberGradient = LinearGradient(
    begin: AlignmentDirectional.centerStart,
    end: AlignmentDirectional.centerEnd,
    colors: [secondary, amber400],
  );
}

/// Font helpers. Inter for body copy, Poppins for display and figures, and
/// Noto Nastaliq Urdu (with extra line height) whenever the app is in Urdu.
abstract final class AppFonts {
  /// Turned off in widget tests, which have no network to fetch fonts.
  static bool useGoogleFonts = true;

  static TextStyle display({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w700,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
    return useGoogleFonts ? GoogleFonts.poppins(textStyle: style) : style;
  }

  static TextStyle body({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
    return useGoogleFonts ? GoogleFonts.inter(textStyle: style) : style;
  }

  static TextStyle urdu({
    double? fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
  }) {
    final style = TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
    return useGoogleFonts
        ? GoogleFonts.notoNastaliqUrdu(textStyle: style)
        : style;
  }
}

/// Surface and text colours that differ between light and dark mode.
@immutable
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.border,
    required this.strong,
    required this.body,
    required this.muted,
    required this.brand,
    required this.brandSoft,
    required this.shadow,
  });

  static const light = AppPalette(
    background: Color(0xFFF5F7FA),
    surface: Colors.white,
    surfaceAlt: AppColors.slate50,
    border: Color(0xFFE9EEF4),
    strong: AppColors.slate900,
    body: AppColors.slate600,
    muted: AppColors.slate400,
    brand: AppColors.primary,
    brandSoft: Color(0x1A0F766E),
    shadow: Color(0x140F172A),
  );

  static const dark = AppPalette(
    background: AppColors.slate900,
    surface: AppColors.slate800,
    surfaceAlt: Color(0xFF172234),
    border: Color(0xFF2B3A50),
    strong: AppColors.slate100,
    body: AppColors.slate300,
    muted: AppColors.slate400,
    brand: AppColors.teal400,
    brandSoft: Color(0x332DD4BF),
    shadow: Color(0x66020617),
  );

  final Color background;
  final Color surface;

  /// Inset rows inside a card, e.g. copyable payment fields.
  final Color surfaceAlt;
  final Color border;
  final Color strong;
  final Color body;
  final Color muted;

  /// Brand teal tuned for legibility as text or icon on [surface].
  final Color brand;
  final Color brandSoft;
  final Color shadow;

  List<BoxShadow> get cardShadow => [
    BoxShadow(color: shadow, blurRadius: 24, offset: const Offset(0, 8)),
  ];

  @override
  AppPalette copyWith() => this;

  @override
  AppPalette lerp(AppPalette? other, double t) {
    if (other == null) return this;
    return AppPalette(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      border: Color.lerp(border, other.border, t)!,
      strong: Color.lerp(strong, other.strong, t)!,
      body: Color.lerp(body, other.body, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      brand: Color.lerp(brand, other.brand, t)!,
      brandSoft: Color.lerp(brandSoft, other.brandSoft, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
    );
  }
}

abstract final class AppTheme {
  static ThemeData light({required bool isUrdu}) =>
      _build(Brightness.light, AppPalette.light, isUrdu);

  static ThemeData dark({required bool isUrdu}) =>
      _build(Brightness.dark, AppPalette.dark, isUrdu);

  static ThemeData _build(Brightness brightness, AppPalette p, bool isUrdu) {
    final isDark = brightness == Brightness.dark;
    final scheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: brightness,
        ).copyWith(
          primary: isDark ? AppColors.teal500 : AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          onSecondary: Colors.white,
          tertiary: AppColors.accent,
          error: AppColors.red500,
          surface: p.surface,
          onSurface: p.strong,
          onSurfaceVariant: p.body,
          outline: p.border,
          outlineVariant: p.border,
        );
    final text = _textTheme(p, isUrdu);

    OutlineInputBorder border(Color color, [double width = 1.5]) =>
        OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.background,
      textTheme: text,
      extensions: [p],
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: p.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: p.strong,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: text.titleLarge,
      ),
      dividerTheme: DividerThemeData(color: p.border, thickness: 1, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? const Color(0xFF162133) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: text.bodyMedium?.copyWith(color: p.muted),
        labelStyle: text.bodyMedium?.copyWith(color: p.body),
        floatingLabelStyle: text.bodyMedium?.copyWith(color: p.brand),
        prefixIconColor: p.muted,
        suffixIconColor: p.muted,
        border: border(isDark ? AppColors.slate700 : AppColors.slate200),
        enabledBorder: border(isDark ? AppColors.slate700 : AppColors.slate200),
        focusedBorder: border(p.brand, 2),
        errorBorder: border(AppColors.red500),
        focusedErrorBorder: border(AppColors.red500, 2),
        errorStyle: text.bodySmall?.copyWith(color: AppColors.red500),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        indicatorColor: p.brandSoft,
        elevation: 0,
        height: 68,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return text.labelMedium?.copyWith(
            color: selected ? p.brand : p.muted,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(color: selected ? p.brand : p.muted, size: 24);
        }),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : (isDark ? AppColors.slate400 : AppColors.slate300),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : (isDark ? AppColors.slate700 : AppColors.slate100),
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : (isDark ? AppColors.slate600 : AppColors.slate200),
        ),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.primary,
        inactiveTrackColor: isDark ? AppColors.slate700 : AppColors.slate200,
        thumbColor: AppColors.primary,
        overlayColor: AppColors.primary.withValues(alpha: 0.12),
        trackHeight: 6,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: p.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: isDark ? AppColors.slate600 : AppColors.slate300,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.slate700 : AppColors.slate900,
        contentTextStyle: text.bodyMedium?.copyWith(color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: p.brand,
          textStyle: text.labelLarge,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: p.surface,
        surfaceTintColor: Colors.transparent,
        textStyle: text.bodyMedium?.copyWith(color: p.strong),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  static TextTheme _textTheme(AppPalette p, bool isUrdu) {
    if (isUrdu) {
      // Nastaliq stacks glyphs diagonally, so it needs a tall line box.
      TextStyle u(double size, FontWeight weight, Color color, double height) =>
          AppFonts.urdu(
            fontSize: size,
            fontWeight: weight,
            color: color,
            height: height,
          );
      return TextTheme(
        displaySmall: u(28, FontWeight.w700, p.strong, 1.75),
        headlineMedium: u(23, FontWeight.w700, p.strong, 1.8),
        headlineSmall: u(20, FontWeight.w700, p.strong, 1.8),
        titleLarge: u(17.5, FontWeight.w700, p.strong, 1.85),
        titleMedium: u(15, FontWeight.w700, p.strong, 1.9),
        titleSmall: u(13.5, FontWeight.w600, p.strong, 1.9),
        bodyLarge: u(14.5, FontWeight.w400, p.body, 2.05),
        bodyMedium: u(13, FontWeight.w400, p.body, 2.05),
        bodySmall: u(11.5, FontWeight.w400, p.muted, 2.0),
        labelLarge: u(14, FontWeight.w600, p.strong, 1.7),
        labelMedium: u(12, FontWeight.w600, p.body, 1.75),
        labelSmall: u(11, FontWeight.w600, p.muted, 1.75),
      );
    }
    return TextTheme(
      displaySmall: AppFonts.display(
        fontSize: 33,
        color: p.strong,
        height: 1.15,
        letterSpacing: -0.5,
      ),
      headlineMedium: AppFonts.display(
        fontSize: 26,
        color: p.strong,
        height: 1.2,
        letterSpacing: -0.3,
      ),
      headlineSmall: AppFonts.display(
        fontSize: 22,
        color: p.strong,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleLarge: AppFonts.display(fontSize: 18, color: p.strong, height: 1.3),
      titleMedium: AppFonts.display(
        fontSize: 15.5,
        fontWeight: FontWeight.w600,
        color: p.strong,
        height: 1.35,
      ),
      titleSmall: AppFonts.display(
        fontSize: 13.5,
        fontWeight: FontWeight.w600,
        color: p.strong,
        height: 1.35,
      ),
      bodyLarge: AppFonts.body(fontSize: 15.5, color: p.body, height: 1.55),
      bodyMedium: AppFonts.body(fontSize: 13.5, color: p.body, height: 1.55),
      bodySmall: AppFonts.body(fontSize: 12, color: p.muted, height: 1.5),
      labelLarge: AppFonts.display(
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
        color: p.strong,
        height: 1.3,
      ),
      labelMedium: AppFonts.body(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: p.body,
        height: 1.3,
      ),
      labelSmall: AppFonts.body(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        color: p.muted,
        height: 1.3,
        letterSpacing: 0.9,
      ),
    );
  }

  /// Figures and amounts stay in Poppins in both languages, as on the web.
  static TextStyle figure(
    double size, {
    FontWeight weight = FontWeight.w700,
    Color? color,
    double height = 1.2,
  }) => AppFonts.display(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: size >= 24 ? -0.5 : 0,
  );
}
