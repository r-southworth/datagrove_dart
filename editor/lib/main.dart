import 'package:flutter/material.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'edit.datagrove.com',
      style: DgfStyle(
        brandName: 'Editor',
      ));

  runApp(DgApp(fl: fl, router: makeRouter(fl)));
}

class Tab extends StatelessWidget {
  Widget title;
  Tab({required this.title});
  @override
  Widget build(Object context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(largeTitle: title),
    ]);
  }
}

makeRouter(Dgf dgf) {
  return UrlRouter(
    onGeneratePages: (router) {
      return [
        CupertinoPage(
            child: TabScaffold(children: [
          NavTab(
              icon: Icon(CupertinoIcons.folder),
              label: 'Browse',
              child: Tab(title: Text("Browse"))),
        ]))
        //MaterialPage(child: Text(router.url)),
      ];
    },
  );
}
