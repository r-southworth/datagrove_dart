// this should potentially be a bottom sheet
// this should be in datagrove library?

import 'package:flutter/cupertino.dart';

class Share extends StatefulWidget {
  @override
  State<Share> createState() => _ShareState();

  static show(BuildContext context) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return Share();
    }));
  }
}

class _ShareState extends State<Share> {
  @override
  Widget build(BuildContext context) {
    return Text("share");
  }
}
