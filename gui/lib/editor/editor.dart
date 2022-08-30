// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:easy_web_view/easy_web_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../datagrove_flutter/ui/menu.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class EditorScreen extends StatefulWidget {
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override

  // what does it take to make this work?
  Widget build2(BuildContext context) {
    final w = Editor();
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        largeTitle: Text('Datagrove'),
      ),
      SliverToBoxAdapter(child: SizedBox(width: 400, height: 400, child: w))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
            leading: CupertinoButton(
              child: Icon(CupertinoIcons.left_chevron),
              onPressed: () async {
                //showAlertDialog("wtf?", context);
                var id = await showCmd(
                    context,
                    <Cmd>[
                      Cmd(id: 'pin', label: 'Pin'),
                      Cmd(id: 'block', label: 'Block'),
                      Cmd(id: 'report', label: 'Report'),
                    ],
                    title: 'pinned ');
                print(id);
              },
            ),
            middle: Text("7th grade Math"),
            trailing: PointerInterceptor(
                child: PopupMenuButton<Menu>(
                    // Callback that sets the selected popup menu item.
                    onSelected: (Menu item) {
                      setState(() {
                        //_selectedMenu = item.name;
                      });
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                          PopupMenuItem<Menu>(
                            value: Menu.itemOne,
                            child: PointerInterceptor(child: Text('Download')),
                          ),
                        ])

                // trailing: CupertinoButton(
                //   child: Icon(CupertinoIcons.ellipsis_vertical),
                //   onPressed: () {},
                // )

                )),
        body: Editor());
  }
}

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);
  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  static ValueKey key = const ValueKey('key_0');

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
        child: EasyWebView(
      src: 'http://localhost:5173',
      onLoaded: (_) {},
      // this seems to just be debug when true, displays the url
      //convertToWidgets: false,
      key: key,
    ));
  }
}

class YoutubePip extends StatelessWidget {
  bool youtubeOpen = false;
  static ValueKey key3 = const ValueKey('key_2');
  Widget child;
  YoutubePip({required this.child});
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      child,
      Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Container(),
          ),
          Expanded(
              flex: 1,
              child: Container(
                width: (youtubeOpen) ? 500 : 0,
                child: EasyWebView(
                  src: 'http://www.youtube.com/embed/IyFZznAk69U',
                  onLoaded: (_) {},
                  key: key3,
                ),
              )),
        ],
      )
    ]);
  }
}

void showAlertDialog(String content, BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => PointerInterceptor(
      intercepting: true,
      child: AlertDialog(
        content: Text(content),
        actions: [
          TextButton(
            onPressed: Navigator.of(context, rootNavigator: true).pop,
            child: const Text('Close'),
          ),
        ],
      ),
    ),
  );
}
