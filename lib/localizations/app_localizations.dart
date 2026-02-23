import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ru')];

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final localizations = Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    );
    if (localizations == null) {
      throw StateError('AppLocalizations not found in context');
    }
    return localizations;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Alien Invasion',
      'enterNameTitle': 'Enter player name',
      'enterNameHint': 'Your name',
      'continue': 'Continue',
      'desertStormLevel': 'Desert Storm',
      'operationDuneLevel': 'Operation Dune',
      'operationVortexLevel': 'Operation Vortex',
      'operationShieldLevel': 'Operation Shield',
      'arabianNightsLevel': 'Arabian Nights',
      'bestScores': 'Best scores',
      'instructions': 'Instructions',
      'settings': 'Settings',
      'lives': 'Lives',
      'points': 'Points',
      'time': 'Time',
      'gameOver': 'Game Over',
      'backToMainMenu': 'Back to Main Menu',
      'scoreValue': 'Score',
      'language': 'Language',
      'sound': 'Sound',
      'english': 'English',
      'russian': 'Russian',
      'noScores': 'No scores yet',
      'sessionEnded': 'Session ended',
      'onboardingPage1': 'There has been an alien invasion on Earth!',
      'onboardingPage2': 'Fly the plane and destroy enemies!',
      'onboardingPage3':
          'Use your ammunition to shoot enemies and score points.',
      'onboardingPage4': 'Use the device\'s gyroscope to control the aircraft',
    },
    'ru': {
      'appTitle': 'Нашествие пришельцев',
      'enterNameTitle': 'Введите имя игрока',
      'enterNameHint': 'Ваше имя',
      'continue': 'Продолжить',
      'desertStormLevel': 'Пустынный шторм',
      'operationDuneLevel': 'Операция Дюна',
      'operationVortexLevel': 'Операция Вихрь',
      'operationShieldLevel': 'Операция Щит',
      'arabianNightsLevel': 'Арабские ночи',
      'bestScores': 'Лучшие результаты',
      'instructions': 'Инструкция',
      'settings': 'Настройки',
      'lives': 'Жизни',
      'points': 'Очки',
      'time': 'Время',
      'gameOver': 'Игра окончена',
      'backToMainMenu': 'Назад в главное меню',
      'scoreValue': 'Результат',
      'language': 'Язык',
      'sound': 'Звук',
      'english': 'Английский',
      'russian': 'Русский',
      'noScores': 'Результатов пока нет',
      'sessionEnded': 'Сессия завершена',
      'onboardingPage1': 'Произошло нашествие пришельцев на Землю!',
      'onboardingPage2': 'Управляйте самолетом и уничтожайте врагов!',
      'onboardingPage3':
          'Используйте боеприпасы, чтобы сбивать врагов и набирать очки.',
      'onboardingPage4':
          'Используйте гироскоп устройства для управления самолетом.',
    },
  };

  String t(String key) {
    final code = locale.languageCode;
    return _localizedValues[code]?[key] ?? _localizedValues['en']![key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales.any(
    (supportedLocale) => supportedLocale.languageCode == locale.languageCode,
  );

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
