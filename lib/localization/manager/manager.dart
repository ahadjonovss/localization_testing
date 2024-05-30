import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localization_testing/localization/data/models.dart';
import 'package:localization_testing/localization/helpers/logger.dart';

class LocalizationManager extends ChangeNotifier{

  static late  LocalizationManager instance ;

  BuildContext? context;

  static init({
    required List<SupportedLocale> supportedLocales,
    BuildContext? context,
    required Locale initialLocale,
    required List<String> initialTranslations,
     required bool debugMode,
    String defaultNotFoundText = 'Translation not found',
}){
    instance = LocalizationManager._(
      supportedLocales: supportedLocales,
      initialLocale: initialLocale,
      context: context,
      initialTranslations: initialTranslations,
      debugMode: debugMode,
      defaultNotFoundText: defaultNotFoundText,

    );
    return instance;
  }
  final Map<String, String> _localizedStrings = {};

  final Set<String> _includedTranslations = {};

  Locale currentLocale;

  final List<SupportedLocale> supportedLocales;

  final bool debugMode;

  final Logger logger;

  String defaultNotFoundText;

  LocalizationManager._({
    required this.supportedLocales,
    required Locale initialLocale,
    this.context,
    required List<String> initialTranslations,
    required this.debugMode,
    this.defaultNotFoundText = 'Translation not found',
  })  : currentLocale = initialLocale,
        logger = Logger(debugMode: debugMode) {
    loadInitialTranslations(initialLocale, initialTranslations.toSet());
  }
  void loadInitialTranslations(Locale locale, Set<String> initialTranslations) {
    logger.log(
        "Loading initial translations for locale: ${locale.toLanguageTag()}",
        type: LogType.init);
    for (String name in initialTranslations) {
      var translation = supportedLocales
          .firstWhere((l) => l.locale == locale)
          .translations
          .firstWhere((t) => t.name == name);
      loadTranslation(translation);
    }
  }

  Future<void> loadTranslation(SupportedTranslation translation) async {
    logger.log("Loading translation: ${translation.name}", type: LogType.info);
    try {
      final data = await rootBundle.loadString(translation.path);
      Map<String, dynamic> jsonMap = json.decode(data);
      _localizedStrings.addAll(flattenJsonMap(jsonMap));
      _includedTranslations.add(translation.name);
      logger.log("Translation loaded: ${translation.name}", type: LogType.info);
      notifyListeners();
    } catch (e) {
      logger.log("Error loading translation: ${e.toString()}",
          type: LogType.error);
    }
  }


  Map<String, String> flattenJsonMap(Map<String, dynamic> json,
      [String prefix = '']) {
    Map<String, String> flatMap = {};
    json.forEach((key, value) {
      String newPrefix = prefix.isEmpty ? key : "$prefix.$key";
      if (value is Map) {
        flatMap
            .addAll(flattenJsonMap(value as Map<String, dynamic>, newPrefix));
      } else {
        flatMap[newPrefix] = value.toString();
      }
    });
    return flatMap;
  }


  void addTranslation(SupportedTranslation translation) {
    if (!_includedTranslations.contains(translation.name)) {
      loadTranslation(translation);
      logger.log("Translation added: ${translation.name}",
          type: LogType.info);
      // (context as Element).markNeedsBuild();
    }
  }

  void removeTranslation(SupportedTranslation translation) {
    logger.log("Attempting to remove translation: ${translation.name}",
        type: LogType.info);
    rootBundle.loadString(translation.path).then((jsonString) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      List<String> keysToRemove = jsonMap.keys.toList();

      for (var key in keysToRemove) {
        _localizedStrings.remove(key);
        logger.log("Removed key: $key from translation: ${translation.name}",
            type: LogType.info);
      }

      _includedTranslations.remove(translation.name);
      logger.log("Translation removed: ${translation.name}",
          type: LogType.info);

      notifyListeners();


      // (context as Element).markNeedsBuild();
    }).catchError((error) {
      logger.log("Error removing translation: ${error.toString()}",
          type: LogType.error);
    });
  }


  void changeLocale( Locale newLocale) {
    logger.log("Changing locale to: ${newLocale.toLanguageTag()}",
        type: LogType.info);
    currentLocale = newLocale;
    loadInitialTranslations(newLocale, _includedTranslations);
    notifyListeners();

    // (context as Element).markNeedsBuild();
  }


  String translate(String key) {
    return _localizedStrings[key] ?? defaultNotFoundText;
  }


  String translateWithParams(String key, Map<String, dynamic> params) {
    String translation = translate(key);
    params.forEach((paramKey, value) {
      translation = translation.replaceAll('{$paramKey}', value.toString());
    });
    return translation;
  }



  @override
  bool operator ==(Object other) {
   print("SOlishtirilvotti");
    return _localizedStrings.length == (other as LocalizationManager)._localizedStrings.length;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => _localizedStrings.hashCode;

}
