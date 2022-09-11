import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'shared.dart';
import 'lists.dart';
import 'shared/web.dart';
import 'tabs.dart';

import 'shared/install.dart';
import 'shared/flex.dart';
import 'shared/settings.dart';

import 'dart:js' as js;
import 'dart:html';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerWeb();
  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'edit.datagrove.com',
      style: DgfStyle(
        brandName: 'Datagrove Issues',
      ));
  final st = Store(fl);
  runApp(MultiProvider(providers: [
    Provider<Dgf>(create: (_) => fl),
    Provider<Store>(create: (_) => st)
  ], child: DgApp(router: makeRouter(fl))));
}

class Store {
  Dgf dg;
  Store(this.dg);

  static Dgf of(BuildContext context) => Provider.of<Dgf>(context);
}

class DgApp extends StatelessWidget {
  UrlRouter router;
  DgApp({required this.router});
  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    return Theme(
        data: ThemeData(
            brightness: platformBrightness,
            scaffoldBackgroundColor: CupertinoColors.black),
        child: Material(
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

          title: "Datagrove",
          debugShowCheckedModeBanner: false,
        )));
  }
}

makeRouter(Dgf dgf) {
  int clamp(String s, int low, int high) {
    var n = int.tryParse(s) ?? low;
    return n < low || n >= high ? low : n;
  }

  // returns a list of pages, which gets turned into a stack of widgets.
  return UrlRouter(onGeneratePages: (router) {
    // if (!dgf.isLogin) {
    //   return [CupertinoPage(child: LoginScreen(dgf))];
    // }

    // we need to pull out the tab - query parameters or path?
    var p = router.url.split("/");
    var tab = p.length > 1 ? clamp(p[1], 0, 2) : 0;
    var page = p.length > 1 ? router.url.substring(p[1].length + 1) : "";
    // we can add pages here

    // this gives us the base page
    // all these are buttons, and not tabs at all. should I make a new scaffold?
    // this is only one navigator.
    return [CupertinoPage(child: DgPage(tab: tab, page: page))];
  });
}

class DgPage extends StatefulWidget {
  int tab;
  String page; // string?
  DgPage({required this.tab, required this.page});

  @override
  State<DgPage> createState() => _DgPageState();
}

class _DgPageState extends State<DgPage> {
  bool showList = true;
  bool showEditor = true;

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    final mq = MediaQuery.of(context);
    return FlexScaffold(
        tool: [
          CupertinoButton(
            child: Icon(CupertinoIcons.search),
            onPressed: () {
              setState(() {
                showList = !showList;
              });
            },
          ),
          LinkButton(url: context.url, child: Icon(CupertinoIcons.square_list)),
          if (!kIsWeb) TabButton(),
          CupertinoButton(
              child: const Icon(CupertinoIcons.ellipsis_vertical),
              onPressed: () {
                showCupertinoModalBottomSheet(
                    useRootNavigator: true,
                    isDismissible: true,
                    builder: (BuildContext context) {
                      return MainMenu();
                    },
                    context: context);
              })
        ],
        child: Row(children: [
          if (showList)
            SizedBox(
                width: 400,
                child: Column(children: [
                  SearchNav(theme: theme),
                  Expanded(child: WebDiv("<b>hello,world</b>"))
                ])),
          if (showEditor)
            Expanded(
                child: Column(children: [
              EditNav(),
              Expanded(child: WebDiv("<b>hello,world</b>2"))
            ]))
        ]));
  }
}

class EditNav extends StatelessWidget {
  bool hasBack;
  EditNav({super.key, this.hasBack = false});

  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return Container(
        color: theme.barBackgroundColor,
        child: Row(children: [
          if (hasBack)
            CupertinoButton(
              child: Icon(CupertinoIcons.left_chevron),
              onPressed: () {},
            ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text("document title"),
          )),
          CupertinoButton(
            child: Icon(CupertinoIcons.ellipsis_vertical),
            onPressed: () {},
          )
        ]));
  }
}

class SearchNav extends StatelessWidget {
  const SearchNav({
    super.key,
    required this.theme,
  });

  final CupertinoThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: theme.barBackgroundColor,
        child: Row(children: [
          CupertinoButton(
            child: Icon(CupertinoIcons.left_chevron),
            onPressed: () {},
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: CupertinoSearchTextField(placeholder: "Search"),
          )),
          CupertinoButton(
            child: Icon(CupertinoIcons.add),
            onPressed: () {},
          )
        ]));
  }
}

class MainMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ModalScaffold(child: IdentitySettings());
  }
}

class TabButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = CupertinoTheme.of(context);
    return CupertinoButton(
        child: Container(
            decoration: BoxDecoration(
                color: theme.barBackgroundColor,
                border: Border.all(color: CupertinoColors.activeBlue),
                boxShadow: [BoxShadow()],
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text("99+",
                  style: TextStyle(color: CupertinoColors.activeBlue)),
            )),
        onPressed: () {
          context.url = "/0";
        });
  }
}

class LinkButton extends StatelessWidget {
  String url;
  Widget child;
  LinkButton({required this.child, required this.url});

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
        child: child,
        onPressed: () {
          // on the web this opens another tab in the browser
          // other platforms manage their own tabs (and windows)
          if (kIsWeb) {
            js.context.callMethod('open', [window.location.href]);
          } else {
            throw "not implemented";
          }
        });
  }
}
