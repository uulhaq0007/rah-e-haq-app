/// Every string the app renders, in English and Urdu.
///
/// Copy is taken from the web platform's `i18n/translations.js` wherever the
/// same text exists there; mobile-only strings follow the same voice. Each
/// getter carries both languages, so a missing translation cannot compile.
class S {
  const S(this.isUrdu);

  final bool isUrdu;

  String _t(String en, String ur) => isUrdu ? ur : en;

  // Brand
  String get appName => _t('Rah-E-Haq', 'راہِ حق');
  String get tagline => _t('Building Hope Together', 'مل کر امید کی تعمیر');

  /// Label on the language switch: always names the *other* language.
  String get switchLanguage => _t('اردو', 'English');

  // Navigation
  String get navHome => _t('Home', 'صفحۂ اول');
  String get navDonate => _t('Donate', 'عطیہ');
  String get navZakat => _t('Zakat', 'زکوٰۃ');
  String get navVolunteer => _t('Volunteer', 'رضاکار');
  String get navProfile => _t('Profile', 'پروفائل');

  // Common
  String get seeAll => _t('See all', 'سب دیکھیں');
  String get back => _t('Back', 'واپس');
  String get continueLabel => _t('Continue', 'آگے بڑھیں');
  String get close => _t('Close', 'بند کریں');
  String get copy => _t('Copy', 'کاپی');
  String copied(String label) => _t('$label copied', '$label کاپی ہو گیا');
  String get goHome => _t('Go to homepage', 'صفحۂ اول پر جائیں');
  String get optional => _t('(optional)', '(اختیاری)');
  String get fullName => _t('Full Name', 'پورا نام');
  String get email => _t('Email Address', 'ای میل ایڈریس');
  String get phone => _t('Phone Number', 'فون نمبر');
  String get message => _t('Message', 'پیغام');
  List<String> get months => isUrdu
      ? const ['جنوری', 'فروری', 'مارچ', 'اپریل', 'مئی', 'جون', 'جولائی', 'اگست', 'ستمبر', 'اکتوبر', 'نومبر', 'دسمبر']
      : const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  // Hero
  String get heroBadge => _t('Join Our Mission Today', 'آج ہی ہمارے مشن کا حصہ بنیں');
  String get heroTitleLead => _t('Bringing', 'امید پہنچائیں');
  String get heroTitleHighlight => _t('Hope', 'اُن تک');
  String get heroTitleTail => _t('To Those In Need', 'جنہیں ضرورت ہے');
  String get heroSubtitle => _t(
        'At Rah-E-Haq, we believe every individual deserves dignity, care, and opportunity. Through compassion in action, we transform lives and build stronger communities.',
        'راہِ حق میں ہمارا ایمان ہے کہ ہر فرد عزت، دیکھ بھال اور موقع کا حق دار ہے۔ عملی ہمدردی کے ذریعے ہم زندگیاں بدلتے اور مضبوط معاشرے بناتے ہیں۔',
      );
  String get heroDonate => _t('Donate Now', 'ابھی عطیہ دیں');
  String get heroVolunteer => _t('Become a Volunteer', 'رضاکار بنیں');
  String get statMeals => _t('Meals Served', 'کھانے فراہم کیے');
  String get statVolunteers => _t('Volunteers', 'رضاکار');
  String get statEvents => _t('Community Events', 'کمیونٹی تقریبات');
  String get statInstitutions => _t('Welfare Institutions', 'فلاحی ادارے');

