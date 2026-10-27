# Rah-E-Haq — Donation App

Flutter mobile companion to the **Rah-E-Haq** NGO donation platform (React + Express +
MongoDB). It brings the platform's donate, Zakat and volunteer flows to the phone, uses
the same brand (teal `#0f766e`, amber `#f59e0b`, Poppins / Inter / Noto Nastaliq Urdu),
and ships every screen in English and Urdu with full right-to-left layout.

There is no backend. All content is sample data in Dart, and every account number, phone
number and email in it is a placeholder.

## Features

- **Home**: gradient hero, impact counters, a carousel of active campaigns with
  raised/goal progress, programme cards (tap one for details and a "donate to this cause"
  shortcut), a success story and Donate / Volunteer calls to action.
- **Campaigns**: a full list and a detail screen with progress, story and suggested gift
  amounts that pre-fill the donate form.
- **Donate**: quick amounts or a custom amount (with "your gift provides…" hints), cause
  selection, bank transfer / JazzCash / Easypaisa with copyable account details, a mock
  screenshot picker, validation and a confirmation that stays *pending admin verification*,
  as on the web platform.
- **Zakat calculator**: gold and silver in grams (converted to tolas), cash, savings,
  business assets and debts. Nisab uses the silver standard (52.5 tola) at configurable
  gold and silver rates, and Zakat due is 2.5% of net wealth, the same maths as the web
  backend. The result updates live.
- **Volunteer application**: a three-step form (personal → skills & interests →
  availability & motivation) with a stepper, validation per step and a success summary.
- **My donations**: history with Pending / Verified / Rejected filters and totals, plus a
  receipt screen per donation with a verification timeline and the admin's note.
- **Profile**: English ⇄ اردو switch, dark mode, links to donations, Zakat, volunteering,
  **About** (mission, transparency figures, activities, photo gallery) and **Contact**
  (copyable details, working hours, message form).

## Run it

```bash
flutter pub get
flutter run            # on a device or emulator
flutter test           # smoke test + Zakat maths
flutter build web --release --no-web-resources-cdn
```

### Deep links

Every screen and demo state opens from a URL, which is how the portfolio screenshots
are taken:

| URL | Opens |
| --- | --- |
| `/` | Home |
| `/campaigns`, `/campaign/ramadan-ration-drive` | Campaign list / detail |
| `/donate?demo=1` | Donate form, filled in |
| `/donate?success=1` | Donation confirmation |
| `/donate?cause=zakat&amount=52972` | Donate form, pre-filled |
| `/zakat?demo=1` (`&rates=1`) | Calculator with a result (and the rates sheet) |
| `/volunteer?demo=1` (`&step=3`, `success=1`) | Volunteer form mid-way |
| `/profile/donations` (`?filter=pending`) | Donation history |
| `/profile/donations/RAH-26-0954` | A receipt |
| `/profile/about`, `/profile/contact` | About / Contact |

Add `lang=ur` for Urdu, `theme=dark` for dark mode, and `shot=1` to simulate an iPhone's
safe areas (47 px top, 34 px bottom).

## Structure

```
lib/
  main.dart            path URL strategy + runApp
  app.dart             MaterialApp.router, theme, RTL Directionality, screenshot mode
  router.dart          go_router: 5-tab StatefulShellRoute + detail routes
  theme.dart           brand colours, fonts, light/dark ThemeData, palette extension
  data/                strings (English + Urdu), sample data, formatting helpers
  models/              donation, campaign, Zakat maths, volunteer application
  state/               SettingsController, DonationsController, InheritedNotifier scopes
  screens/             one file per screen
  widgets/             buttons, cards, hero, chips, receipt preview, timeline
assets/images/         photos and logo from the web platform (resized)
test/                  widget smoke test and Zakat unit test
```

Packages: `go_router`, `google_fonts` (plus `flutter_web_plugins` from the SDK). State
uses `ChangeNotifier` with `InheritedNotifier`.
