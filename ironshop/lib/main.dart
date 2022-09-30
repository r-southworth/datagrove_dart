import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dg_bip39/dg_bip39.dart';

class Dgf {}

class Store {}

// we can be online
class LoginStore {
  bool identityExists = false;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //registerWeb();
  // at this point we know if we had already established a link
  // final fl = await Dgf.open(
  //     dnsName: 'edit.datagrove.com',
  //     style: DgfStyle(
  //       brandName: 'Datagrove Issues',
  //     ));

  final st = Store();
  runApp(MultiProvider(
      providers: [Provider<Store>(create: (_) => st)],
      child: DgApp(
          router: UrlRouter(
              onGeneratePages: (router) => [
                    CupertinoPage(child: MainView(router.url)),
                  ]))));
}

class MainView extends StatefulWidget {
  String url;
  MainView(this.url, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

// we need a login state
// we need a
class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    // if not logged in, then we need to login
    // login is fine offline; we just need a bip39 from secure storate
    // we log out, we want to log out all the tabs, but not really an option right now.

    return CupertinoPageScaffold(child: Text(widget.url));
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
