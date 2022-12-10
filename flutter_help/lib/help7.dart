import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// help for https://stackoverflow.com/questions/74587041/changenotifierprovider-for-theming-riverpod
///
/// ChangeNotifierProvider For Theming Riverpod
void main() => runApp(const ProviderScope(child: MyApp()));

class ThemesProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  bool get isDarkMode => themeMode == ThemeMode.dark;
  void changeTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

final themesProvider = ChangeNotifierProvider((_) => ThemesProvider());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themesProvider).themeMode;

    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeModeState,
      debugShowCheckedModeBanner: false,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends ConsumerWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeState = ref.watch(themesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Try Me, current: ${themeModeState.themeMode}"),
        leading: Switch(
          value: themeModeState.isDarkMode,
          onChanged: (value) {
            themeModeState.changeTheme(value);
          },
        ),
      ),
    );
  }
}