  // Home sections
  String get campaignsTitle => _t('Active Campaigns', 'جاری مہمات');
  String get campaignsSubtitle => _t('Every rupee counts', 'ہر روپیہ اہم ہے');
  String get raised => _t('Raised', 'جمع شدہ');
  String get goal => _t('Goal', 'ہدف');
  String percentFunded(int p) => _t('$p% funded', '$p% مکمل');
  String daysLeft(int n) => _t('$n days left', '$n دن باقی');
  String donorsCount(int n) => _t('$n donors', '$n عطیہ دہندگان');
  String get programsEyebrow => _t('Our Impact', 'ہمارے اثرات');
  String get programsTitleLead => _t('Making A Real', 'حقیقی تبدیلی');
  String get programsTitleHighlight => _t('Difference', 'کی جانب');
  String get foundedIn => _t('Founded in', 'قیام');
  String get communities => _t('Communities', 'کمیونٹیز');
  String get livesImpacted => _t('Lives Impacted', 'متاثرہ زندگیاں');
  String get storiesEyebrow => _t('Success Stories', 'کامیابی کی کہانیاں');
  String get storiesTitleLead => _t('Voices That', 'وہ آوازیں جو');
  String get storiesTitleHighlight => _t('Inspire Us', 'ہمیں حوصلہ دیتی ہیں');
  String get ctaEyebrow => _t('Join Our Growing Family', 'ہمارے بڑھتے خاندان کا حصہ بنیں');
  String get ctaTitleLead => _t('Your Hands Can', 'آپ کے ہاتھ');
  String get ctaTitleHighlight => _t('Change Lives', 'زندگیاں بدل سکتے ہیں');
  String get ctaSubtitle => _t(
        "Whether you can give your time, skills, or resources, there's a place for you in our mission.",
        'آپ وقت دیں، ہنر دیں یا وسائل — ہمارے مشن میں آپ کے لیے جگہ ہے۔',
      );
  String trusted(String count) => _t('Trusted by $count+ donors worldwide', 'دنیا بھر کے $count+ عطیہ دہندگان کا اعتماد');
  String get pledgeTitle => _t('100% Goes to Cause', '100% رقم مقصد پر');
  String get pledgeBody => _t(
        'Every rupee is used directly for community welfare. No admin fees deducted.',
        'ہر روپیہ براہِ راست فلاحِ عامہ پر خرچ ہوتا ہے۔ کوئی انتظامی کٹوتی نہیں۔',
      );
  String get donateToCause => _t('Donate to this cause', 'اس مقصد کے لیے عطیہ دیں');
  String get toggleTheme => _t('Toggle dark mode', 'ڈارک موڈ تبدیل کریں');

  // Campaigns
  String get allCampaigns => _t('All Campaigns', 'تمام مہمات');
  String get allCampaignsSubtitle => _t(
        'Choose a drive and see exactly where your money goes.',
        'کوئی مہم منتخب کریں اور دیکھیں آپ کی رقم کہاں خرچ ہوتی ہے۔',
      );
  String get aboutCampaign => _t('About this campaign', 'اس مہم کے بارے میں');
  String get yourImpact => _t('What your gift provides', 'آپ کا عطیہ کیا فراہم کرتا ہے');
  String get donateToCampaign => _t('Donate to this campaign', 'اس مہم میں عطیہ دیں');
  String stillNeeded(String amount) => _t('$amount still needed', '$amount مزید درکار');
  String get reachLabel => _t('Reach', 'رسائی');
  String get locationLabel => _t('Location', 'مقام');
  String get funded => _t('Funded', 'مکمل');
  String get donorsLabel => _t('Donors', 'عطیہ دہندگان');
  String get daysLeftLabel => _t('Days left', 'دن باقی');
  String get share => _t('Share', 'شیئر');
  String get linkCopied => _t('Campaign link copied', 'مہم کا لنک کاپی ہو گیا');
  String get verifiedNote => _t(
        'Every donation is checked by our team before it counts toward this total.',
        'ہر عطیہ اس مجموعے میں شامل ہونے سے پہلے ہماری ٹیم تصدیق کرتی ہے۔',
      );

