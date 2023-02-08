import 'package:flutter/material.dart';

/// https://stackoverflow.com/questions/75350773/flutter-why-widget-is-rebuilding-more-than-10-times-when-i-use-streamprovider-e
///
/// Flutter: Why widget is rebuilding more than 10 times when I use StreamProvider even when value not changes?
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    print('#build $MyApp');

    // return Theme(
    //   data: ThemeData(
    //     textButtonTheme: TextButtonThemeData(
    //       style: TextButton.styleFrom(elevation: 1),
    //     ),
    //   ),
    //   child: Builder(
    //     builder: (context) {
    //       print("#build Builder");
    //
    //       Theme.of(context);
    //
    //       return const SizedBox();
    //     },
    //   ),
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(elevation: 1),
        ),
      ),
      home: Builder(
        builder: (context) {
          print("#build Builder");

          Theme.of(context);

          return const SizedBox();
        },
      ),
    );
  }
}
