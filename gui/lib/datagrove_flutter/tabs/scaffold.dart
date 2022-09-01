import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:url_router/url_router.dart';
import '../client/datagrove_flutter.dart';
import 'package:path/path.dart' as p;

import '../client/identity.dart';
import 'notify.dart';
import 'contact.dart';
import 'nav.dart';
import 'profile.dart';
import 'starred.dart';

// will call this twice currently; authenticate and then again to  generate
// caching is hacky, but should work ok.
class RouteParse {
  static final cache = <String, RouteParse>{};

  int tab = 0;
  int cid = 0; // community id
  int bid = 0; // branch id
  int pid = 0; // publication id.
  int gid = 0; // message group id, applies only to messages.
  int iid = 0; // interior location
  String iname = ""; // not guaranteed to be unique

  // this needs to verify that the user can access the url and redirect if not.
  RouteParse parse(Dgf dg, String s) {
    var ox = cache[s];
    if (ox != null) {
      return ox;
    }
    var o = s.length >= 2 ? s[1] : "";
    var tab = <String, int>{"g": 0, "n": 1, "s": 2, "m": 3, "p": 4}[o] ?? 0;
    switch (tab) {
      case 0:
        // check authorization.
        // group-hyphen, publication-hypen, toc-hyphen

        var group = "";
        var pub = "";
        var inner = "";

        //dg.authorize(group);
        break;
      case 4:
        // with profiles we can jump to a particular screen.
        // no authorization, this always the current user's profile
        // plus a list of known alter-egos.

        break;
      case 3:
        // we need to check authorization here
        // with messages we can jump to a particular conversation and its information
        // screen
        break;
      default:
      // there is no depth to notify, stars
    }

    return RouteParse();
  }
}

// th
makeRouter(Dgf dgf) {
  return UrlRouter(
    // this can generate a stack of pages, when do we need this?
    // what if "back" meant drawer? nested folders though.
    // its not clear when jumping into a drive site if back is "up" or
    // "previous page in timeline".
    onGeneratePages: (router) {
      print("${router.url} ${router.urlPath}");

      return [
        CupertinoPage(
            child: TabScaffold(
                path: router.url,
                leading: Container(),
                title: const Text("🗺️ Datagrove"),
                label: 'Datagrove',
                trailing: const [],
                children: []))
        //MaterialPage(child: Text(router.url)),
      ];
    },
// Optional, protect or redirect urls
    onChanging: (router, newUrl) {
      const authorized = true;
      if (authorized == false) return '/'; // redirect to main view
      return newUrl; // allow change
    },
    // use this to build our navigators together (one for each tab)
    // note how strange this is for web; we have nested navigators galore
    // does changing a url become a deep link that obliterates the other stacks?
    // probably? making it sticky across tabs is odd too, but maybe you would expect
    // it to default to last stack used rather than empty.
    // builder: (router, navigator) {
    //   return navigator; //Row(children: [const SideBar(), Expanded(child: navigator)],
    // },
  );
}

class DgApp extends StatelessWidget {
  Dgf fl;
  DgApp(this.fl);

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
              routerDelegate: makeRouter(fl),
              //     RoutemasterDelegate(routesBuilder: (context) => routes),
              routeInformationParser: UrlRouteParser(),

              title: "Datagrove",
              debugShowCheckedModeBanner: false,
            )));
  }
}

// this needs a router, and global keys for its delegates
class TabScaffold extends StatefulWidget {
  List<Widget> children;
  Widget? leading;
  Widget title;
  String label; // this is the plural name for your databases, e.g. "Schools"
  List<Widget> trailing;
  String path;
  TabScaffold(
      {Key? key,
      required this.children,
      this.leading,
      required this.title,
      required this.trailing,
      required this.path,
      required this.label})
      : super(key: key) {}

  @override
  State<TabScaffold> createState() => TabScaffoldState();
}

// override each tab, but allow a default?
// the primary thing we need is a database widget that supports add/edit/delete

// it's not clear if this should just be a tree, or if we should try to reign it a little  to avoid getting too deep. But we need something that registers all the things an app can set. a registry editor, yaml editor, etc. Maybe guided by tree style schemas instead of relational since the data is sparse and deep.

class TabScaffoldState extends State<TabScaffold> {
  int _selectedIndex = 0;
  late List<NavTab> tab = [];

  @override
  didUpdateWidget(TabScaffold old) {
    super.didUpdateWidget(old);
    print("update state ${widget.path}");

    var o = widget.path.length >= 2 ? widget.path[1] : "";
    _selectedIndex =
        <String, int>{"g": 0, "n": 1, "s": 2, "m": 3, "p": 4}[o] ?? 0;

    switch (_selectedIndex) {
      case 0:
        // check authorization.
        // group-hyphen, publication-hypen, toc-hyphen
        break;
      case 4:
        // with profiles we can jump to a particular screen.
        // no authorization, this always the current user's profile
        // plus a list of known alter-egos.

        break;
      case 3:
        // we need to check authorization here
        // with messages we can jump to a particular conversation and its information
        // screen
        break;
      default:
      // there is no depth to notify, stars
    }
  }

  initState() {
    super.initState();
    print("init state ${widget.path}");

    tab = [
      NavTab(
          key: UniqueKey(),
          icon: Icon(CupertinoIcons.tree),
          label: 'Grove',
          child: HomeTab(title: widget.title, label: widget.label)),
      NavTab(
          key: UniqueKey(),
          icon: Icon(CupertinoIcons.bell),
          label: 'Notify',
          child: AlertTab()),
      NavTab(
          key: UniqueKey(),
          icon: Icon(CupertinoIcons.star),
          label: 'Starred',
          child: StarredTab()),
      NavTab(
          key: UniqueKey(),
          icon: Icon(Icons.mail),
          label: 'Messages',
          child: MessageTab()),
      NavTab(
        key: UniqueKey(),
        icon: Icon(Icons.settings),
        label: 'Profile',
        child: ProfileTab(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    final dg = Dgf.of(context);
    // this needs to change to a different list
    if (dg.unlinked) {
      return OnboardDesktop();
    }

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
                        // this isn't correct, we need to set whatever url
                        // is current for that navigator.
                        context.url =
                            <String>["/g", "/n", "/s", "/m", "/p"][index];
                      });
                    },
                    items: [
                        for (var o in tab)
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
                      context.url =
                          <String>["/g", "/n", "/s", "/m", "/p"][index];
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    for (var o in tab)
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
                      index: _selectedIndex, children: [for (var o in tab) o]))
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
