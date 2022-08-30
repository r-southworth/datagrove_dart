import 'package:flutter/cupertino.dart';

import '../../editor/editor.dart';
import 'page.dart';
import 'home.dart';

class ContactTab extends StatefulWidget {
  const ContactTab({Key? key}) : super(key: key);

  @override
  State<ContactTab> createState() => _ContactTabState();
}

const friend = "🤝";

class _ContactTabState extends State<ContactTab> {
  @override
  Widget build(BuildContext context) {
    return EditorScreen();

    return PageScaffold(
        leading: Container(),
        title: Text('$friend Contact'),
        search: 'Contacts',
        slivers: [HeadingSliver("📌 Pin", first: true), ListSliver2()]);
  }
}