  // Donate
  String get donateBadge => _t('Make a Difference Today', 'آج ہی تبدیلی لائیں');
  String get donateTitleLead => _t('Donate to', 'عطیہ دیں');
  String get donateTitleHighlight => _t('Rah-E-Haq', 'راہِ حق کو');
  String get donateSubtitle => _t(
        'Your generosity fuels our mission — helping communities across Pakistan with food, education, and hope.',
        'آپ کی سخاوت ہمارے مشن کو رواں رکھتی ہے — پاکستان بھر کی کمیونٹیز کو خوراک، تعلیم اور امید پہنچانے میں۔',
      );
  List<String> get donateSteps => isUrdu
      ? const ['رقم منتقل کریں', 'اسکرین شاٹ لیں', 'فارم جمع کرائیں']
      : const ['Transfer Amount', 'Take Screenshot', 'Fill & Submit'];
  String get amountTitle => _t('Donation Amount (PKR)', 'عطیے کی رقم (روپے)');
  String get customAmountHint => _t('Enter a custom amount', 'اپنی رقم درج کریں');
  String get impactLabel => _t('Your gift provides', 'آپ کا عطیہ فراہم کرے گا');
  String get causeTitle => _t('Choose a cause', 'مقصد منتخب کریں');
  List<String> get causeNames => isUrdu
      ? const ['عمومی فنڈ', 'زکوٰۃ', 'خوراک', 'تعلیم', 'صحت', 'ہنگامی امداد']
      : const ['General Fund', 'Zakat', 'Food', 'Education', 'Healthcare', 'Relief'];
  String forCampaign(String name) => _t('For: $name', 'برائے: $name');
  String get methodTitle => _t('Payment Method', 'طریقۂ ادائیگی');
  List<String> get methodNames => isUrdu
      ? const ['بینک ٹرانسفر', 'جاز کیش', 'ایزی پیسہ']
      : const ['Bank Transfer', 'JazzCash', 'Easypaisa'];
  String get transferTo => _t(
        'Transfer your donation to this account, then attach the screenshot below.',
        'اس اکاؤنٹ میں عطیہ منتقل کریں، پھر نیچے اسکرین شاٹ منسلک کریں۔',
      );
  String get iban => _t('Account Number (IBAN)', 'اکاؤنٹ نمبر (IBAN)');
  String get accountTitle => _t('Account Title', 'اکاؤنٹ ٹائٹل');
  String get bankName => _t('Bank Name', 'بینک کا نام');
  String get mobileNumber => _t('Mobile Number', 'موبائل نمبر');
  String get accountName => _t('Account Name', 'اکاؤنٹ کا نام');
  String get detailsTitle => _t('Your Details', 'آپ کی تفصیلات');
  String get screenshotTitle => _t('Payment Screenshot', 'ادائیگی کا اسکرین شاٹ');
  String get uploadPrompt => _t('Upload payment screenshot', 'ادائیگی کا اسکرین شاٹ اپ لوڈ کریں');
  String get uploadHint => _t('JPG, PNG or WebP · up to 5 MB', 'JPG، PNG یا WebP · زیادہ سے زیادہ 5 MB');
  String get pickerTitle => _t('Attach payment screenshot', 'ادائیگی کا اسکرین شاٹ منسلک کریں');
  String get pickerSubtitle => _t(
        'Pick the confirmation from your recent screenshots.',
        'حالیہ اسکرین شاٹس میں سے تصدیقی رسید منتخب کریں۔',
      );
  String get changeFile => _t('Change', 'تبدیل کریں');
  String get removeFile => _t('Remove', 'ہٹائیں');
  String get transferSuccessful => _t('Transfer successful', 'رقم کامیابی سے منتقل');
  String get submitDonation => _t('Submit Donation', 'عطیہ جمع کرائیں');
  String get submitting => _t('Submitting...', 'جمع کیا جا رہا ہے...');
  String get donateDisclaimer => _t(
        'By submitting, you confirm that the payment has been made. Our team will verify within 24 hours.',
        'جمع کرانے سے آپ تصدیق کرتے ہیں کہ ادائیگی ہو چکی ہے۔ ہماری ٹیم 24 گھنٹوں میں تصدیق کرے گی۔',
      );
  String get errAmount => _t('Please enter a donation amount.', 'براہ کرم عطیے کی رقم درج کریں۔');
  String get errName => _t('Please enter your full name.', 'براہ کرم اپنا پورا نام درج کریں۔');
  String get errEmail => _t('Please enter a valid email address.', 'براہ کرم درست ای میل ایڈریس درج کریں۔');
  String get errScreenshot => _t('Please attach your payment screenshot.', 'براہ کرم ادائیگی کا اسکرین شاٹ منسلک کریں۔');
  String get donateSuccessTitle => _t('Thank you for your donation!', 'آپ کے عطیے کا شکریہ!');
  String get donateSuccessBody => _t(
        'Your submission has been recorded. Our team will verify the payment within 24 hours.',
        'آپ کی درخواست محفوظ کر لی گئی ہے۔ ہماری ٹیم 24 گھنٹوں میں ادائیگی کی تصدیق کرے گی۔',
      );
  String get pendingVerification => _t('Pending admin verification', 'ایڈمن کی تصدیق زیرِ التوا');
  String get reference => _t('Reference', 'حوالہ نمبر');
  String get viewDonations => _t('View my donations', 'میرے عطیات دیکھیں');
  String get anotherDonation => _t('Make another donation', 'ایک اور عطیہ دیں');
  String get amountLabel => _t('Amount', 'رقم');
  String get causeLabel => _t('Cause', 'مقصد');
  String get methodLabel => _t('Method', 'طریقہ');
  String get dateLabel => _t('Date', 'تاریخ');
  String get statusLabel => _t('Status', 'حیثیت');
  String get campaignLabel => _t('Campaign', 'مہم');
  String get donorLabel => _t('Donor', 'عطیہ دہندہ');

