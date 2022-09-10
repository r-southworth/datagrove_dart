import 'package:flutter/material.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:badges/badges.dart';

import 'shared/cursor.dart';
import 'issue_new.dart';
import 'issue.dart';
import 'shared/search.dart';
import 'priorities.dart';
import 'settings.dart';
import 'group.dart';
import 'alerts.dart';

void main() async {
  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'edit.datagrove.com',
      style: DgfStyle(
        brandName: 'Datagrove Issues',
      ));

  runApp(DgApp(fl: fl, router: makeRouter(fl)));
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

    // we need to pull out the tab - query parameters or path?
    var p = router.url.split("/");
    var tab = p.length > 1 ? clamp(p[1], 0, 5) : 0;

    // we can add pages here

    // this gives us the base page
    List<CupertinoPage> r = [
      CupertinoPage(
          child: TabScaffold(initialTab: tab, children: [
        NavTab(
            icon: const Icon(CupertinoIcons.doc),
            label: 'Issues',
            child: Issues()),
        NavTab(
            icon: const Icon(CupertinoIcons.bell),
            label: 'Alert',
            child: Alerts()),
        NavTab(
            icon: const Icon(CupertinoIcons.star),
            label: 'Star',
            child: Priorities()),
        NavTab(
            icon: const Icon(CupertinoIcons.person),
            label: 'Groups',
            child: Groups()),
        NavTab(
            icon: const Icon(CupertinoIcons.gear),
            label: 'Settings',
            child: Settings())
      ]))
    ];
    switch (tab) {
      case 0:
        // if there is another part, then we need to add a deeper level
        if (p.length > 2) {
          r.add(CupertinoPage(child: IssuePage()));
        }
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
    }

    return r;
  });
}
