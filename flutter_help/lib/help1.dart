import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// help for https://stackoverflow.com/questions/74024610/are-unchanged-listview-items-reused-when-the-listview-gets-rebuild
Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listLength = ref.watch(dataLengthProvider);

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
              child: const Icon(Icons.add),
              onPressed: () => ref.read(dataListProvider.notifier).add(),
            ),
            ElevatedButton(
              child: const Icon(Icons.delete),
              onPressed: () => ref.read(dataListProvider.notifier).delete(),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: listLength,
                itemBuilder: (context, index) {
                  return MyListItem(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyListItem extends ConsumerStatefulWidget {
  final int index;
  const MyListItem(
    this.index, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _MyListItemState();
}

class _MyListItemState extends ConsumerState<MyListItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.index);
    final countValue = ref.watch(
        dataItemProvider(widget.index).select((dataItem) => dataItem.value));
    return Text('Value: ${countValue.toString()}');
  }

  @override
  void dispose() {
    print('dispose: ${widget.index}');
    super.dispose();
  }
}

// Providers -------------------------------------------------------------------

final dataListProvider = StateNotifierProvider<DataListNotifier, List<Data>>(
    (ref) => DataListNotifier());

final dataLengthProvider =
    Provider<int>((ref) => ref.watch(dataListProvider).length);

final dataItemProvider = Provider.family<Data, int>(
    (ref, index) => ref.watch(dataListProvider)[index]);

// Notifier --------------------------------------------------------------------

class DataListNotifier extends StateNotifier<List<Data>> {
  DataListNotifier() : super([const Data(), const Data()]);

  void add() {
    state = [...state, const Data(value: 0)];
  }

  void delete() {
    state.removeLast();
    state = List.of(state);
  }
}

// Data model ------------------------------------------------------------------

@immutable
class Data {
  final int value;

  const Data({this.value = 0});

  Data copyWith({int? newValue}) => Data(value: newValue ?? value);
}
