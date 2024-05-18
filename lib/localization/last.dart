import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

class LocalizationManager {
  Map<String, String> _localizedStrings = {};
  Set<String> _includedTranslations = {};
  Locale currentLocale;
  final List<SupportedLocale> supportedLocales;
  final bool debugMode;

  LocalizationManager({
    required this.supportedLocales,
    required Locale initialLocale,
    required List<String> initialTranslations,
    required this.debugMode,
  }) : currentLocale = initialLocale {
    loadInitialTranslations(initialLocale, initialTranslations.toSet());
  }

  void _log(String message) {
    if (debugMode) {
      print("LocalizationManager: $message");
    }
  }

  void loadInitialTranslations(Locale locale, Set<String> initialTranslations) {
    _log("Loading initial translations for locale: ${locale.toLanguageTag()}");
    // _includedTranslations.clear();
    // _localizedStrings.clear();
    for (String name in initialTranslations) {
      var translation = supportedLocales
          .firstWhere((l) => l.locale == locale)
          .translations
          .firstWhere((t) => t.name == name);
      loadTranslation(translation);
    }
  }

  void loadTranslation(SupportedTranslation translation) {
    _log("Loading translation: ${translation.name}");
    Future<Null> jsonString =
        rootBundle.loadString(translation.path).then((data) {
      Map<String, dynamic> jsonMap = json.decode(data);
      _localizedStrings
          .addAll(jsonMap.map((key, value) => MapEntry(key, value.toString())));
      _includedTranslations.add(translation.name);
      _log("Translation loaded: ${translation.name}");
    });
  }

  void addTranslation(BuildContext context, SupportedTranslation translation) {
    if (!_includedTranslations.contains(translation.name)) {
      loadTranslation(translation);
      (context as Element).markNeedsBuild();
    }
  }

  void removeTranslation(
      BuildContext context, SupportedTranslation translation) {
    _log("Attempting to remove translation: ${translation.name}");
    rootBundle.loadString(translation.path).then((jsonString) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      List<String> keysToRemove = jsonMap.keys.toList();

      // Now remove these keys from _localizedStrings
      keysToRemove.forEach((key) {
        _localizedStrings.remove(key);
        _log("Removed key: $key from translation: ${translation.name}");
      });

      // Also remove the translation name from the list of included translations
      _includedTranslations.remove(translation.name);
      _log("Translation removed: ${translation.name}");

      // Inform the widget tree about the update
      (context as Element).markNeedsBuild();
    }).catchError((error) {
      _log("Error removing translation: ${error.toString()}");
    });
  }

  void changeLocale(BuildContext context, Locale newLocale) {
    _log("Changing locale to: ${newLocale.toLanguageTag()}");
    currentLocale = newLocale;
    print("MANA INCLUDED TRLAR $_includedTranslations");
    loadInitialTranslations(newLocale, _includedTranslations);
    (context as Element).markNeedsBuild();
  }

  String translate(String key) {
    return _localizedStrings[key] ?? 'Translation not found';
  }
}

extension LocalizationExt on BuildContext {
  LocalizationManager get locManager => LocalizationProvider.of(this);

  void addTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.addTranslation(this, translation);
  }

  void removeTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.removeTranslation(this, translation);
  }

  void changeLocale(Locale newLocale) {
    locManager.changeLocale(this, newLocale);
  }
}

extension LocalizedStringExt on String {
  String tr(BuildContext context) {
    return LocalizationProvider.of(context).translate(this);
  }
}

class LocalizationProvider extends InheritedWidget {
  final LocalizationManager localizationManager;

  LocalizationProvider(
      {Key? key, required Widget child, required this.localizationManager})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(LocalizationProvider oldWidget) {
    return true;
  }

  static LocalizationManager of(BuildContext context) {
    final LocalizationProvider? result =
        context.dependOnInheritedWidgetOfExactType<LocalizationProvider>();
    if (result == null) {
      throw FlutterError('LocalizationProvider not found in context');
    }
    return result.localizationManager;
  }
}
