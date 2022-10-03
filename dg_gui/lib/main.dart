import 'package:dg_gui/tool.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
//import 'package:dg_bip39/dg_bip39.dart';
import 'package:dg_tool/dg_tool.dart';

// initializing riverpod is not great.
// https://stackoverflow.com/questions/65968725/
// https://github.com/rrousselGit/riverpod/issues/57

// the deep link for the entire system is to open a document and optionally configure some tools. Such a deep link will be the only document open on the page
// the user should first establish their identity, otherwise they won't be
final router = UrlRouter(
    onGeneratePages: (router) => [
          CupertinoPage(child: MainView(router.url)),
        ]);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //registerWeb();
  initializeTools(await initialTools());
  runApp(const ProviderScope(child: DgApp()));
}

class DgApp extends StatelessWidget {
  const DgApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
        data: ThemeData(),
        child: Material(
            child: MediaQuery.fromWindow(
                child: CupertinoApp.router(
          useInheritedMediaQuery: true,
          theme: const CupertinoThemeData(),
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

class MainView extends StatefulWidget {
  final String url;
  const MainView(this.url, {super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return DgTool(child: DocumentView());
  }
}

class DocumentView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        largeTitle: Text("Ironshop ${context.url}"),
      ),
      SliverToBoxAdapter(
          child: Column(children: [
        // list the branches we have access to, start with welcome
        for (var i = 0; i < 100; i++)
          CupertinoListTile(title: Text("branch $i"))
      ]))
    ]);
  }
}

    /* work around for Text() defaulting black
        return MediaQuery.fromWindow(
  child: CupertinoApp(
    useInheritedMediaQuery: true,
    home: // ...
  )
);*/
/*
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
        */