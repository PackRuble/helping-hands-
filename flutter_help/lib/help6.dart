import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Is there a way to call a method of another class in Flutter?
/// help for https://stackoverflow.com/questions/74230618/is-there-a-way-to-call-a-method-of-another-class-in-flutter
///
/// Full example:
main() => runApp(const ProviderScope(child: MaterialApp(home: Parent())));

class Parent extends ConsumerWidget {
  const Parent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Child();
  }
}

class Child extends ConsumerWidget {
  const Child({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Grandchild();
  }
}

class Grandchild extends ConsumerWidget {
  const Grandchild({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: Colors.black,
      mini: true,
      tooltip: 'Change Camera',
      onPressed: () => ref.read(parentProvider).onPressed(),
      child: const Icon(Icons.cached, color: Colors.white),
    );
  }
}

final parentProvider = Provider<ParentNotifier>((ref) {
  return ParentNotifier();
});

class ParentNotifier {
  ParentNotifier();

  onPressed() {
    print("onPressed");
  }
}
