import 'package:dg_tool/dg_tool.dart';
import 'package:flutter/cupertino.dart';

Future<ToolSet> initialTools() async {
  return ToolSet(
    tool: [
      Tool(
        id: "search",
        icon: const Icon(CupertinoIcons.search),
        buildModal: (c) {
          return BottomModal(child: SearchPane.modal(c));
        },
        builder: (c) {
          return SearchPane();
        },
      ),
      Tool(
        id: "browse",
        icon: const Icon(CupertinoIcons.folder),
        buildModal: (c) {
          return BottomModal(child: BrowsePane());
        },
        builder: (c) {
          return BrowsePane();
        },
      )
    ],
    active: 0,
    bottomCount: 1,
  );
}

class SearchPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("search tool");
  }

  static Widget modal(BuildContext c) {
    return SearchPane();
  }
}

class BrowsePane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text("browse tool");
  }
}
