import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dg_bip39/dg_bip39.dart';
import 'package:dg_tool/dg_tool.dart';

// initializing riverpod is not great.
// https://stackoverflow.com/questions/65968725/
// https://github.com/rrousselGit/riverpod/issues/57

// the deep link for the entire system is to open a document and optionally configure some tools. Such a deep link will be the only document open on the page
// the user should first establish their identity, otherwise they won't be
final router = UrlRouter(
    onGeneratePages: (router) => [
          CupertinoPage(child: Login(child: MainView(router.url))),
        ]);

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
  runApp(const ProviderScope(child: DgApp()));
}

class DgApp extends StatelessWidget {
  const DgApp({super.key});

  @override
  Widget build(BuildContext context) {
    router:
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
          routeInformationParser: UrlRouteParser(),
          title: "Datagrove",
          debugShowCheckedModeBanner: false,
        ))));
  }
}

class SearchPane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  static Widget modal(BuildContext c) {
    return SearchPane();
  }
}

class BrowsePane extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

class MainView extends StatefulWidget {
  final String url;
  const MainView(this.url, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

Future<ToolSet> initialTools() async {
  return ToolSet(
    tool: [
      Tool(
        id: "search",
        icon: const Icon(CupertinoIcons.search),
        buildModal: (c) {
          return BottomModal(child: SearchPane.modal(c));
        },
        builder: (c) {
          return SearchPane();
        },
      )
    ],
    active: 0,
    bottomCount: 1,
  );
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return DgTool(
        child: red("document here")
        leading: [
          CupertinoButton(
              child: const Icon(CupertinoIcons.folder),
              onPressed: () {
                context.url = "/folder";
              }),
          CupertinoButton(
              child: const Icon(CupertinoIcons.search),
              onPressed: () {
                context.url = "/search";
              }),
          CupertinoButton(
              child: const Icon(CupertinoIcons.gear),
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
