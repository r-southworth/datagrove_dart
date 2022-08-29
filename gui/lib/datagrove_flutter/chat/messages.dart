import 'package:flutter/cupertino.dart';
import 'package:file_picker/file_picker.dart';
import 'messageinput.dart';
import 'chat.dart';
import 'messagecontroller.dart';

// we need some way to initialize the channel for this screen

class MessageScreen extends StatefulWidget {
  //BrowserController browser;
  MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  var showApps = true;

  final mc = MessageController();
  final tc = TextEditingController();

  @override
  void initState() {
    super.initState();
    mc.addListener(() {
      setState(() {
        //
      });
    });
  }

  @override
  void dispose() {
    mc.dispose();
    tc.dispose();
    super.dispose();
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      result.files.single.path;
    }
  }

  @override
  Widget build(BuildContext context) {
    var nav2 = CupertinoNavigationBar(
        leading: CupertinoButton(
            child: const Icon(CupertinoIcons.chevron_back),
            onPressed: () => Navigator.of(context).pop()),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          // CupertinoButton(
          //     child: const Icon(CupertinoIcons.video_camera),
          //     onPressed: () => MessageCall.show(context)),
          CupertinoButton(
              child: const Icon(CupertinoIcons.folder),
              onPressed: () => {}), //showFiling(context)),
        ]),
        middle: Text("title"));

    //return splitter();
    return CupertinoPageScaffold(
        child: Column(children: [
      nav2,
      //Expanded(child: Container()),
      Expanded(child: Chat(mc)),
      ChatInput(mc)
    ]));
  }
}
