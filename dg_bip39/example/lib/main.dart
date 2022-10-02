import 'package:flutter/cupertino.dart';
import 'package:dg_bip39/dg_bip39.dart';
import 'package:provider/provider.dart';
import 'package:url_router/url_router.dart';

void main() async {
  await User.open();
  late final router = UrlRouter(
      onGeneratePages: (router) => [
            CupertinoPage(child: Login(child: MyApp(router.url))),
          ]);
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => User.value)],
      child: CupertinoApp.router(
          routeInformationParser: UrlRouteParser(), routerDelegate: router)));
}

class MyApp extends StatelessWidget {
  final String url;
  const MyApp(this.url, {super.key});

  @override
  Widget build(BuildContext context) {
    final a = Provider.of<User>(context);
    return CupertinoPageScaffold(
      child: Center(
        child: Text("Hi ${a.active?.name ?? ""}! ${url} ",
            style: TextStyle(color: CupertinoColors.white)),
      ),
    );
  }
}

/*
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await IdentityManager.open();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<IdentityManager>(create: (_) => IdentityManager()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
        title: 'Bip39 Login Demo',
        theme: CupertinoThemeData(),
        home: Login(
          builder: (BuildContext context) =>
              MyHomePage(title: 'Bip39 Login Demo'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final pr = Provider.of<IdentityManager>(context);
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.title),
      ),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              child: Text("Add identity"),
              onPressed: () async {
                await showAddIdentity(context);
              },
            ),
            Text("logged in as ${pr.name}",
                style: TextStyle(color: CupertinoColors.systemRed)),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
*/