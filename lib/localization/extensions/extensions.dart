import 'package:flutter/material.dart';
import 'package:localization_testing/localization/last.dart';
import 'package:localization_testing/localization/manager/manager.dart';

/// Extension on String to provide easy access to translation methods.
///
/// This extension adds two methods, `tr` and `trParams`, to the String class,
/// allowing you to easily translate strings using the `LocalizationManager` provided by the `LocalizationProvider`.
extension LocalizedStringExt on String {
  /// Translates the string key using the `LocalizationManager` from the provided context.
  ///
  /// This method uses the `LocalizationManager` from the nearest `LocalizationProvider`
  /// in the widget tree to translate the string key. If the key is not found, the default
  /// not found text is returned.
  ///
  /// - Parameters:
  ///   - context: The `BuildContext` used to find the `LocalizationProvider` and `LocalizationManager`.
  ///
  /// - Returns: The translated string, or the default not found text if the key is not found.
  String tr([BuildContext? context]) {
    return LocalizationProvider.of(context).translate(this);
  }

  /// Translates the string key with parameters using the `LocalizationManager` from the provided context.
  ///
  /// This method uses the `LocalizationManager` from the nearest `LocalizationProvider`
  /// in the widget tree to translate the string key with the given parameters. Placeholders in the
  /// translation string are replaced with the values from the `params` map. If the key is not found,
  /// the default not found text is returned.
  ///
  /// - Parameters:
  ///   - context: The `BuildContext` used to find the `LocalizationProvider` and `LocalizationManager`.
  ///   - params: A map of parameters to replace placeholders in the translation string.
  ///
  /// - Returns: The translated string with parameters, or the default not found text if the key is not found.
  String trParams(Map<String, dynamic> params, [BuildContext? context]) {
    return LocalizationProvider.of(context).translateWithParams(this, params);
  }
}



/// Extension on the Text widget to facilitate the creation of text widgets with localized strings.
///
/// This extension adds methods to the Text widget that simplify the process of creating text
/// with localized content from the localization provider. It leverages other extensions that
/// must be defined on String to fetch localized content, like `LocalizedStringExt`.
///
/// Examples:
/// ```dart
/// Text('hello').tr(context)
/// Text('welcome_message').trParams(context, params: {'userName': 'Alice'})
/// ```
extension LocalizedTextExt on Text {
  /// Creates a Text widget with a localized string obtained from the given context.
  ///
  /// This method enhances the Text widget by allowing for the easy integration of localized
  /// strings. It automatically fetches the translated string using the key provided in the
  /// data property of the Text widget.
  ///
  /// Parameters:
  ///   - context: The BuildContext to access the localization provider.
  ///   - style: An optional TextStyle to apply to the Text widget. Inherits the style from
  ///     the original Text widget if not specified.
  ///   - textAlign: An optional TextAlign to define how the text is aligned. Inherits the
  ///     alignment from the original Text widget if not specified.
  ///   - overflow: How visual overflow should be handled. Inherits the overflow setting
  ///     from the original Text widget if not specified.
  ///
  /// Returns:
  ///   A Text widget displaying the localized string.
  Text tr(BuildContext context) {
    return Text(
      data!.tr(context), // `data` is assumed to be a String (the text content of this widget).
      style: style,
      textAlign: textAlign,
      overflow: overflow,
    );
  }

  /// Creates a Text widget with a localized string obtained from the given context and formatted with parameters.
  ///
  /// This method is similar to `tr`, but it allows for dynamic substitution of parameters within the
  /// localized string. This is useful for strings that need to be formatted with specific values,
  /// such as user names, dates, numbers, etc.
  ///
  /// Parameters:
  ///   - context: The BuildContext to access the localization provider.
  ///   - params: A map of parameters to replace placeholders in the localized string.
  ///   - style: An optional TextStyle to apply to the Text widget. Inherits the style from
  ///     the original Text widget if not specified.
  ///   - textAlign: An optional TextAlign to define how the text is aligned. Inherits the
  ///     alignment from the original Text widget if not specified.
  ///   - overflow: How visual overflow should be handled. Inherits the overflow setting
  ///     from the original Text widget if not specified.
  ///
  /// Returns:
  ///   A Text widget displaying the localized string with parameters.
  Text trParams({required Map<String, dynamic> params, BuildContext? context}) {
    return Text(
      data!.trParams(params, context),
      style: style,
      textAlign: textAlign,
      overflow: overflow,
    );
  }
}


/// Extends [BuildContext] to provide easy access to [LocalizationManager] methods.
///
/// This extension adds several convenience methods to any [BuildContext],
/// facilitating the management of localization actions directly from the context.
extension LocalizationExt on BuildContext {
  /// Retrieves the [LocalizationManager] from the nearest [LocalizationProvider] in the widget tree.
  ///
  /// This property makes it simpler to access the [LocalizationManager] without repeatedly
  /// having to type the full [LocalizationProvider.of] call.
  LocalizationManager get locManager => LocalizationProvider.of(this);

  /// Adds a translation resource by its name.
  ///
  /// This method searches for a [SupportedTranslation] by name within the current locale's
  /// supported translations and initiates its loading.
  ///
  /// [name] The unique name of the translation to be added.
  void addTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.addTranslation(this,translation);
  }

  /// Removes a translation resource by its name.
  ///
  /// This method finds the specified [SupportedTranslation] within the current locale's
  /// translations and initiates its removal.
  ///
  /// [name] The unique name of the translation to be removed.
  void removeTranslation(String name) {
    var translation = locManager.supportedLocales
        .firstWhere((l) => l.locale == locManager.currentLocale)
        .translations
        .firstWhere((t) => t.name == name);
    locManager.removeTranslation(this,translation);
  }

  /// Changes the application's current locale.
  ///
  /// This method triggers a change in the locale used by the [LocalizationManager],
  /// resulting in the loading of new translations appropriate to the [newLocale].
  ///
  /// [newLocale] The new locale to which the application should switch.
  void changeLocale(Locale newLocale) {
    locManager.changeLocale(this,newLocale);
  }
}