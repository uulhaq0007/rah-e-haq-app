/// A piece of sample content that ships in both English and Urdu.
class Localized {
  const Localized(this.en, this.ur);

  final String en;
  final String ur;

  String of(bool isUrdu) => isUrdu ? ur : en;
}
