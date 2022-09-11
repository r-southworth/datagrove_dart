import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'shared/reorderable_grid.dart';
import 'shared.dart';

// this has a stack of lists as we go back and forward though links
class Dgtab {
  List<Dglist> stack = [];
}

// like a web page; this is a location
abstract class Dglist {
  String url = "";
}

class TabBrowser extends StatelessWidget {
  List<Dgtab> tab = [];
  TabBrowser({super.key});

  @override
  Widget build(BuildContext context) {
    return MyApp();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /// create a new list of data
  final items = List<int>.generate(40, (index) => index);

  /// when the reorder completes remove the list entry from its old position
  /// and insert it at its new index
  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      final item = items.removeAt(oldIndex);
      items.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gr = SliverReorderableGrid(
      gridDelegate:
          SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 200),
      onReorder: _onReorder,
      itemBuilder: (BuildContext context, int index) {
        return ReorderableGridDragStartListener(
            key: ValueKey(items[index]),
            index: index,
            child: Container(
              child: GestureDetector(
                  onTap: () {
                    context.url = "/1";
                  },
                  child: Container(child: FlutterLogo(size: 100))),
            ));
      },
      itemCount: items.length,
    );

    return CupertinoApp(
        debugShowCheckedModeBanner: false,
        home: CustomScrollView(slivers: [
          CupertinoSliverNavigationBar(largeTitle: Text("Tabs")),
          gr
        ]));
  }
}

class TabMenu extends StatelessWidget {
  Widget child;
  TabMenu({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(actions: <Widget>[
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDefaultAction: true,
        trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
        child: const Text('Copy'),
      ),
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.pop(context);
        },
        trailingIcon: CupertinoIcons.share,
        child: const Text('Share  '),
      ),
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.pop(context);
        },
        trailingIcon: CupertinoIcons.heart,
        child: const Text('Favorite'),
      ),
      CupertinoContextMenuAction(
        onPressed: () {
          Navigator.pop(context);
        },
        isDestructiveAction: true,
        trailingIcon: CupertinoIcons.delete,
        child: const Text('Delete'),
      ),
    ], child: child);
  }
}
