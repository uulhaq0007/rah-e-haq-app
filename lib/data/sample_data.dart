import 'package:flutter/material.dart';

import '../models/campaign.dart';
import '../models/donation.dart';
import '../models/localized.dart';

/// Sample content for the app. Figures, programmes, the story, donation tiers,
/// activities and payment accounts come from the web platform's seed data
/// (`backend/src/seed.js`); campaigns are built around its real activities.
abstract final class SampleData {
  // Site settings -------------------------------------------------------------
  static const mealsServed = 15000;
  static const volunteers = 500;
  static const communityEvents = 100;
  static const welfareInstitutions = 8;
  static const foundedYear = 2018;
  static const communitiesServed = 15;
  static const livesImpacted = 5000;
  static const citiesCovered = 15;
  static const fundsToPrograms = 92;
  static const administrative = 8;
  static const transparencyScore = 100;
  static const donorRating = 4.9;
  static const totalDonors = 10000;

  // Contact details and payment accounts are placeholders: this app ships
  // publicly, so none of the platform's real numbers appear here.
  static const phones = ['+92 300 0000000', '+92 311 0000000'];
  static const contactEmail = 'info@rah-e-haq.example';
  static const hoursWeekdays = '9:00 AM - 6:00 PM';
  static const hoursSaturday = '10:00 AM - 4:00 PM';

  // Payment accounts shown on the donate screen.
  static const bankIban = 'PK00 RAHQ 0000 1234 5678 9012';
  static const bankAccountTitle = 'Rah-E-Haq Welfare Trust';
  static const bankName = 'Demo Bank Limited';
  static const easypaisaNumber = '0345-0000000';
  static const easypaisaName = 'Rah-E-Haq Welfare Trust';
  static const jazzcashNumber = '0300-0000000';
  static const jazzcashName = 'Rah-E-Haq Welfare Trust';

  static const quickAmounts = [500, 1000, 2000, 5000, 10000, 25000];

  // The signed-in donor (fictional) -------------------------------------------
  static const donorName = 'Hamza Ali';
  static const donorEmail = 'hamza.ali@example.com';
  static const donorPhone = '0300-1234567';
  static const donorSince = 2023;

  // Images ----------------------------------------------------------------------
  static const logo = 'assets/images/logo.png';
  static const missionImage = 'assets/images/mission.jpg';
  static const volunteerImage = 'assets/images/volunteers-1.jpg';
  static const donateImage = 'assets/images/community-1.jpg';
  static const gallery = [
    'assets/images/food-distribution-1.jpg',
    'assets/images/volunteers-1.jpg',
    'assets/images/education-1.jpg',
    'assets/images/community-1.jpg',
    'assets/images/healthcare-1.jpg',
    'assets/images/food-distribution-2.jpg',
    'assets/images/education-2.jpg',
    'assets/images/team-1.jpg',
  ];

