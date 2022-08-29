import 'package:flutter/cupertino.dart';
import 'package:share_plus/share_plus.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  static show(BuildContext context) {
    Navigator.of(context).push(CupertinoPageRoute(
      builder: (context) => InfoScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    share() {
      Share.share('check out my website https://example.com',
          subject: 'portfolio');
    }

    var actions = Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
      CupertinoButton(
          child: Icon(CupertinoIcons.share), onPressed: () => share()),
    ]);

    navBar() {
      return CupertinoNavigationBar(
        leading: CupertinoButton(
            child: Icon(CupertinoIcons.left_chevron),
            onPressed: () => Navigator.of(context).pop()),
        trailing: actions,
        middle: Text("Info"),
      );
    }

    var content = Text("info");

    return CupertinoTabView(builder: (context) {
      return CupertinoPageScaffold(
          navigationBar: navBar(), child: SafeArea(child: content));
    });
  }
}
