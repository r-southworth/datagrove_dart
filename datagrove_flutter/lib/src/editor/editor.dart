// ignore_for_file: prefer_const_constructors
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../ui/menu.dart';

import 'phone.dart' if (dart.library.html) 'web.dart';
export 'fake_web.dart' if (dart.library.html) 'web.dart';
// easy_web_view is not going work here because it blocks javascript channels
// instead we need something that will let us use channels, and probably we
// don't need iframes then.

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class EditorScreen extends StatefulWidget {
  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  @override
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
                print("appbar $id");
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
