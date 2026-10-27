import 'package:flutter/material.dart';

import '../data/strings.dart';
import '../models/zakat.dart';

/// App-wide preferences: language, theme and the Zakat reference rates.
class SettingsController extends ChangeNotifier {
  SettingsController({
    this._isUrdu = false,
    this._themeMode = ThemeMode.light,
    this._rates = ZakatRates.defaults,
  });

  /// Reads `?lang=ur` and `?theme=dark` so a screenshot URL can open the app
  /// straight into Urdu or dark mode.
  factory SettingsController.fromUri(Uri uri) {
    final params = uri.queryParameters;
    return SettingsController(
      isUrdu: params['lang'] == 'ur',
      themeMode: params['theme'] == 'dark' ? ThemeMode.dark : ThemeMode.light,
    );
  }

  bool _isUrdu;
  ThemeMode _themeMode;
  ZakatRates _rates;

  bool get isUrdu => _isUrdu;
  S get strings => _isUrdu ? const S(true) : const S(false);
  TextDirection get textDirection =>
      _isUrdu ? TextDirection.rtl : TextDirection.ltr;

  ThemeMode get themeMode => _themeMode;
  bool get isDark => _themeMode == ThemeMode.dark;

  ZakatRates get rates => _rates;

  void setUrdu(bool value) {
    if (value == _isUrdu) return;
    _isUrdu = value;
    notifyListeners();
  }

  void toggleLanguage() => setUrdu(!_isUrdu);

  void setDark(bool value) {
    final mode = value ? ThemeMode.dark : ThemeMode.light;
    if (mode == _themeMode) return;
    _themeMode = mode;
    notifyListeners();
  }

  void toggleTheme() => setDark(!isDark);

  void updateRates(ZakatRates rates) {
    _rates = rates;
    notifyListeners();
  }
}
