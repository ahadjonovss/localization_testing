import 'dart:ui';

class SupportedTranslation {
  final String name;
  final String path;

  SupportedTranslation({required this.name, required this.path});
}

class SupportedLocale {
  final Locale locale;
  final List<SupportedTranslation> translations;

  SupportedLocale({required this.locale, required this.translations});
}