import 'package:flutter/cupertino.dart';

import '../../editor/editor.dart';
import 'page.dart';
import 'home.dart';

class MessageTab extends StatefulWidget {
  const MessageTab({Key? key}) : super(key: key);

  @override
  State<MessageTab> createState() => _MessageTabState();
}

const friend = "🤝";

class _MessageTabState extends State<MessageTab> {
  @override
  Widget build(BuildContext context) {
    return EditorScreen();

    return PageScaffold(
        leading: Container(),
        title: Text('$friend Messages'),
        search: 'Messages',
        slivers: [HeadingSliver("📌 Pin", first: true), ListSliver2()]);
  }
}
