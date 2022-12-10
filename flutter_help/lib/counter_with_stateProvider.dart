import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// help for //todo
Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

final indexProvider = StateProvider<int>((ref) => 0);

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(indexProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('appbarTitle'),
        ),
        body: Center(
          child: Text('You tapped the FAB $index times'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              ref.read(indexProvider.notifier).update((state) => state++),
          tooltip: 'Increment Counter',
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