  // Campaigns -------------------------------------------------------------------
  static const campaigns = [
    Campaign(
      id: 'ramadan-ration-drive',
      title: Localized('Ramadan Ration Drive', 'رمضان راشن مہم'),
      summary: Localized(
        'Monthly food packages for 500 families across Karachi.',
        'کراچی بھر میں 500 خاندانوں کے لیے ماہانہ راشن پیکج۔',
      ),
      story: Localized(
        'Every package carries flour, rice, lentils, oil, sugar and tea — enough for a family of four for a month. Volunteers pack and deliver them door to door, so families receive help with dignity instead of waiting in queues.',
        'ہر پیکج میں آٹا، چاول، دالیں، تیل، چینی اور چائے شامل ہے — چار افراد کے خاندان کے لیے پورے مہینے کا راشن۔ رضاکار یہ پیکج گھر گھر پہنچاتے ہیں تاکہ خاندانوں کو قطاروں کے بجائے عزت کے ساتھ مدد ملے۔',
      ),
      image: 'assets/images/healthcare-1.jpg',
      cause: Cause.food,
      raised: 1850000,
      goal: 2500000,
      donors: 342,
      daysLeft: 12,
      location: Localized('Karachi', 'کراچی'),
      reach: Localized('500 families', '500 خاندان'),
      uses: [
        CampaignUse(
          500,
          Localized(
            'A meal for a family of 4',
            'چار افراد کے خاندان کے لیے ایک وقت کا کھانا',
          ),
        ),
        CampaignUse(
          2000,
          Localized(
            'Monthly food ration for one family',
            'ایک خاندان کے لیے ماہانہ راشن',
          ),
        ),
        CampaignUse(
          10000,
          Localized('Rations for five families', 'پانچ خاندانوں کا راشن'),
        ),
      ],
    ),
    Campaign(
      id: 'school-supplies',
      title: Localized(
        'School Supplies for 200 Students',
        '200 طلبہ کے لیے تعلیمی سامان',
      ),
      summary: Localized(
        'Bags, books and uniforms for children in community schools.',
        'کمیونٹی اسکولوں کے بچوں کے لیے بستے، کتابیں اور یونیفارم۔',
      ),
      story: Localized(
        'Many children in our partner schools share a single textbook between three. This drive gives each of 200 students a full kit — bag, notebooks, stationery and a uniform — before the new term begins.',
        'ہمارے شراکتی اسکولوں میں کئی بچے ایک کتاب تین افراد میں بانٹتے ہیں۔ یہ مہم نئے تعلیمی سال سے پہلے 200 طلبہ کو مکمل کٹ دیتی ہے — بستہ، کاپیاں، اسٹیشنری اور یونیفارم۔',
      ),
      image: 'assets/images/food-distribution-2.jpg',
      cause: Cause.education,
      raised: 640000,
      goal: 1000000,
      donors: 158,
      daysLeft: 21,
      location: Localized('Lahore', 'لاہور'),
      reach: Localized('200 students', '200 طلبہ'),
      uses: [
        CampaignUse(
          5000,
          Localized(
            'School supplies for one child',
            'ایک بچے کے لیے تعلیمی سامان',
          ),
        ),
        CampaignUse(
          25000,
          Localized(
            'Sponsor education for one child/month',
            'ایک بچے کی ماہانہ تعلیمی کفالت',
          ),
        ),
      ],
    ),
    Campaign(
      id: 'health-camp',
      title: Localized('Community Health Camp', 'کمیونٹی ہیلتھ کیمپ'),
      summary: Localized(
        'Free medical checkups and medicines for 300 patients.',
        '300 مریضوں کے لیے مفت طبی معائنہ اور ادویات۔',
      ),
      story: Localized(
        'Volunteer doctors run a two-day camp with general checkups, blood-sugar and blood-pressure screening, and a free pharmacy. Children and the elderly are seen first.',
        'رضاکار ڈاکٹر دو روزہ کیمپ لگاتے ہیں جس میں عمومی معائنہ، شوگر اور بلڈ پریشر کی جانچ اور مفت فارمیسی شامل ہے۔ بچوں اور بزرگوں کو ترجیح دی جاتی ہے۔',
      ),
      image: 'assets/images/education-2.jpg',
      cause: Cause.healthcare,
      raised: 410000,
      goal: 750000,
      donors: 97,
      daysLeft: 18,
      location: Localized('Rawalpindi', 'راولپنڈی'),
      reach: Localized('300 patients', '300 مریض'),
      uses: [
        CampaignUse(
          2000,
          Localized('Medicines for one patient', 'ایک مریض کی ادویات'),
        ),
        CampaignUse(
          10000,
          Localized(
            'Medical supplies for community camp',
            'کمیونٹی کیمپ کے لیے طبی سامان',
          ),
        ),
      ],
    ),
    Campaign(
      id: 'eid-gifts',
      title: Localized('Eid Gift Program', 'عید تحائف پروگرام'),
      summary: Localized(
        'New clothes and gifts for 150 underprivileged children.',
        '150 مستحق بچوں کے لیے نئے کپڑے اور تحائف۔',
      ),
      story: Localized(
        'Eid should feel like Eid for every child. Each gift box holds a new outfit, shoes and a small toy, wrapped and delivered by our volunteers in the last week of Ramadan.',
        'ہر بچے کے لیے عید، عید جیسی ہونی چاہیے۔ ہر تحفے کے ڈبے میں نیا لباس، جوتے اور ایک چھوٹا کھلونا ہوتا ہے، جو رمضان کے آخری ہفتے میں ہمارے رضاکار پہنچاتے ہیں۔',
      ),
      image: 'assets/images/food-distribution-1.jpg',
      cause: Cause.general,
      raised: 182000,
      goal: 300000,
      donors: 64,
      daysLeft: 30,
      location: Localized('Islamabad', 'اسلام آباد'),
      reach: Localized('150 children', '150 بچے'),
      uses: [
        CampaignUse(
          2000,
          Localized('One complete Eid gift box', 'عید کا ایک مکمل تحفہ'),
        ),
        CampaignUse(
          10000,
          Localized('Gifts for five children', 'پانچ بچوں کے تحائف'),
        ),
      ],
    ),
  ];

  static Campaign? campaignById(String? id) {
    for (final campaign in campaigns) {
      if (campaign.id == id) return campaign;
    }
    return null;
  }

