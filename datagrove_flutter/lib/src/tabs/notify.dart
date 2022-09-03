import 'package:flutter/cupertino.dart';

import 'page.dart';
import 'home.dart';

class AlertTab extends StatefulWidget {
  const AlertTab({Key? key}) : super(key: key);

  @override
  State<AlertTab> createState() => _AlertTabState();
}

class _AlertTabState extends State<AlertTab> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: Container(),
        title: Text('🔔 Notify'),
        search: 'Chats',
        slivers: [ListSliver2()]);
  }
}
