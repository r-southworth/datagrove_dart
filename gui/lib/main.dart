import 'package:datagrove/editor/editor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'datagrove_flutter/client/datagrove_flutter.dart';
import 'datagrove_flutter/tabs/scaffold.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerWeb();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // at this point we know if we had already established a link
  final fl = await Dgf.open(
      dnsName: 'edit.datagrove.com',
      style: DgfStyle(
        brandName: 'Datagrove',
      ));

  runApp(DgApp(fl));
}