  // Zakat
  String get zakatBadge => _t('Zakat Calculator 2026', 'زکوٰۃ کیلکولیٹر 2026');
  String get zakatTitleLead => _t('Calculate Your', 'اپنی زکوٰۃ');
  String get zakatTitleHighlight => _t('Zakat', 'شمار کریں');
  String ratesPill(String gold, String silver) =>
      _t('Gold $gold · Silver $silver per tola', 'سونا $gold · چاندی $silver فی تولہ');
  String get editRates => _t('Edit rates', 'شرحیں تبدیل کریں');
  String get payable => _t('Zakat Payable', 'قابلِ ادا زکوٰۃ');
  String get payableNote => _t('2.5% of your net zakatable wealth', 'آپ کے خالص مالِ زکوٰۃ کا 2.5%');
  String get zakatEmpty => _t('Enter your assets below to see your Zakat.', 'اپنی زکوٰۃ جاننے کے لیے نیچے اپنے اثاثے درج کریں۔');
  String get eligible => _t('Your wealth is above the nisab — Zakat is due.', 'آپ کا مال نصاب سے زیادہ ہے — زکوٰۃ واجب ہے۔');
  String get notEligible => _t('Your wealth is below the nisab — no Zakat is due this year.', 'آپ کا مال نصاب سے کم ہے — اس سال زکوٰۃ واجب نہیں۔');
  String get nisab => _t('Nisab Threshold', 'نصاب کی حد');
  String get nisabBasis => _t('Silver standard · 52.5 tola', 'چاندی کا معیار · 52.5 تولہ');
  String get netWorth => _t('Net Zakatable Wealth', 'خالص مالِ زکوٰۃ');
  String get totalAssets => _t('Total Assets', 'کل اثاثے');
  String get metalsTitle => _t('Gold & Silver', 'سونا اور چاندی');
  String get metalsHint => _t('Include all jewellery, coins & bars held for savings', 'بچت کے لیے رکھے تمام زیورات، سکے اور بسکٹ شامل کریں');
  String get gold => _t('Gold', 'سونا');
  String get silver => _t('Silver', 'چاندی');
  String get grams => _t('grams', 'گرام');
  String tolaEquivalent(String tola, String value) => _t('≈ $tola tola · $value', '≈ $tola تولہ · $value');
  String get cashTitle => _t('Cash & Savings', 'نقدی اور بچت');
  String get cashHint => _t('Include savings, current accounts and mobile wallets', 'سیونگ، کرنٹ اکاؤنٹ اور موبائل والیٹ شامل کریں');
  String get cashInHand => _t('Cash in hand', 'ہاتھ میں نقدی');
  String get bankSavings => _t('Bank & wallet savings', 'بینک و والیٹ کی بچت');
  String get businessTitle => _t('Business & Investments', 'کاروبار اور سرمایہ کاری');
  String get businessHint => _t('Trade goods, shares, and money owed to you', 'مالِ تجارت، حصص اور آپ کو واجب الادا رقوم');
  String get businessAssets => _t('Business assets', 'کاروباری اثاثے');
  String get liabilitiesTitle => _t('Debts & Deductions', 'قرض اور کٹوتیاں');
  String get liabilitiesHint => _t('Money you owe that is due within the year', 'وہ رقم جو آپ پر اس سال واجب الادا ہے');
  String get debtsDue => _t('Debts due this year', 'اس سال واجب الادا قرض');
  String get breakdown => _t('Breakdown', 'تفصیل');
  String get cashAndBank => _t('Cash & Bank', 'نقدی و بینک');
  String get debts => _t('Debts', 'قرض');
  String get donateZakat => _t('Donate Your Zakat', 'اپنی زکوٰۃ عطیہ کریں');
  String get startOver => _t('Start over', 'دوبارہ شروع کریں');
  String get zakatDisclaimer => _t(
        'This calculator is for guidance only. Consult a qualified Islamic scholar for a ruling specific to your situation.',
        'یہ کیلکولیٹر صرف رہنمائی کے لیے ہے۔ اپنی صورتحال کے مطابق فتویٰ کے لیے مستند عالمِ دین سے رجوع کریں۔',
      );
  String get ratesTitle => _t('Zakat rates', 'زکوٰۃ کی شرحیں');
  String get ratesHint => _t('Metal prices the Zakat calculator uses to work out the nisab.', 'دھاتوں کی قیمتیں جن سے کیلکولیٹر نصاب شمار کرتا ہے۔');
  String get goldPrice => _t('Gold price per tola (PKR)', 'سونے کی قیمت فی تولہ (روپے)');
  String get silverPrice => _t('Silver price per tola (PKR)', 'چاندی کی قیمت فی تولہ (روپے)');
  String get saveRates => _t('Save rates', 'شرحیں محفوظ کریں');
  String get resetRates => _t('Reset to defaults', 'اصل شرحیں بحال کریں');
  String get tolaNote => _t('1 tola = 11.66 g', '1 تولہ = 11.66 گرام');
  String get ratesSaved => _t('Zakat rates updated', 'زکوٰۃ کی شرحیں اپ ڈیٹ ہو گئیں');
  String get errRates => _t('Enter a price above zero for both metals.', 'دونوں دھاتوں کی قیمت صفر سے زیادہ درج کریں۔');

