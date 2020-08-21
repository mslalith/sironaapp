import 'package:flutter/material.dart';
import 'package:medical_shop/providers/contentWidget.dart';
import 'package:rate_my_app/rate_my_app.dart';

class _RateMyAppTestApp extends StatefulWidget {
  /// Creates a new Rate my app test app instance.
  const _RateMyAppTestApp();

  @override
  State<StatefulWidget> createState() => _RateMyAppTestAppState();
}

/// The body state of the main Rate my app test widget.
class _RateMyAppTestAppState extends State<_RateMyAppTestApp> {
  /// The widget builder.
  WidgetBuilder builder = buildProgressIndicator;
  
  @override
  Widget build(BuildContext context) => RateMyAppBuilder(
    builder: (context) => MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Rate my app !'),
        ),
        body: builder(context),
      ),
    ),
    onInitialized: (context, rateMyApp) {
      setState(() => builder = (context) => ContentWidget(rateMyApp: rateMyApp));
      rateMyApp.conditions.forEach((condition) {
        if (condition is DebuggableCondition) {
          print(condition.valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
        }
      });

      print('Are all conditions met ? ' + (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));
    },
  );
  
  /// Builds the progress indicator, allowing to wait for Rate my app to initialize.
  static Widget buildProgressIndicator(BuildContext context) => const Center(
    child: CircularProgressIndicator()
  );
}