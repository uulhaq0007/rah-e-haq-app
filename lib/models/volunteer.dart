/// Values stored for a volunteer application. Chip values stay in English
/// (as on the web platform) so records are consistent across languages; the
/// screen maps them to translated labels by index.
const volunteerCities = [
  'Karachi',
  'Lahore',
  'Islamabad',
  'Rawalpindi',
  'Peshawar',
  'Quetta',
  'Multan',
  'Faisalabad',
  'Other',
];

const volunteerSkills = [
  'Teaching',
  'Medical',
  'Fundraising',
  'Logistics',
  'Photography',
  'Social Media',
  'Cooking',
  'Driving',
  'Translation',
  'Administration',
];

const volunteerInterests = [
  'Food Distribution',
  'Education Support',
  'Healthcare',
  'Emergency Relief',
  'Community Development',
];

const volunteerAvailability = ['weekdays', 'weekends', 'evenings', 'flexible'];

class VolunteerApplication {
  String fullName = '';
  String email = '';
  String phone = '';
  String? city;
  String age = '';
  final Set<String> skills = {};
  final Set<String> interests = {};
  final Set<String> availability = {};
  double hoursPerWeek = 6;
  String motivation = '';
  String experience = '';

  bool get personalComplete =>
      fullName.trim().isNotEmpty &&
      email.contains('@') &&
      phone.trim().length >= 7 &&
      city != null;

  bool get skillsComplete => skills.isNotEmpty && interests.isNotEmpty;

  bool get availabilityComplete =>
      availability.isNotEmpty && motivation.trim().isNotEmpty;
}