  // Volunteer
  String get volBadge => _t('Join the Movement', 'تحریک کا حصہ بنیں');
  String get volTitleLead => _t('Become a', 'بنیں ایک');
  String get volTitleHighlight => _t('Volunteer', 'رضاکار');
  String get volSubtitle => _t(
        'Join 500+ volunteers across Pakistan making a real difference in communities that need it most.',
        'پاکستان بھر کے 500+ رضاکاروں کے ساتھ شامل ہوں جو ضرورت مند کمیونٹیز میں حقیقی تبدیلی لا رہے ہیں۔',
      );
  String get activeVolunteers => _t('Active Volunteers', 'فعال رضاکار');
  String get citiesCovered => _t('Cities Covered', 'شہر');
  String get freeToJoin => _t('Free to Join', 'شمولیت مفت');
  List<String> get volSteps => isUrdu
      ? const ['ذاتی معلومات', 'ہنر و دلچسپی', 'دستیابی']
      : const ['Personal', 'Skills', 'Availability'];
  String stepOf(int current, int total) => _t('Step $current of $total', 'مرحلہ $current از $total');
  String get personalTitle => _t('Personal Information', 'ذاتی معلومات');
  String get personalSubtitle => _t(
        'Tell us a bit about yourself so we can match you with the right drives.',
        'اپنے بارے میں کچھ بتائیں تاکہ ہم آپ کو مناسب مہم کے ساتھ جوڑ سکیں۔',
      );
  String get city => _t('City', 'شہر');
  String get cityHint => _t('Select your city', 'اپنا شہر منتخب کریں');
  String get age => _t('Age', 'عمر');
  String get skillsStepTitle => _t('Skills & Interests', 'ہنر اور دلچسپیاں');
  String get skillsStepSubtitle => _t(
        'Let us know what you can offer and where you would like to help.',
        'بتائیے آپ کیا پیش کر سکتے ہیں اور کہاں مدد کرنا چاہیں گے۔',
      );
  String get skills => _t('Your skills', 'آپ کے ہنر');
  String get skillsHint => _t('Pick everything that applies', 'جو بھی لاگو ہوں منتخب کریں');
  String get interests => _t("Areas you'd like to work in", 'آپ کن شعبوں میں کام کرنا چاہیں گے');
  String selectedCount(int n) => _t('$n selected', '$n منتخب');
  String get availabilityStepTitle => _t('Availability & Motivation', 'دستیابی اور محرک');
  String get availabilityStepSubtitle => _t(
        'Let us know when you are free and what brings you here.',
        'بتائیے آپ کب دستیاب ہیں اور آپ کو یہاں کیا لایا۔',
      );
  String get availability => _t('Availability', 'دستیابی');
  String get hoursPerWeek => _t('Hours you can give per week', 'فی ہفتہ کتنے گھنٹے دے سکتے ہیں');
  String hoursValue(int n) => _t('$n hrs / week', '$n گھنٹے فی ہفتہ');
  String get motivation => _t('Why do you want to volunteer with Rah-E-Haq?', 'آپ راہِ حق کے ساتھ رضاکارانہ کام کیوں کرنا چاہتے ہیں؟');
  String get experience => _t('Previous volunteering experience', 'رضاکارانہ کام کا سابقہ تجربہ');
  String get volSubmit => _t('Submit Application', 'درخواست جمع کرائیں');
  String get volSuccessTitle => _t('Application received!', 'درخواست موصول ہو گئی!');
  String get volSuccessBody => _t(
        'Thank you for stepping forward. Our team will reach out to you within a few days.',
        'آگے بڑھنے کا شکریہ۔ ہماری ٹیم چند دنوں میں آپ سے رابطہ کرے گی۔',
      );
  String matchedCity(String city) => _t("We'll match you with drives in $city.", 'ہم آپ کو $city کی مہمات سے جوڑیں گے۔');
  String get backHome => _t('Back to home', 'صفحۂ اول پر واپس');
  String get newApplication => _t('Start a new application', 'نئی درخواست شروع کریں');
  String get errPersonal => _t(
        'Please fill in your name, a valid email, phone and city.',
        'براہ کرم نام، درست ای میل، فون اور شہر درج کریں۔',
      );
  String get errSkills => _t('Pick at least one skill and one area.', 'کم از کم ایک ہنر اور ایک شعبہ منتخب کریں۔');
  String get errAvailability => _t(
        'Choose your availability and tell us your motivation.',
        'اپنی دستیابی منتخب کریں اور اپنا محرک بتائیں۔',
      );
  List<String> get skillOptions => isUrdu
      ? const ['تدریس', 'طبی', 'فنڈ ریزنگ', 'لاجسٹکس', 'فوٹوگرافی', 'سوشل میڈیا', 'کھانا پکانا', 'ڈرائیونگ', 'ترجمہ', 'انتظامی امور']
      : const ['Teaching', 'Medical', 'Fundraising', 'Logistics', 'Photography', 'Social Media', 'Cooking', 'Driving', 'Translation', 'Administration'];
  List<String> get interestOptions => isUrdu
      ? const ['کھانے کی تقسیم', 'تعلیمی معاونت', 'صحت کی سہولیات', 'ہنگامی امداد', 'کمیونٹی کی ترقی']
      : const ['Food Distribution', 'Education Support', 'Healthcare', 'Emergency Relief', 'Community Development'];
  List<String> get availabilityOptions => isUrdu
      ? const ['کام کے دن', 'ہفتہ وار تعطیل', 'شام', 'لچکدار']
      : const ['Weekdays', 'Weekends', 'Evenings', 'Flexible'];
  List<String> get cityNames => isUrdu
      ? const ['کراچی', 'لاہور', 'اسلام آباد', 'راولپنڈی', 'پشاور', 'کوئٹہ', 'ملتان', 'فیصل آباد', 'دیگر']
      : const ['Karachi', 'Lahore', 'Islamabad', 'Rawalpindi', 'Peshawar', 'Quetta', 'Multan', 'Faisalabad', 'Other'];

