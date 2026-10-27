import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'data/sample_data.dart';
import 'router.dart';
import 'state/app_scope.dart';
import 'state/donations_controller.dart';
import 'state/settings_controller.dart';
import 'theme.dart';

/// `?shot` in the page URL simulates an iPhone's safe areas so the portfolio
/// mockup can draw its status bar and home indicator over them.
final bool shotMode = kIsWeb && Uri.base.queryParameters.containsKey('shot');

class RahEHaqApp extends StatefulWidget {
  const RahEHaqApp({super.key, this.settings});

  /// Injected by tests; otherwise read from the launch URL on web.
  final SettingsController? settings;

  @override
  State<RahEHaqApp> createState() => _RahEHaqAppState();
}

class _RahEHaqAppState extends State<RahEHaqApp> {
  late final SettingsController _settings = widget.settings ??
      (kIsWeb ? SettingsController.fromUri(Uri.base) : SettingsController());
  final DonationsController _donations =
      DonationsController(SampleData.seedDonations);
  final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    _donations.dispose();
    if (widget.settings == null) _settings.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SettingsScope(
      controller: _settings,
      child: DonationsScope(
        controller: _donations,
        child: ListenableBuilder(
          listenable: _settings,
          builder: (context, _) => MaterialApp.router(
            title: 'Rah-E-Haq',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(isUrdu: _settings.isUrdu),
            darkTheme: AppTheme.dark(isUrdu: _settings.isUrdu),
            themeMode: _settings.themeMode,
            routerConfig: _router,
            builder: (context, child) {
              // Urdu flips the whole app, overlays and sheets included.
              final directed = Directionality(
                textDirection: _settings.textDirection,
                child: child!,
              );
              if (!shotMode) return directed;
              const pad = EdgeInsets.only(top: 47, bottom: 34);
              final mq = MediaQuery.of(context);
              return MediaQuery(
                data: mq.copyWith(padding: pad, viewPadding: pad),
                child: directed,
              );
            },
          ),
        ),
      ),
    );
  }
}
