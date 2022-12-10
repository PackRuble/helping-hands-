import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// How to get previous value of a provider in Riverpod?
/// help for https://stackoverflow.com/questions/74106372/how-to-get-previous-value-of-a-provider-in-riverpod
///
/// Full example:
main() => runApp(const ProviderScope(child: MaterialApp(home: FooPage())));

class FooPage extends ConsumerWidget {
  const FooPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncResult = ref.watch(resultProvider);
    return Scaffold(
      body: Column(
        children: [
          TextField(
              onChanged: (s) => ref.read(queryProvider.notifier).state = s),
          asyncResult.when(
            data: Text.new,
            error: (e, s) => Text('Error = $e'),
            loading: () => Text('Loading...'),
          ),
        ],
      ),
    );
  }
}

final stringProvider =
    FutureProvider.family<String, String>((ref, query) async {
  return query.toUpperCase();
});

final queryProvider = StateProvider<String>((ref) => '');

final resultProvider = FutureProvider<String>((ref) async {
  final query = ref.watch(queryProvider);

  await Future.delayed(const Duration(seconds: 1));
  return ref.watch(stringProvider(query).future);
});

// or

// /// Instead `stringProvider`.
// Future<String> stringConvert(String query) async {
//   await Future.delayed(const Duration(seconds: 1));
//
//   return query.toUpperCase();
// }
//
// final queryProvider = StateProvider<String>((ref) {
//   return '';
// });
//
// final resultProvider = FutureProvider<String>((ref) async {
//   final query = ref.watch(queryProvider);
//   return stringConvert(query);
// });
