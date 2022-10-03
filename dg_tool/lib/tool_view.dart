import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tool_provider.dart';
export 'tool_provider.dart';
import 'package:split_view/split_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//import 'package:multi_split_view/multi_split_view.dart';
// user configurable rail with data model
// rail has 3 sections: start, dynamic, end
// dynamic will be tools that show for some context.

// maybe use a tool provider instead of a controller? suitable for a global thing. can we give this package a stream of updates? a stream adapter to
// synchronize among devices.
// maybe needs a datagrove provider? how could we avoid needing a datagrove provider? how do you use a provider without a context anyway?

// child here is always a view set.
// view set is not quite a provider unless we say that a flutter engine is always a window?

// a bottom sheet on mobile, a side pane on desktop.
class ToolPane extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pr = ref.watch(toolProvider);
    return pr.active == -1 ? Container() : pr.tool[pr.active].builder!(context);
  }
}

class DgTool extends ConsumerStatefulWidget {
  final Widget child;
  const DgTool({required this.child, super.key});

  @override
  ConsumerState<DgTool> createState() => _DgToolState();
}

// in mobile mode, all buttons become menu buttons
class _DgToolState extends ConsumerState<DgTool> {
  final ctl = SplitViewController();

  @override
  void initState() {
    super.initState();
    ctl.weights = [0.3, 0.7];
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 400;
    final pr = ref.watch(toolProvider);
    print("build ${pr.active}");
    return wide
        ? Container(
            color: CupertinoColors.black,
            child: Row(children: [
              Rail(axis: Axis.vertical),
              Expanded(
                  child: //SplitView(children: [ToolPane(), ViewGrid()])
                      pr.active == -1
                          ? widget.child
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
                              children: [ToolPane(), widget.child]))
            ]))
        : Container(
            color: CupertinoColors.black,
            child: Column(children: [
              Expanded(child: widget.child),
              Rail(axis: Axis.horizontal)
            ]));
  }
}

// needs hover and badges, and activation state, maybe care if wide or not.

// we need the provider in order to set ourselves active if we are not already.
// each button has its own custom context menu where
class RailButton extends ConsumerWidget {
  final int toolIndex;
  final bool modal;

  const RailButton(this.toolIndex, this.modal, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // cupertinobutton not right here, we need hover, badges, right click menus
    // for efficiency we should only watch the specific tool, but how much does that help?
    // widgets are cheap,
    final pr = ref.watch(toolProvider);
    ToolState tool = pr.toolState(toolIndex);
    return CupertinoButton(
      child: tool.tool.icon, // Just an icon? how are
      onPressed: () {
        if (modal) {
          showCupertinoModalBottomSheet(
              expand: true,
              //backgroundColor: CupertinoColors.transparent,
              useRootNavigator: true,
              isDismissible: true,
              builder: (BuildContext context) =>
                  pr.tool[pr.active].buildModal!(context),
              context: context);
        } else {
          // NOTE: you must read .notifier here to get the actions
          ref.read(toolProvider.notifier).toggleActive(toolIndex);
        }
      },
    );
  }
  // this should generally be returned by package tools
}

class BottomModal extends StatelessWidget {
  final Widget child;
  const BottomModal({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Container(),
            middle: Text("Search"),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Icon(CupertinoIcons.xmark),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
        child: child);
  }
}

class Rail extends ConsumerWidget {
  final Axis axis;
  const Rail({required this.axis, super.key});

  @override
  Widget build(context, ref) {
    final tools = ref.watch(toolProvider);

    final vertical = axis == Axis.vertical;
    final theme = CupertinoTheme.of(context);
    final tl = List<Widget>.generate(tools.tool.length, (e) {
      bool modal = !vertical || e >= tools.tool.length - tools.bottomCount;
      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: RailButton(e, modal) //builder(context, tools.active == e)),
          );
    });
    return axis == Axis.horizontal
        ? Container(
            color: theme.barBackgroundColor,
            child: Row(children: [for (final o in tl) Expanded(child: o)]))
        : Container(
            color: theme.barBackgroundColor,
            child: Column(children: [
              ...tl,
              Expanded(
                child: Container(),
              ),
              //...trailing
            ]));
  }
}

/*
                  value: activeTool,
                  onChanged: (int x) {
                    setState(() {
                      activeTool = x;
                    });
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

  }
}*/
