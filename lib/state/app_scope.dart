import 'package:flutter/material.dart';

import '../data/strings.dart';
import '../theme.dart';
import 'donations_controller.dart';
import 'settings_controller.dart';

/// Exposes [SettingsController]; widgets that read it rebuild when the
/// language, theme or Zakat rates change.
class SettingsScope extends InheritedNotifier<SettingsController> {
  const SettingsScope({
    super.key,
    required SettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static SettingsController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<SettingsScope>()!
      .notifier!;

  /// Reads the controller without subscribing, e.g. from `initState`.
  static SettingsController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<SettingsScope>()!.notifier!;
}

/// Exposes the donor's [DonationsController].
class DonationsScope extends InheritedNotifier<DonationsController> {
  const DonationsScope({
    super.key,
    required DonationsController controller,
    required super.child,
  }) : super(notifier: controller);

  static DonationsController of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<DonationsScope>()!
      .notifier!;

  /// Reads the controller without subscribing, e.g. from `initState`.
  static DonationsController read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<DonationsScope>()!.notifier!;
}

extension AppContext on BuildContext {
  SettingsController get settings => SettingsScope.of(this);
  DonationsController get donations => DonationsScope.of(this);
  S get s => SettingsScope.of(this).strings;
  bool get isUrdu => SettingsScope.of(this).isUrdu;
  TextTheme get text => Theme.of(this).textTheme;
  AppPalette get palette => Theme.of(this).extension<AppPalette>()!;
}
