/// Zakat maths, ported from the web backend's `/api/zakat/calculate` route.
///
/// Metal prices are quoted per tola (11.66 g). The nisab follows the silver
/// standard (52.5 tola), the lower of the two thresholds, so it captures more
/// people as eligible when they hold a mix of assets.
library;

const double gramsPerTola = 11.66;
const double goldNisabTola = 7.5;
const double silverNisabTola = 52.5;
const double zakatRate = 0.025;

class ZakatRates {
  const ZakatRates({required this.goldPerTola, required this.silverPerTola});

  /// The reference rates seeded into the web platform's site settings.
  static const defaults = ZakatRates(goldPerTola: 285000, silverPerTola: 3200);

  final int goldPerTola;
  final int silverPerTola;

  int get silverNisabValue => (silverNisabTola * silverPerTola).round();
  int get goldNisabValue => (goldNisabTola * goldPerTola).round();

  bool get isDefault =>
      goldPerTola == defaults.goldPerTola &&
      silverPerTola == defaults.silverPerTola;
}

class ZakatInput {
  const ZakatInput({
    this.goldGrams = 0,
    this.silverGrams = 0,
    this.cash = 0,
    this.savings = 0,
    this.business = 0,
    this.liabilities = 0,
  });

  final double goldGrams;
  final double silverGrams;
  final double cash;
  final double savings;
  final double business;
  final double liabilities;

  double get goldTolas => goldGrams / gramsPerTola;
  double get silverTolas => silverGrams / gramsPerTola;

  bool get isEmpty =>
      goldGrams == 0 &&
      silverGrams == 0 &&
      cash == 0 &&
      savings == 0 &&
      business == 0 &&
      liabilities == 0;
}

class ZakatResult {
  const ZakatResult({
    required this.goldValue,
    required this.silverValue,
    required this.cash,
    required this.savings,
    required this.business,
    required this.liabilities,
    required this.totalAssets,
    required this.netWorth,
    required this.nisabValue,
    required this.isEligible,
    required this.zakatPayable,
  });

  final int goldValue;
  final int silverValue;
  final int cash;
  final int savings;
  final int business;
  final int liabilities;
  final int totalAssets;
  final int netWorth;
  final int nisabValue;
  final bool isEligible;
  final int zakatPayable;

  /// How far net wealth reaches toward the nisab, capped at 1.
  double get nisabProgress =>
      nisabValue == 0 ? 0 : (netWorth / nisabValue).clamp(0, 1).toDouble();
}

ZakatResult calculateZakat(ZakatInput input, ZakatRates rates) {
  final goldValue = input.goldTolas * rates.goldPerTola;
  final silverValue = input.silverTolas * rates.silverPerTola;

  final totalAssets =
      goldValue + silverValue + input.cash + input.savings + input.business;
  final netWorth = (totalAssets - input.liabilities).clamp(0, double.infinity);

  final nisabValue = silverNisabTola * rates.silverPerTola;
  final isEligible = netWorth >= nisabValue;
  final zakatPayable = isEligible ? netWorth * zakatRate : 0;

  return ZakatResult(
    goldValue: goldValue.round(),
    silverValue: silverValue.round(),
    cash: input.cash.round(),
    savings: input.savings.round(),
    business: input.business.round(),
    liabilities: input.liabilities.round(),
    totalAssets: totalAssets.round(),
    netWorth: netWorth.round(),
    nisabValue: nisabValue.round(),
    isEligible: isEligible,
    zakatPayable: zakatPayable.round(),
  );
}
