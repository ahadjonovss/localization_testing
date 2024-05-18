import 'package:flutter/material.dart';
import 'package:localization_testing/localization/last.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  List<SupportedLocale> supportedLocales = [
    SupportedLocale(
      locale: const Locale('en', 'US'),
      translations: [
        SupportedTranslation(name: '1', path: 'assets/locales/en_US/1.json'),
        SupportedTranslation(name: '2', path: 'assets/locales/en_US/2.json'),
        SupportedTranslation(name: '3', path: 'assets/locales/en_US/3.json'),
        SupportedTranslation(name: '4', path: 'assets/locales/en_US/4.json'),
        SupportedTranslation(name: '5', path: 'assets/locales/en_US/5.json'),
        SupportedTranslation(name: '6', path: 'assets/locales/en_US/6.json'),
      ],
    ),
    SupportedLocale(
      locale: const Locale('uz', 'UZ'),
      translations: [
        SupportedTranslation(name: '1', path: 'assets/locales/uz_UZ/1.json'),
        SupportedTranslation(name: '2', path: 'assets/locales/uz_UZ/2.json'),
        SupportedTranslation(name: '3', path: 'assets/locales/uz_UZ/3.json'),
        SupportedTranslation(name: '4', path: 'assets/locales/uz_UZ/4.json'),
        SupportedTranslation(name: '5', path: 'assets/locales/uz_UZ/5.json'),
        SupportedTranslation(name: '6', path: 'assets/locales/uz_UZ/6.json'),
      ],
    ),
  ];

  LocalizationManager locManager = LocalizationManager(
    supportedLocales: supportedLocales,
    initialLocale: const Locale('en', 'US'),
    initialTranslations: ['1'],
    debugMode: false,
  );

  runApp(MyApp(localizationManager: locManager));
}

class MyApp extends StatelessWidget {
  final LocalizationManager localizationManager;

  MyApp({required this.localizationManager});

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      localizationManager: localizationManager,
      child: MaterialApp(
        title: 'Dynamic Localization Demo',
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget returnAddButton(String name, {bool isAdd = true}) {
      return TextButton(
          onPressed: () {
            if (isAdd) {
              context.addTranslation(name);
            } else {
              context.removeTranslation(name);
            }
          },
          child: Text('${isAdd ? '+' : '-'} $name'));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr(context)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title: ${'title'.tr(context)}'),
            Text('1:${'one'.tr(context)}'),
            Text('2:${'two'.tr(context)}'),
            Text('3:${'three'.tr(context)}'),
            Text('4:${'four'.tr(context)}'),
            Text('5:${'five'.tr(context)}'),
            Text('6:${'six'.tr(context)}'),
            const SizedBox(height: 20),
            const Text('Adding'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddButton('1'),
                returnAddButton('2'),
                returnAddButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddButton('4'),
                returnAddButton('5'),
                returnAddButton('6'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Removing'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddButton('1', isAdd: false),
                returnAddButton('2', isAdd: false),
                returnAddButton('3', isAdd: false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddButton('4', isAdd: false),
                returnAddButton('5', isAdd: false),
                returnAddButton('6', isAdd: false),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      context.changeLocale(const Locale('uz', 'UZ')),
                  child: const Text('UZBEK'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      context.changeLocale(const Locale('en', 'US')),
                  child: const Text('ENGLISH'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
