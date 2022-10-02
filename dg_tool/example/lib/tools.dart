// localized.
import 'package:dg_tool/dg_tool.dart';
import 'package:flutter/cupertino.dart';

// we can have multiple branches open, these have to be accessible through tools
// what is the url then? does it mean anything?
// can we look through open documents and add to the set if we need too?

// the leading tools are all for changing the url to /tool/{whatever it was recently}
//
class MyToolPackage extends ToolPackage {
  MyToolPackage() : super("_local", "0.0.0");
  @override
  List<Tool> getTools() {
    return [
      Tool(
        id: "search",
        builder: (BuildContext context, bool selected) => CupertinoButton(
            onPressed: () {},
            child: MenuButton(child: Icon(CupertinoIcons.search))),
      )
    ];
  }
}

class TestDoc {
  late List<String> title;
  TestDoc() {
    title = [for (var i = 0; i < 100; i++) "$i"];
  }
}

typedef TestDocController = ValueNotifier<TestDoc>;

//
class TestDocView extends StatefulWidget {
  TestDocController controller;
  TestDocView(this.controller);

  @override
  State<TestDocView> createState() => _TestDocViewState();
}

class _TestDocViewState extends State<TestDocView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      //
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      SliverList(
          delegate: SliverChildListDelegate([
        for (var o in widget.controller.value.title)
          CupertinoListTile(title: Text(o))
      ]))
    ]);
  }
}