  // Donation history
  String get myDonations => _t('My Donations', 'میرے عطیات');
  String get totalGiven => _t('Verified giving', 'تصدیق شدہ عطیات');
  String get all => _t('All', 'تمام');
  String get pending => _t('Pending', 'زیرِ التوا');
  String get verified => _t('Verified', 'تصدیق شدہ');
  String get rejected => _t('Rejected', 'مسترد');
  String get statusPending => _t('Pending verification', 'تصدیق زیرِ التوا');
  String donationsCount(int n) => _t('$n donations', '$n عطیات');
  String get countsNote => _t(
        'Only verified donations count toward your total.',
        'صرف تصدیق شدہ عطیات آپ کے مجموعے میں شامل ہوتے ہیں۔',
      );
  String get emptyList => _t('Nothing here yet.', 'ابھی یہاں کچھ نہیں۔');
  String get newDonation => _t('New donation', 'نیا عطیہ');

  // Donation receipt
  String get receiptTitle => _t('Donation Receipt', 'عطیے کی رسید');
  String get timelineSubmitted => _t('Screenshot submitted', 'اسکرین شاٹ جمع کرایا گیا');
  String get timelineReview => _t('Under admin review', 'ایڈمن کی جانچ جاری');
  String get timelineVerified => _t('Verified by admin', 'ایڈمن نے تصدیق کی');
  String get timelineRejected => _t('Rejected by admin', 'ایڈمن نے مسترد کیا');
  String get pendingInfo => _t('Our team will verify the payment within 24 hours.', 'ہماری ٹیم 24 گھنٹوں میں ادائیگی کی تصدیق کرے گی۔');
  String get verifiedInfo => _t(
        'Thank you! This donation now counts toward our programmes.',
        'شکریہ! یہ عطیہ اب ہمارے پروگراموں میں شامل ہے۔',
      );
  String get adminNote => _t('Admin note', 'ایڈمن کا نوٹ');
  String get resubmit => _t('Resubmit donation', 'عطیہ دوبارہ جمع کرائیں');
  String get donateAgain => _t('Donate again', 'دوبارہ عطیہ دیں');
  String get copyReference => _t('Copy reference', 'حوالہ نمبر کاپی کریں');

