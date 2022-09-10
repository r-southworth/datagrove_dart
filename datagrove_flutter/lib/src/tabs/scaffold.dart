import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import '../client/datagrove_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:bip39/bip39.dart' as bip39;

import '../client/identity.dart';
import 'notify.dart';
import 'contact.dart';
import 'nav.dart';
import 'starred.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

//                         CupertinoTextFormFieldRow(
// autofocus: true,
// prefix: Text("User"),
// placeholder: "user"),

class DgApp extends StatelessWidget {
  Dgf fl;
  UrlRouter router;
  DgApp({required this.fl, required this.router});

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    return ChangeNotifierProvider<Dgf>(
        create: (_) => fl,
        child: Theme(
            data: ThemeData(
                brightness: platformBrightness,
                scaffoldBackgroundColor: CupertinoColors.black),
            child: CupertinoApp.router(
              theme: const CupertinoThemeData(brightness: Brightness.dark),
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'),
                Locale('es', ''),
                Locale('fr', 'CA'),
              ],
              routerDelegate: router,
              //     RoutemasterDelegate(routesBuilder: (context) => routes),
              routeInformationParser: UrlRouteParser(),

              title: fl.style.brandName,
              debugShowCheckedModeBanner: false,
            )));
  }
}

// this needs a router, and global keys for its delegates
class TabScaffold extends StatefulWidget {
  List<NavTab> children;
  final int initialTab;

  TabScaffold({
    this.initialTab = 0,
    required this.children,
    Key? key,
  }) : super(key: key) {}

  @override
  State<TabScaffold> createState() => TabScaffoldState();
}

// override each tab, but allow a default?
// the primary thing we need is a database widget that supports add/edit/delete

// it's not clear if this should just be a tree, or if we should try to reign it a little  to avoid getting too deep. But we need something that registers all the things an app can set. a registry editor, yaml editor, etc. Maybe guided by tree style schemas instead of relational since the data is sparse and deep.

class TabScaffoldState extends State<TabScaffold> {
  int _selectedIndex = 0;

  @override
  didUpdateWidget(TabScaffold old) {
    super.didUpdateWidget(old);
    _selectedIndex = widget.initialTab;
  }

  @override
  initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    final dg = Dgf.of(context);
    // this needs to change to a different list

    return Material(
        child: Scaffold(
            bottomNavigationBar: wide
                ? null
                : BottomNavigationBar(
                    backgroundColor: CupertinoColors.darkBackgroundGray,
                    unselectedItemColor: CupertinoColors.inactiveGray,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        context.url = "/$index";
                      });
                    },
                    items: [
                        for (var o in widget.children)
                          BottomNavigationBarItem(icon: o.icon, label: o.label)
                      ]),
            // we need to keep the navigation rail alive, and fade it out.
            body: Row(children: <Widget>[
              if (wide)
                NavigationRail(
                  backgroundColor: CupertinoColors.darkBackgroundGray,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      context.url = "/$index";
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    for (var o in widget.children)
                      NavigationRailDestination(
                        icon: o.icon,
                        selectedIcon: o.icon,
                        //selectedIcon: o.activeIcon,
                        label: Text(o.label),
                      )
                  ],
                ),
              if (wide) const VerticalDivider(thickness: 1, width: 1),

              // This is the main content.
              Expanded(
                  child: IndexedStack(
                      index: _selectedIndex,
                      children: [for (var o in widget.children) o]))
            ])));
  }
}

// database > views > pickers
// maintain position
//

abstract class PageStacker {
  push(Widget w);
  pop();
}
