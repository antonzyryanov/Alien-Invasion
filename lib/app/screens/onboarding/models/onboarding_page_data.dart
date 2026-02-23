import 'package:alien_invasion/localizations/app_localizations.dart';

class OnboardingPageData {
  const OnboardingPageData({required this.text, required this.imagePath});

  final String text;
  final String imagePath;

  static List<OnboardingPageData> items(AppLocalizations localizations) => [
    OnboardingPageData(
      text: localizations.t('onboardingPage1'),
      imagePath: 'assets/images/app_icon/app_icon.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage2'),
      imagePath: 'assets/images/ships/ship_1.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage3'),
      imagePath: 'assets/images/enemies/enemy_1.png',
    ),
    OnboardingPageData(
      text: localizations.t('onboardingPage4'),
      imagePath: 'assets/images/onboarding/use_gyroscope.png',
    ),
  ];
}
