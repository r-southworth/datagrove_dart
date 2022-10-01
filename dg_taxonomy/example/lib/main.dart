import 'package:flutter/cupertino.dart';
import 'package:dg_taxonomy/dg_taxonomy.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(home: MainView());
  }
}

class MainView extends StatelessWidget {
  const MainView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CupertinoButton(
      child: Text("pick"),
      onPressed: () async {
        var a = await TaxonomyPicker.pick(context, StringTree.from(aetnaTypes));
      },
    ));
  }
}
