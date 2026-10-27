import 'package:flutter/widgets.dart';

import 'donation.dart';
import 'localized.dart';

/// A fundraising drive with a target, shown on the home screen.
class Campaign {
  const Campaign({
    required this.id,
    required this.title,
    required this.summary,
    required this.story,
    required this.image,
    required this.cause,
    required this.raised,
    required this.goal,
    required this.donors,
    required this.daysLeft,
    required this.location,
    required this.reach,
    required this.uses,
  });

  final String id;
  final Localized title;
  final Localized summary;
  final Localized story;
  final String image;
  final Cause cause;
  final int raised;
  final int goal;
  final int donors;
  final int daysLeft;
  final Localized location;
  final Localized reach;

  /// What a typical gift buys, shown on the detail screen.
  final List<CampaignUse> uses;

  double get progress => (raised / goal).clamp(0, 1).toDouble();
  int get percent => (progress * 100).round();
  int get remaining => (goal - raised).clamp(0, goal);
}

class CampaignUse {
  const CampaignUse(this.amount, this.label);

  final int amount;
  final Localized label;
}

/// One of the four programme areas from the web homepage.
class Program {
  const Program({
    required this.title,
    required this.description,
    required this.metric,
    required this.icon,
    required this.gradient,
  });

  final Localized title;
  final Localized description;
  final Localized metric;
  final IconData icon;
  final List<Color> gradient;
}

class Story {
  const Story({
    required this.name,
    required this.role,
    required this.location,
    required this.quote,
    required this.photo,
  });

  final String name;
  final Localized role;
  final Localized location;
  final Localized quote;
  final String photo;
}

/// "How your donation helps" scale from the credibility section.
class DonationTier {
  const DonationTier(this.amount, this.impact);

  final int amount;
  final Localized impact;
}

/// A past drive from the "Recent Activities" timeline.
class Activity {
  const Activity({
    required this.title,
    required this.description,
    required this.period,
    required this.reach,
  });

  final Localized title;
  final Localized description;
  final Localized period;
  final Localized reach;
}
