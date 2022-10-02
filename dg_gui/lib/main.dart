import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dg_bip39/dg_bip39.dart';
import 'package:dg_rail/dg_rail.dart';

class Dgf {}

class Store {}

// we can be online
class LoginStore {
  bool identityExists = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //registerWeb();
  await User.open();
  final st = Store();
  runApp(MultiProvider(
      providers: [
        Provider<Store>(create: (_) => st),
        ChangeNotifierProvider(create: (_) => User.value)
      ],
      child: DgApp(
          router: UrlRouter(
              onGeneratePages: (router) => [
                    CupertinoPage(child: Login(child: MainView(router.url))),
                  ]))));
}

class MainView extends StatefulWidget {
  String url;
  MainView(this.url, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return DgRail(
        tool: [
          CupertinoButton(
              child: Icon(CupertinoIcons.folder),
              onPressed: () {
                context.url = "/folder";
              }),
          CupertinoButton(
              child: Icon(CupertinoIcons.search),
              onPressed: () {
                context.url = "/search";
              }),
          CupertinoButton(
              child: Icon(CupertinoIcons.gear),
              onPressed: () {
                context.url = "/settings";
              }),
          CupertinoButton(
              child: const Icon(CupertinoIcons.ellipsis_vertical),
              onPressed: () {
                // probably modal dialogs
              })
        ],
        child: CustomScrollView(slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text("Ironshop ${context.url}"),
          ),
          SliverToBoxAdapter(
              child: Column(children: [
            // list the branches we have access to, start with welcome
            for (var i = 0; i < 100; i++)
              CupertinoListTile(title: Text("branch $i"))
          ]))
        ]));
  }
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
        ),
        child: Material(
            child: MediaQuery.fromWindow(
                child: CupertinoApp.router(
          useInheritedMediaQuery: true,
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
        ))));
  }
}
//https://github.com/flutter/flutter/issues/48438

// return MediaQuery.fromWindow(
//   child: CupertinoApp(
//     useInheritedMediaQuery: true,
//     home: // ...
//   )
// );