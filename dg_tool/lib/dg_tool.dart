library dg_tool;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'provider.dart';
export 'provider.dart';
import 'view_grid.dart';
import 'package:split_view/split_view.dart';
//import 'package:multi_split_view/multi_split_view.dart';
// user configurable rail with data model
// rail has 3 sections: start, dynamic, end
// dynamic will be tools that show for some context.

// maybe use a tool provider instead of a controller? suitable for a global thing. can we give this package a stream of updates? a stream adapter to
// synchronize among devices.
// maybe needs a datagrove provider? how could we avoid needing a datagrove provider? how do you use a provider without a context anyway?

// child here is always a view set.
// view set is not quite a provider unless we say that a flutter engine is always a window?

class DgTool extends StatefulWidget {
  const DgTool({super.key});

  @override
  State<DgTool> createState() => _DgToolState();
}

// in mobile mode, all buttons become menu buttons
class _DgToolState extends State<DgTool> {
  int activeTool = -1;
  final ctl = SplitViewController();
  @override
  void initState() {
    super.initState();
    ctl.weights = [0.3, 0.7];
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 400;
    return wide
        ? Container(
            color: CupertinoColors.black,
            child: Row(children: [
              RailColumn(
                  value: activeTool,
                  onChanged: (int x) {
                    setState(() {
                      activeTool = x;
                    });
                  }),
              Expanded(
                  child: //SplitView(children: [ToolPane(), ViewGrid()])
                      activeTool == -1
                          ? ViewGrid()
                          : SplitView(
                              gripColor:
                                  CupertinoTheme.of(context).barBackgroundColor,
                              viewMode: SplitViewMode.Horizontal,
                              controller: ctl,
                              indicator: SplitIndicator(
                                  color: CupertinoTheme.of(context)
                                      .barBackgroundColor,
                                  viewMode: SplitViewMode.Horizontal,
                                  isActive: true),
                              children: [ToolPane(), ViewGrid()]))
            ]))
        : Container(
            color: CupertinoColors.black,
            child: Column(children: [Expanded(child: ViewGrid()), RailRow()]));
  }
}

class ToolPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return red("tool pane");
  }
}

class RailRow extends ConsumerWidget {
  const RailRow({super.key});

  @override
  Widget build(context, ref) {
    final theme = CupertinoTheme.of(context);
    final tools = ref.watch(toolProvider);
    final leading = List<Widget>.generate(
      tools.leading.length,
      (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: tools.leading[e].builder(context, tools.active == e)),
    );
    final trailing = List<Widget>.generate(
      tools.trailing.length,
      (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: tools.trailing[e].builder(context, false)),
    );
    return Container(
        color: theme.barBackgroundColor,
        child: Row(children: [for (final o in leading) Expanded(child: o)]));
  }
}

class RailColumn extends ConsumerWidget {
  final int value;
  final Function(int) onChanged;
  const RailColumn({required this.value, required this.onChanged, super.key});

  @override
  Widget build(context, ref) {
    final theme = CupertinoTheme.of(context);
    final tools = ref.watch(toolProvider);
    final leading = List<Widget>.generate(
      tools.leading.length,
      (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: tools.leading[e].builder(context, tools.active == e)),
    );
    final trailing = List<Widget>.generate(
      tools.trailing.length,
      (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: tools.trailing[e].builder(context, false)),
    );
    return Container(
        color: theme.barBackgroundColor,
        child: Column(children: [
          ...leading,
          Expanded(
            child: Container(),
          ),
          ...trailing
        ]));
  }
}
