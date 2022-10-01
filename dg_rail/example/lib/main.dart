import 'package:flutter/cupertino.dart';
import 'package:dg_rail/dg_rail.dart';
import 'package:url_router/url_router.dart';

void main() {
  runApp(MyApp());
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
    return DgRail(
        tool: <Widget>[
          CupertinoButton(
            child: const Text("1"),
            onPressed: () {
              // each tool should set the route, probably keep its own stack of routes?
            },
          ),
          CupertinoButton(
            child: const Text("2"),
            onPressed: () {},
          )
        ],
        child: CustomScrollView(slivers: [
          const CupertinoSliverNavigationBar(largeTitle: Text("dg_rail")),
          SliverList(
              delegate: SliverChildListDelegate([
            for (var i = 0; i < 100; i++) CupertinoListTile(title: Text("$i"))
          ]))
        ]));
  }
}
