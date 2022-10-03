import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dg_tool/dg_tool.dart';
import 'package:flutter/services.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// do you need to be logged in to run anything? no backup can work
// strange to back up and try to fix everything...

// we have to create a provider so we can get a ref and wait on it.
// we wait in

void main() async {
  initializeTools(await initialTools());
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  late final router = UrlRouter(
    // Return a single MainView regardless of path
    onGeneratePages: (router) => [
      const CupertinoPage(child: MainView()),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routeInformationParser: UrlRouteParser(),
      routerDelegate: router,
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return DgTool(child: red("Document here"));
  }
}

final red = (String s) =>
    Text(s, style: const TextStyle(color: CupertinoColors.systemRed));

Future<ToolSet> initialTools() async {
  return ToolSet(
    tool: [
      Tool(
        id: "search",
        icon: const Icon(CupertinoIcons.search),
        buildModal: (_) {
          return BottomModal(child: red("This is a search pane"));
        },
        builder: (_) {
          return red("This is a search pane");
        },
      )
    ],
    active: 0,
    bottomCount: 1,
  );
}

/*
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
*/