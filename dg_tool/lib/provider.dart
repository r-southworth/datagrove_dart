import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class ToolPackage {
  String uri;
  String version;
  ToolPackage(this.uri, this.version);
  // we can get locale from the platform tools?
  List<Tool> getTools();
}

// needs hover and badges, and activation state, maybe care if wide or not.
class MenuButton extends StatelessWidget {
  Widget child;
  int badge;
  bool selected;
  MenuButton({required this.child, this.badge = 0, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      child: child,
      onPressed: () {},
    );
  }
  // this should generally be returned by package tools
}

// builder instead of child? that would be a way to get the context to the tool.
class Tool {
  String id;
  // for building the toolpane
  Widget Function(BuildContext, bool selected) builder;

  Function(BuildContext context)? pane;
  Tool({
    required this.id,
    required this.builder,
  });
}

class ToolSet {
  int active = -1; // i
  List<Tool> leading = [
    Tool(
        id: 'search',
        builder: (c, b) => MenuButton(child: Icon(CupertinoIcons.search)))
  ];
  // doctools are dynamic depending on the top of the document.
  int leadingStatic = 0;
  // trailing tools are menus; they don't change the
  List<Tool> trailing = [];
  int trailingStatic = 0;
  final package = <String, ToolPackage>{};
}

class ToolSetNotifier extends StateNotifier<ToolSet> {
  ToolSetNotifier() : super(ToolSet());

  open() async {}

  // intrinsinc dart packages are added on startup and can't be uninstalled (they can be hidden)
  // extrinsic javascript packages are installed
  add(ToolPackage package) async {}
  install() {}
  uninstall() {}
}

final toolProvider =
    StateNotifierProvider<ToolSetNotifier, ToolSet>((ref) => ToolSetNotifier());