  // Profile
  String donorSince(int year) => _t('Donor since $year', '$year سے عطیہ دہندہ');
  String get donationsLabel => _t('Donations', 'عطیات');
  String get preferences => _t('Preferences', 'ترجیحات');
  String get language => _t('Language', 'زبان');
  String get languageHint => _t('English or Urdu, right-to-left', 'اردو یا انگریزی');
  String get darkMode => _t('Dark mode', 'ڈارک موڈ');
  String get darkModeHint => _t('Easier on the eyes at night', 'رات میں آنکھوں کے لیے آرام دہ');
  String get myActivity => _t('My activity', 'میری سرگرمی');
  String get zakatCalculator => _t('Zakat calculator', 'زکوٰۃ کیلکولیٹر');
  String get volunteerWithUs => _t('Volunteer with us', 'ہمارے ساتھ رضاکار بنیں');
  String get organisation => _t('Organisation', 'ادارہ');
  String get aboutUs => _t('About Rah-E-Haq', 'راہِ حق کا تعارف');
  String get aboutUsHint => _t('Mission, transparency & activities', 'مشن، شفافیت اور سرگرمیاں');
  String get contactUs => _t('Contact us', 'ہم سے رابطہ کریں');
  String get contactUsHint => _t('Phone, email & working hours', 'فون، ای میل اور اوقاتِ کار');
  String version(String v) => _t('Version $v', 'ورژن $v');

