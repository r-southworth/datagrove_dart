import 'package:flutter/cupertino.dart';

import 'page.dart';

class StarredTab extends StatefulWidget {
  const StarredTab({Key? key}) : super(key: key);

  @override
  State<StarredTab> createState() => _StarredTabState();
}

class _StarredTabState extends State<StarredTab> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: Container(),
        title: Text('🔔 Notify'),
        search: 'Chats',
        slivers: [ListSliver2()]);
  }
}
