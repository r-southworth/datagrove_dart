library dg_rail;

import 'package:flutter/cupertino.dart';

// this is a widget to adaptively place tool buttons on left or bottom
class DgRail extends StatelessWidget {
  Widget child;
  List<Widget> tool;

  DgRail({super.key, required this.child, required this.tool});
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
