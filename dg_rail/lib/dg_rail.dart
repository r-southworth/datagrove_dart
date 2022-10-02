library dg_rail;

import 'package:flutter/cupertino.dart';

// this is a widget to adaptively place tool buttons on left or bottom
class DgRail extends StatelessWidget {
  Widget child;
  List<Widget> leading=[], middle=[], trailing=[];


  DgRail({super.key, required this.child, 
    List<Widget>? leading,
        List<Widget>? middle,
            List<Widget>? trailing,
  }){
    this.leading = leading ??[];
    this.middle = middle ?? [];
    this.trailing= trailing??[];
  }
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
                for (final o in leading)
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

// user configurable rail with data model
// rail has 3 sections: start, dynamic, end
// dynamic will be tools that show for some context.

class RailConfig {
  List<Tool> start = [];
  List<Tool> end = [];
  List<Tool> dynamic = [];
}
class Tool {

}

typedef RailController = ValueNotifier<RailConfig>;

class DgUserRail extends StatelessWidget {
  Widget child;
  RailController controller;
  DgUserRail({required this.controller, required this.child});

  @override
  Widget build(BuildContext context) {
    return DgRail(
      tool: [],
      child: child
    )
  }
}
