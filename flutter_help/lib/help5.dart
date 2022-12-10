import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// help for https://stackoverflow.com/questions/74176115/riverpod-is-it-wrong-to-refer-in-onpressed-to-a-provider-obtained-earlier-by-re
///
/// Riverpod: Is it wrong to refer in onPressed to a provider obtained earlier by ref.watch?
void main() => runApp(const ProviderScope(child: MyApp()));

final indexProvider = StateProvider<int>((ref) {
  ref.listenSelf((previous, next) {
    print(ref.controller.state);
  });
  return 0;
});

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build $MyApp');

    return MaterialApp(
      home: Center(
        child: Column(
          children: const [
            SizedBox(height: 50.0),
            ButtonInternalState(),
            SizedBox(height: 50.0),
            ButtonProviderState(),
          ],
        ),
      ),
    );
  }
}

class ButtonInternalState extends ConsumerWidget {
  const ButtonInternalState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build $ButtonInternalState');

    // Once upon a time, all we had to do was read the data once and not keep track of anything
    final StateController<int> indexState = ref.read(indexProvider.state);

    return ElevatedButton(
      onPressed: () => indexState.state++,

      // It would have avoided the mistake
      // onPressed: () => ref.read(indexProvider.state).state++,

      child: Text('The state our wrong provider - ${indexState.state}'),
    );
  }
}

class ButtonProviderState extends ConsumerWidget {
  const ButtonProviderState({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print('build $ButtonProviderState');

    final int index = ref.watch(indexProvider);

    return Column(
      children: [
        ElevatedButton(
            onPressed: () => ref.read(indexProvider.notifier).state++,
            child: Text('Here changes state the provider - $index')),
        ElevatedButton(
            onPressed: () => ref.refresh(indexProvider),
            child: const Text('Refresh our provider')),
      ],
    );
  }
}
