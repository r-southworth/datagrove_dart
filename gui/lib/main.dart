import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'datagrove_flutter/client/datagrove_flutter.dart';
import 'datagrove_flutter/tabs/scaffold.dart';
import 'school/store/store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'pawpaw.datagrove.com',
      style: DgfStyle(
        brandName: 'Pawpaw',
      ));

  runApp(App(fl));
}

class App extends StatelessWidget {
  Dgf fl;
  App(this.fl);

  @override
  Widget build(BuildContext context) {
    final Brightness platformBrightness =
        WidgetsBinding.instance.window.platformBrightness;
    return Theme(
        data: ThemeData(
            brightness: platformBrightness,
            scaffoldBackgroundColor: CupertinoColors.black),
        child: CupertinoApp(
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
            // routerDelegate:
            //     RoutemasterDelegate(routesBuilder: (context) => routes),
            // routeInformationParser: RoutemasterParser(),

            title: "Datagrove",
            debugShowCheckedModeBanner: false,
            home: ChangeNotifierProvider<Dgf>(
                create: (_) => fl, child: HomePage())));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

//return OnboardPage(title: Text('$girl Pawpaw'), name: 'Pawpaw');
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // we need builders here.
    return TabScaffold(
        leading: Container(),
        title: Text("$girl Datagrove"),
        label: 'Schools',
        trailing: const [],
        children: []);
  }
}
