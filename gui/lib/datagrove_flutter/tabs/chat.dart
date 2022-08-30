import 'package:flutter/cupertino.dart';

import 'page.dart';
import 'home.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        leading: Container(),
        title: Text('💬 Chat'),
        search: 'Chats',
        slivers: [HeadingSliver("📌 Pin", first: true), ListSliver2()]);
  }
}
