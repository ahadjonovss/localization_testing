import 'package:flutter/material.dart';
import 'package:localization_testing/localization/last.dart';
import 'package:localization_testing/localization/manager/manager.dart';

/// Extension on Text widget to simplify the creation of localized text.
extension LocalizedTextExtText on Text {
  /// Creates a Text widget with a localized string obtained from the given context.
  /// This method directly uses the `tr` method provided by the `LocalizedStringExt` extension.
  ///
  /// - Parameters:
  ///   - key: The key used to look up the localized value.
  ///   - context: The BuildContext to access the localization provider.
  ///   - style: An optional TextStyle to apply to the Text widget.
  ///   - textAlign: An optional TextAlign to define how the text is aligned.
  ///   - overflow: How visual overflow should be handled.
  ///
  /// - Returns: A Text widget displaying the localized string.
  Text tr() {
    return Text(
      (data!).tr(),
      style: style,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  /// Creates a Text widget with a localized string obtained from the given context and formatted with parameters.
  /// This method directly uses the `trParams` method provided by the `LocalizedStringExt` extension.
  ///
  /// - Parameters:
  ///   - key: The key used to look up the localized value.
  ///   - params: A map of parameters to replace placeholders in the localized string.
  ///   - context: The BuildContext to access the localization provider.
  ///   - style: An optional TextStyle to apply to the Text widget.
  ///   - textAlign: An optional TextAlign to define how the text is aligned.
  ///   - overflow: How visual overflow should be handled.
  ///
  /// - Returns: A Text widget displaying the localized string with parameters.
  Text trParams(BuildContext context, {required Map<String, dynamic> params}) {
    return Text(
      data!.trParams(params),
      style: style,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}

extension LocalizationExtContext on BuildContext {
  LocalizationManager get locManager => LocalizationManager.instance;

  void addTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.addTranslation(translation);
  }

  void removeTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.removeTranslation(translation);
  }

  void changeLocale(Locale newLocale) {
    locManager.changeLocale(newLocale);
  }
}


extension LocalizationExt on String {
  String tr() => LocalizationManager.instance.translate(this);
  String trParams(Map<String, dynamic> params) => LocalizationManager.instance.translateWithParams(this, params);
}