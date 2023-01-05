import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'main.freezed.dart';

/// help for https://stackoverflow.com/questions/75014551/riverpod-trigger-rebuild-when-update-state-with-freezed-copywith-even-if-nothing
///
/// Riverpod trigger rebuild when update state with freezed copywith even if nothing changed
///
/// Solution:
/// It's all about using identical(old, current) under the hood to compare states.
void main() => runApp(const ProviderScope(child: MyApp()));

@Freezed(genericArgumentFactories: true)
class Model with _$Model {
  const factory Model({required int id}) = _Model;
}

class Manager {
  static StateProvider<Model> modelProvider = StateProvider<Model>((ref) {
    Stream.periodic(const Duration(seconds: 1)).take(1000).listen((event) {
      ref.read(modelProvider.notifier).update((state) {
        final cloneState = state.copyWith();
        // const cloneState = Model(id: 1); //The print true in both cases
        print("${state == cloneState}"); //This print true
        print("identical: ${identical(state, cloneState)}"); //This print false
        return cloneState;
      });
    });

    return const Model(id: 1);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var model = ref.watch(Manager.modelProvider);
    print("model change......................"); //print every second
    return MaterialApp(home: Text(model.id.toString()));
  }
}
