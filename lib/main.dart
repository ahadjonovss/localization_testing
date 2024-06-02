import 'package:flutter/material.dart';
import 'package:localization_testing/localization/data/models.dart';
import 'package:localization_testing/localization/extensions/extensions.dart';
import 'package:localization_testing/localization/last.dart';
import 'package:localization_testing/localization/manager/manager.dart';

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
      initialLocale: const Locale('uz', 'UZ'),
      initialTranslations: ['1'],
      debugMode: true);

  runApp(LocalizationProvider(
    localizationManager: locManager,
      child: MyApp()));
}

class MyApp extends StatelessWidget {

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Dynamic Localization Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Widget returnAddOrRemoveButton(String name, {bool isAdd = true}) {
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
        title: Text('app_title'.tr()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState((){});
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Title: ${'title'.tr()}'),
            Text('1:${'one.a.b.c'.trParams({'name': 'Samandar'})}'),
            Text('2:${'two'.tr()}'),
            const Text('one.a.b.c')
                .trParams(params: {'name': 'Samandar'}),
            Text('4:${'four'.tr()}'),
            Text('5:${'five'.tr()}'),
            Text('6:${'six'.tr()}'),
            const SizedBox(height: 20),
            const Text('Adding'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddOrRemoveButton('1'),
                returnAddOrRemoveButton('2'),
                returnAddOrRemoveButton('3'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddOrRemoveButton('4'),
                returnAddOrRemoveButton('5'),
                returnAddOrRemoveButton('6'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Removing'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddOrRemoveButton('1', isAdd: false),
                returnAddOrRemoveButton('2', isAdd: false),
                returnAddOrRemoveButton('3', isAdd: false),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                returnAddOrRemoveButton('4', isAdd: false),
                returnAddOrRemoveButton('5', isAdd: false),
                returnAddOrRemoveButton('6', isAdd: false),
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