  // Programmes ------------------------------------------------------------------
  static const programs = [
    Program(
      title: Localized('Food Distribution', 'کھانے کی تقسیم'),
      description: Localized(
        'Providing nutritious meals and food packages to families in need, ensuring no one goes hungry in our community.',
        'ضرورت مند خاندانوں کو غذائیت سے بھرپور کھانا اور راشن فراہم کرنا تاکہ ہمارے معاشرے میں کوئی بھوکا نہ رہے۔',
      ),
      metric: Localized('500+ families served', '500+ خاندانوں کی خدمت'),
      icon: Icons.restaurant_rounded,
      gradient: [Color(0xFF0F766E), Color(0xFF059669)],
    ),
    Program(
      title: Localized('Community Welfare', 'فلاحِ عامہ'),
      description: Localized(
        'Building stronger communities through essential services, healthcare support, and emergency relief programs.',
        'بنیادی خدمات، صحت کی سہولیات اور ہنگامی امداد کے ذریعے مضبوط معاشرے کی تعمیر۔',
      ),
      metric: Localized('12 welfare drives', '12 فلاحی مہمات'),
      icon: Icons.handshake_rounded,
      gradient: [Color(0xFFF59E0B), Color(0xFFF97316)],
    ),
    Program(
      title: Localized('Volunteer Network', 'رضاکار نیٹ ورک'),
      description: Localized(
        'Empowering passionate individuals to make a difference. Our volunteers are the heart of our organization.',
        'پرجوش افراد کو تبدیلی لانے کا موقع دینا۔ ہمارے رضاکار ہماری تنظیم کا دل ہیں۔',
      ),
      metric: Localized('25+ active volunteers', '25+ فعال رضاکار'),
      icon: Icons.groups_rounded,
      gradient: [Color(0xFF3B82F6), Color(0xFF6366F1)],
    ),
    Program(
      title: Localized('Educational Support', 'تعلیمی معاونت'),
      description: Localized(
        'Sponsoring education for underprivileged children, providing supplies, mentorship, and learning resources.',
        'مستحق بچوں کی تعلیم کی کفالت، تعلیمی سامان، رہنمائی اور وسائل کی فراہمی۔',
      ),
      metric: Localized('100+ students supported', '100+ طلبہ کی معاونت'),
      icon: Icons.school_rounded,
      gradient: [Color(0xFFA855F7), Color(0xFFEC4899)],
    ),
  ];

  /// The donate-screen cause each programme maps to.
  static const programCauses = [
    Cause.food,
    Cause.relief,
    Cause.general,
    Cause.education,
  ];

  // Stories ----------------------------------------------------------------------
  static const story = Story(
    name: 'Nasreen Akhtar',
    role: Localized('Beneficiary', 'مستفید'),
    location: Localized('Karachi, Pakistan', 'کراچی، پاکستان'),
    quote: Localized(
      'Rah-E-Haq changed my life. Through their food distribution program, my family no longer worries about where our next meal will come from. The volunteers treated us with such dignity and respect.',
      'راہِ حق نے میری زندگی بدل دی۔ ان کے راشن پروگرام کی بدولت میرے خاندان کو اب اگلے وقت کے کھانے کی فکر نہیں رہی۔ رضاکاروں نے ہمارے ساتھ نہایت عزت اور احترام سے پیش آیا۔',
    ),
    photo: 'assets/images/story-portrait.jpg',
  );

  // Donation scale ----------------------------------------------------------------
  static const tiers = [
    DonationTier(
      500,
      Localized(
        'Provides a meal for a family of 4',
        'چار افراد کے خاندان کے لیے ایک وقت کا کھانا',
      ),
    ),
    DonationTier(
      2000,
      Localized(
        'Monthly food ration for one family',
        'ایک خاندان کے لیے ماہانہ راشن',
      ),
    ),
    DonationTier(
      5000,
      Localized('School supplies for one child', 'ایک بچے کے لیے تعلیمی سامان'),
    ),
    DonationTier(
      10000,
      Localized(
        'Medical supplies for community camp',
        'کمیونٹی کیمپ کے لیے طبی سامان',
      ),
    ),
    DonationTier(
      25000,
      Localized(
        'Sponsor education for one child/month',
        'ایک بچے کی ماہانہ تعلیمی کفالت',
      ),
    ),
  ];

  /// The largest tier the amount covers, used for the "your gift provides" hint.
  static DonationTier? tierFor(int amount) {
    DonationTier? match;
    for (final tier in tiers) {
      if (amount >= tier.amount) match = tier;
    }
    return match;
  }

