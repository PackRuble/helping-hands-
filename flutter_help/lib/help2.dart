import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// help for https://stackoverflow.com/questions/74098175/how-to-add-a-gap-between-expansionpanellist-in-flutter
/// You can use `ExpansionTile` inside the `ListView` instead of `ExpansionPanelList` widget.
///
/// Full example:
main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Item> items = List.generate(
        5, (index) => Item(header: 'header$index', body: 'body$index'));

    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: _buildTiles(items[index]),
      ),
      itemCount: items.length,
    );
  }

  Widget _buildTiles(Item item) {
    return Card(
      child: ExpansionTile(
        key: ValueKey(item),
        title: ListTile(
          title: Text(
            item.header,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        children: [
          ListTile(
            title: Text(item.body, style: const TextStyle(fontSize: 20)),
          )
        ],
      ),
    );
  }
}

class Item {
  final String header;
  final String body;

  Item({
    required this.header,
    required this.body,
  });
}

