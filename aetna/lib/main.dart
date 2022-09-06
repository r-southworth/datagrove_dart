import 'package:flutter/material.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

import 'cursor.dart';

void main() async {
  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'edit.datagrove.com',
      style: DgfStyle(
        brandName: 'Aetna Claim Support',
      ));

  runApp(DgApp(fl: fl, router: makeRouter(fl)));
}

// the first two tabs
class Tab extends StatefulWidget {
  Widget title;
  List<Widget> trailing;
  int index;
  Tab({required this.index, required this.title, required this.trailing});

  @override
  State<Tab> createState() => _TabState();
}

class _TabState extends State<Tab> {
  List<Widget> cache = [];
  final recentCursor =
      CursorNotifier<String>(List<String>.generate(100, (e) => "$e"));
  final folderCursor =
      CursorNotifier<String>(List<String>.generate(100, (e) => "${e + 200}"));

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(Object context) {
    switch (widget.index) {
      case 0:
        return CustomScrollView(slivers: [
          CupertinoSliverNavigationBar(
              largeTitle: widget.title,
              trailing: Row(
                  mainAxisSize: MainAxisSize.min, children: widget.trailing)),
          SliverToBoxAdapter(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CupertinoSearchTextField(),
          )),
          Cursor<String>(
              value: recentCursor,
              builder: (BuildContext context, int index, String value) {
                return CupertinoListTile(title: Text(value));
              })
        ]);
    }
    return Scaffold(
        appBar: CupertinoNavigationBar(
            leading: Container(),
            middle: widget.title,
            trailing:
                Row(mainAxisSize: MainAxisSize.min, children: widget.trailing)),
        body: Container());
  }
}
// we need the tabset to be the bottom of of all the stacks.

// the router needs to have a login
// the router needs channels etc.

// should I try to create an animatedlist that can accept general orders?
// can I stack listTiles and manage them this way?

makeRouter(Dgf dgf) {
  int clamp(String s, int low, int high) {
    var n = int.tryParse(s) ?? low;
    return n < low || n >= high ? low : n;
  }

  return UrlRouter(onGeneratePages: (router) {
    if (!dgf.isLogin) {
      return [CupertinoPage(child: LoginScreen(dgf))];
    }

    // if (router.url.startsWith("/login")) {

    // }

    // we need to pull out the tab - query parameters or path?
    var p = router.url.split("/");
    var tab = p.length > 1 ? clamp(p[1], 0, 4) : 0;

    // we can add pages here
    var menu1 = [
      CupertinoButton(
        onPressed: () {},
        child: const Icon(CupertinoIcons.add),
      ),
      CupertinoButton(
        onPressed: () {},
        child: const Icon(CupertinoIcons.ellipsis),
      )
    ];

    List<CupertinoPage> r = [
      CupertinoPage(
          child: TabScaffold(initialTab: tab, children: [
        NavTab(
            icon: const Icon(CupertinoIcons.clock),
            label: 'Recent',
            child: Tab(index: 0, title: const Text("Recent"), trailing: menu1)),
        NavTab(
            icon: const Icon(CupertinoIcons.folder),
            label: 'Browse',
            child: Tab(index: 1, title: const Text("Browse"), trailing: menu1)),
        NavTab(
            icon: const Icon(CupertinoIcons.graph_circle),
            label: 'Stats',
            child: Tab(index: 2, title: const Text("Stats"), trailing: menu1)),
        NavTab(
            icon: const Icon(CupertinoIcons.gear),
            label: 'Settings',
            child:
                Tab(index: 3, title: const Text("Settings"), trailing: menu1))
      ]))
    ];
    switch (tab) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
    }

    return r;
  });
}