  // About
  String get missionEyebrow => _t('Our Mission', 'ہمارا مشن');
  String get missionTitleLead => _t('Creating Lasting Change', 'دیرپا تبدیلی');
  String get missionTitleHighlight => _t('Through Compassion', 'ہمدردی کے ذریعے');
  String get missionBody => _t(
        'Rah-E-Haq is dedicated to uplifting underprivileged communities through comprehensive welfare programs. We believe that true progress is measured not by wealth, but by how we treat those who have the least.',
        'راہِ حق جامع فلاحی پروگراموں کے ذریعے پسماندہ طبقات کی بہتری کے لیے وقف ہے۔ ہمارا ماننا ہے کہ حقیقی ترقی دولت سے نہیں بلکہ اس سے ناپی جاتی ہے کہ ہم کمزور طبقے کے ساتھ کیسا سلوک کرتے ہیں۔',
      );
  String get visionTitle => _t('Our Vision', 'ہمارا وژن');
  String get visionBody => _t(
        'To build a society where every individual has access to basic necessities, quality education, and opportunities to thrive.',
        'ایسا معاشرہ تشکیل دینا جہاں ہر فرد کو بنیادی ضروریات، معیاری تعلیم اور آگے بڑھنے کے مواقع میسر ہوں۔',
      );
  String get valuesTitle => _t('Our Core Values', 'ہماری بنیادی اقدار');
  List<String> get values => isUrdu
      ? const ['ہر عمل میں ہمدردی', 'تمام معاملات میں شفافیت', 'کمیونٹی کو اوّلیت', 'پائیدار فلاحی پروگرام']
      : const ['Compassion in every action', 'Transparency in all operations', 'Community-first approach', 'Sustainable impact programs'];
  String get credTitleLead => _t('Transparency &', 'شفافیت اور');
  String get credTitleHighlight => _t('Accountability', 'جوابدہی');
  String get credSubtitle => _t(
        "We believe in complete transparency. Here's how your donations are making a difference.",
        'ہم مکمل شفافیت پر یقین رکھتے ہیں۔ دیکھیے آپ کے عطیات کہاں استعمال ہوتے ہیں۔',
      );
  String get fundsToPrograms => _t('Funds to Programs', 'پروگراموں پر خرچ');
  String get administrative => _t('Administrative', 'انتظامی اخراجات');
  String get transparency => _t('Transparency', 'شفافیت');
  String get donorRating => _t('Donor Rating', 'عطیہ دہندگان کی رائے');
  String get scaleTitle => _t('How Your Donation Helps', 'آپ کا عطیہ کیسے مدد کرتا ہے');
  String get activitiesTitle => _t('Recent Activities', 'حالیہ سرگرمیاں');
  String get activitiesSubtitle => _t('Stay updated with our work', 'ہمارے کام سے باخبر رہیں');
  String get galleryTitleLead => _t('Moments Of', 'اثرات کے');
  String get galleryTitleHighlight => _t('Impact', 'لمحات');

  // Contact
  String get contactTitleLead => _t("We'd Love To", 'ہم آپ سے');
  String get contactTitleHighlight => _t('Hear From You', 'سننا چاہیں گے');
  String get contactSubtitle => _t(
        "Have questions about our programs or want to get involved? Reach out and we'll get back to you as soon as possible.",
        'ہمارے پروگراموں کے بارے میں سوالات ہیں یا شامل ہونا چاہتے ہیں؟ ہم سے رابطہ کریں، ہم جلد جواب دیں گے۔',
      );
  String get hoursLabel => _t('Working Hours', 'اوقاتِ کار');
  String get mondayFriday => _t('Monday - Friday', 'پیر تا جمعہ');
  String get saturday => _t('Saturday', 'ہفتہ');
  String get sunday => _t('Sunday', 'اتوار');
  String get closed => _t('Closed', 'بند');
  String get tapToCopy => _t('Tap to copy', 'کاپی کرنے کے لیے ٹیپ کریں');
  String get sendUsMessage => _t('Send us a message', 'ہمیں پیغام بھیجیں');
  String get subject => _t('Subject', 'موضوع');
  String get sendMessage => _t('Send Message', 'پیغام بھیجیں');
  String get sending => _t('Sending...', 'بھیجا جا رہا ہے...');
  String get messageSentTitle => _t('Message sent!', 'پیغام بھیج دیا گیا!');
  String get messageSentBody => _t(
        "Thanks for reaching out. We'll get back to you as soon as possible.",
        'رابطہ کرنے کا شکریہ۔ ہم جلد از جلد آپ کو جواب دیں گے۔',
      );
  String get writeAnother => _t('Write another message', 'ایک اور پیغام لکھیں');
  String get errContact => _t(
        'Please add your name, a valid email and a message.',
        'براہ کرم اپنا نام، درست ای میل اور پیغام درج کریں۔',
      );
}