  // Recent activities ---------------------------------------------------------------
  static const activities = [
    Activity(
      title: Localized('Ramadan Food Drive', 'رمضان راشن مہم'),
      description: Localized(
        'Distributed 500 food packages',
        '500 راشن پیکج تقسیم کیے گئے',
      ),
      period: Localized('June 2024', 'جون 2024'),
      reach: Localized('500 families', '500 خاندان'),
    ),
    Activity(
      title: Localized('School Supply Distribution', 'تعلیمی سامان کی تقسیم'),
      description: Localized(
        'Provided materials to 200 students',
        '200 طلبہ کو تعلیمی سامان فراہم کیا گیا',
      ),
      period: Localized('May 2024', 'مئی 2024'),
      reach: Localized('200 students', '200 طلبہ'),
    ),
    Activity(
      title: Localized('Community Health Camp', 'کمیونٹی ہیلتھ کیمپ'),
      description: Localized('Free medical checkups', 'مفت طبی معائنہ'),
      period: Localized('April 2024', 'اپریل 2024'),
      reach: Localized('300 patients', '300 مریض'),
    ),
    Activity(
      title: Localized('Eid Gift Program', 'عید تحائف پروگرام'),
      description: Localized(
        'Gifts for underprivileged children',
        'مستحق بچوں کے لیے تحائف',
      ),
      period: Localized('March 2024', 'مارچ 2024'),
      reach: Localized('150 children', '150 بچے'),
    ),
  ];

  // Donation history for the signed-in donor ---------------------------------------------
  static final seedDonations = [
    Donation(
      reference: 'RAH-26-1048',
      amount: 5000,
      cause: Cause.food,
      method: PaymentMethod.jazzcash,
      date: DateTime(2026, 10, 25, 18, 42),
      status: DonationStatus.pending,
      donorName: donorName,
      email: donorEmail,
      phone: donorPhone,
      campaignId: 'ramadan-ration-drive',
      message: 'For the families in Lyari. May Allah accept it.',
      screenshotName: 'IMG_2041.jpg',
    ),
    Donation(
      reference: 'RAH-26-1031',
      amount: 52500,
      cause: Cause.zakat,
      method: PaymentMethod.bank,
      date: DateTime(2026, 10, 12, 11, 5),
      status: DonationStatus.verified,
      donorName: donorName,
      email: donorEmail,
      screenshotName: 'HBL-transfer-1012.png',
      reviewedAt: DateTime(2026, 10, 12, 16, 30),
    ),
    Donation(
      reference: 'RAH-26-0987',
      amount: 2000,
      cause: Cause.education,
      method: PaymentMethod.easypaisa,
      date: DateTime(2026, 9, 28, 20, 14),
      status: DonationStatus.verified,
      donorName: donorName,
      email: donorEmail,
      campaignId: 'school-supplies',
      screenshotName: 'Screenshot_0928.png',
      reviewedAt: DateTime(2026, 9, 29, 10, 2),
    ),
    Donation(
      reference: 'RAH-26-0954',
      amount: 10000,
      cause: Cause.healthcare,
      method: PaymentMethod.bank,
      date: DateTime(2026, 9, 14, 9, 30),
      status: DonationStatus.rejected,
      donorName: donorName,
      email: donorEmail,
      campaignId: 'health-camp',
      screenshotName: 'IMG_1877.jpg',
      reviewedAt: DateTime(2026, 9, 15, 12, 45),
      reviewNote: Localized(
        'The screenshot shows Rs. 1,000, not Rs. 10,000. Please upload the correct confirmation.',
        'اسکرین شاٹ میں 1,000 روپے درج ہیں، 10,000 نہیں۔ براہ کرم درست رسید اپ لوڈ کریں۔',
      ),
    ),
    Donation(
      reference: 'RAH-26-0912',
      amount: 1000,
      cause: Cause.general,
      method: PaymentMethod.easypaisa,
      date: DateTime(2026, 8, 30, 13, 20),
      status: DonationStatus.verified,
      donorName: donorName,
      email: donorEmail,
      screenshotName: 'Screenshot_0830.png',
      reviewedAt: DateTime(2026, 8, 30, 17, 10),
    ),
    Donation(
      reference: 'RAH-26-0876',
      amount: 25000,
      cause: Cause.relief,
      method: PaymentMethod.bank,
      date: DateTime(2026, 8, 9, 16, 55),
      status: DonationStatus.verified,
      donorName: donorName,
      email: donorEmail,
      screenshotName: 'transfer-receipt.pdf.png',
      reviewedAt: DateTime(2026, 8, 10, 9, 15),
    ),
    Donation(
      reference: 'RAH-26-0840',
      amount: 2000,
      cause: Cause.food,
      method: PaymentMethod.jazzcash,
      date: DateTime(2026, 7, 21, 19, 3),
      status: DonationStatus.verified,
      donorName: donorName,
      email: donorEmail,
      screenshotName: 'IMG_1502.jpg',
      reviewedAt: DateTime(2026, 7, 22, 11, 40),
    ),
  ];
}
