import 'package:flutter/cupertino.dart';

import '../shared.dart';

//                         CupertinoTextFormFieldRow(
// autofocus: true,
// prefix: Text("User"),
// placeholder: "user"),

// override each tab, but allow a default?
// the primary thing we need is a database widget that supports add/edit/delete

// it's not clear if this should just be a tree, or if we should try to reign it a little  to avoid getting too deep. But we need something that registers all the things an app can set. a registry editor, yaml editor, etc. Maybe guided by tree style schemas instead of relational since the data is sparse and deep.

class FlexScaffold extends StatelessWidget {
  Widget child;
  List<Widget> tool;

  FlexScaffold({super.key, required this.child, required this.tool});
  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 400;

    final theme = CupertinoTheme.of(context);
    if (wide) {
      return Container(
        color: CupertinoColors.black,
        child: Row(children: [
          Container(
              color: theme.barBackgroundColor,
              child: Column(children: [
                SizedBox(
                  height: 0,
                ),
                for (final o in tool)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: o,
                  ),
                Expanded(child: Container())
              ])),
          Expanded(child: child)
        ]),
      );
    } else {
      // mobile
      return Container(
        color: CupertinoColors.black,
        child: Column(children: [
          Expanded(child: child),
          Container(
              color: theme.barBackgroundColor,
              child: Row(children: [for (final o in tool) Expanded(child: o)]))
        ]),
      );
    }
  }
}
