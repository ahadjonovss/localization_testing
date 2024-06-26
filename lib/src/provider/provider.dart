import 'package:flutter/material.dart';
import 'package:localization_testing/src/helpers/src/reassamble.dart';
import 'package:localization_testing/src/manager/localization_manager.dart';

import '../models/src/supported_translation.dart';
import '../models/src/translation.dart';
import '../models/src/supported_locale.dart';

/// Provides a localization manager to the widget tree.
///
/// This class uses the InheritedWidget pattern to propagate the localization manager
/// down the widget tree, allowing widgets to access localization functionalities
/// provided by [LocalizationManager].

// ignore: must_be_immutable
class LocalizationProvider extends InheritedWidget {
  /// The key used to access the [LocalizationProvider] instance.
  static GlobalKey instanceKey = GlobalKey();

  /// The localization manager that holds and manages all localization data.
  late final LocalizationManager _localizationManager;
  List<SupportedLocale> supportedLocales = [];

  List<SupportedTranslation> supportedTranslations;
  final Locale initialLocale;
  final List<String> initialTranslations;
  final bool debugMode;
  final bool saveLocale;

  /// Constructs a [LocalizationProvider] that exposes [localizationManager]
  /// to its descendants.
  ///
  /// [key] Identifies this widget in the widget tree.
  /// [child] The widget below this widget in the tree that can access the provided
  /// [localizationManager].
  /// [localizationManager] The single instance of [LocalizationManager] to be provided
  /// to all dependent widgets.
  LocalizationProvider(
      {Key? key,
      required Widget child,
      required this.initialTranslations,
      this.debugMode = false,
      required this.initialLocale,
      required this.supportedTranslations,
      this.saveLocale = false})
      : super(
            key: key ?? instanceKey,
            child: debugMode ? ReassembleListener(child: child) : child) {
    List<Locale> locales = supportedTranslations[0].paths.keys.toList();
    for (Locale locale in locales) {
      List<Translation> translations = [];
      for (SupportedTranslation tr in supportedTranslations) {
        translations
            .add(Translation(name: tr.name, path: tr.paths[locale].toString()));
      }
      SupportedLocale supLocale =
          SupportedLocale(locale: locale, translations: translations);
      supportedLocales.add(supLocale);
    }
    _localizationManager = LocalizationManager(
      supportedLocales: supportedLocales,
      initialLocale: initialLocale,
      initialTranslations: initialTranslations,
      debugMode: debugMode,
    );
  }

  /// Determines whether the framework should notify widgets that inherit from this widget.
  ///
  /// In this case, always returns true as any changes in the [LocalizationManager] should
  /// trigger updates in dependent widgets.
  @override
  bool updateShouldNotify(LocalizationProvider oldWidget) {
    return true;
  }

  /// Provides access to the nearest [LocalizationManager] up the widget tree.
  ///
  /// Throws [FlutterError] if no [LocalizationProvider] is found in the widget tree,
  /// ensuring that usage of the localization functionalities cannot proceed without a
  /// properly configured provider.
  ///
  /// [context] The build context which will be used to look up the [LocalizationProvider].
  /// Retrieves the `LocalizationManager` instance associated with the nearest `LocalizationProvider` up the widget tree.
  ///
  /// This static method tries to obtain a `LocalizationProvider` from the widget tree starting from the provided `context`.
  /// If `context` is null, it defaults to the current context held by `instanceKey`. If the `LocalizationProvider` is not
  /// found, a `FlutterError` is thrown.
  ///
  /// Parameters:
  ///   - `context` [BuildContext?]: Optional. The context from which to start looking for the `LocalizationProvider`.
  ///     If null, the method uses a default context from `instanceKey`.
  ///
  /// Returns:
  ///   - [LocalizationManager]: The `LocalizationManager` provided by the found `LocalizationProvider`.
  ///
  /// Throws:
  ///   - [FlutterError]: If no `LocalizationProvider` is found either in the given context or the default context.
  static LocalizationManager of(BuildContext? context) {
    final LocalizationProvider? result;

    // Check for LocalizationProvider starting from the provided context or default context.
    if (context != null) {
      result =
          context.dependOnInheritedWidgetOfExactType<LocalizationProvider>();
    } else {
      result = instanceKey.currentContext
          ?.dependOnInheritedWidgetOfExactType<LocalizationProvider>();
    }

    // If no LocalizationProvider is found, throw an error.
    if (result == null) {
      throw FlutterError('LocalizationProvider not found in context');
    }

    // Return the LocalizationManager from the found LocalizationProvider.
    return result._localizationManager;
  }
}
