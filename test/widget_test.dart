import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rah_e_haq_app/app.dart';
import 'package:rah_e_haq_app/models/zakat.dart';
import 'package:rah_e_haq_app/state/settings_controller.dart';
import 'package:rah_e_haq_app/theme.dart';

void main() {
  // Tests have no network, so skip fetching Google Fonts.
  setUp(() => AppFonts.useGoogleFonts = false);

  testWidgets('home screen renders and the language toggle flips to Urdu', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844) * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    final settings = SettingsController();
    addTearDown(settings.dispose);

    await tester.pumpWidget(RahEHaqApp(settings: settings));
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Rah-E-Haq'), findsWidgets);
    expect(find.text('Active Campaigns'), findsOneWidget);
    expect(find.text('Donate Now'), findsWidgets);

    settings.toggleLanguage();
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('جاری مہمات'), findsOneWidget);
    final heading = tester.element(find.text('جاری مہمات'));
    expect(Directionality.of(heading), TextDirection.rtl);
  });

  test('zakat follows the silver-standard nisab at 2.5%', () {
    const rates = ZakatRates.defaults;

    // 52.5 tola of silver at Rs. 3,200 = Rs. 168,000 nisab.
    expect(rates.silverNisabValue, 168000);

    final below = calculateZakat(const ZakatInput(cash: 100000), rates);
    expect(below.isEligible, isFalse);
    expect(below.zakatPayable, 0);

    final above = calculateZakat(
      const ZakatInput(cash: 500000, savings: 300000, liabilities: 200000),
      rates,
    );
    expect(above.netWorth, 600000);
    expect(above.isEligible, isTrue);
    expect(above.zakatPayable, 15000);

    // 11.66 g is exactly one tola.
    final gold = calculateZakat(const ZakatInput(goldGrams: 116.6), rates);
    expect(gold.goldValue, 2850000);
  });
}
