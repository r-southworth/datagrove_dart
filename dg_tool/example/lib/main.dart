import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:dg_tool/dg_tool.dart';
import 'package:flutter/services.dart';
import 'package:url_router/url_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// do you need to be logged in to run anything? no backup can work
// strange to back up and try to fix everything...

// we have to create a provider so we can get a ref and wait on it.
// we wait in

void main() async {
  // this is going to need to open the database component
  // so we'll have to make sure we only call once with many components.
  //final register = await DgTool.open();
  //register.add(MyToolPackage());

  runApp(ProviderScope(child: Splash()));
}

class Splash extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Configuration> config = ref.watch(configProvider);

    return config.when(
      loading: () => const CupertinoActivityIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (config) {
        return MyApp();
      },
    );
  }
}

class Configuration {}

final configProvider = FutureProvider<Configuration>((ref) async {
  // final content = json.decode(
  //   await rootBundle.loadString('assets/configurations.json'),
  // ) as Map<String, Object?>;

  return Configuration();
});

class MyApp extends StatelessWidget {
  late final router = UrlRouter(
    // Return a single MainView regardless of path
    onGeneratePages: (router) => [
      const CupertinoPage(child: MainView()),
    ],
  );

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp.router(
      routeInformationParser: UrlRouteParser(),
      routerDelegate: router,
    );
  }
}

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return DgTool();
  }
}
