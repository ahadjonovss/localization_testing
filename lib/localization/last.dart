import 'package:flutter/material.dart';
import 'package:localization_testing/localization/manager/manager.dart';

class LocProvider extends StatefulWidget {
  final Widget child;
  final LocalizationManager locManger;
  const LocProvider({required this.child, required this.locManger, super.key});

  @override
  State<LocProvider> createState() => _LocProviderState();
}

class _LocProviderState extends State<LocProvider> {
  @override
  void initState() {
   LocalizationManager.instance.addListener(_updateText);
    super.initState();
  }

  void _updateText() {
    // Update the text and rebuild the widget using setState
    setState(() {
     print("Updated");
    });
  }
  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
        localizationManager: widget.locManger, child: widget.child);
  }
}

class LocalizationProvider extends InheritedWidget {
  final LocalizationManager localizationManager;

  const LocalizationProvider(
      {super.key, required super.child, required this.localizationManager});

  @override
  bool updateShouldNotify(LocalizationProvider oldWidget) {
    return localizationManager != oldWidget.localizationManager;
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
