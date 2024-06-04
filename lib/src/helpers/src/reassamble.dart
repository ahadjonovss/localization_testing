import 'package:localization_testing/localization_provider.dart';

class ReassembleListener extends StatefulWidget {
  const ReassembleListener({super.key, required this.child});

  final Widget child;

  @override
  _ReassembleListenerState createState() => _ReassembleListenerState();
}

class _ReassembleListenerState extends State<ReassembleListener> {
  @override
  void reassemble() {
    context.reloadTranslations();
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
