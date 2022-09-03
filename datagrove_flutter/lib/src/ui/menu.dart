import 'package:flutter/cupertino.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

const headerStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

class Cmd {
  Cmd({required this.label, this.id, this.then});
  String? id;
  String label;
  Future<void> Function()? then;
}

// This shows a CupertinoModalPopup which hosts a CupertinoActionSheet.
Future<Cmd?> showCmd(BuildContext context, List<Cmd> label,
    {String? title}) async {
  return await showCupertinoModalPopup<Cmd>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
            title: title == null ? null : Text(title, style: headerStyle),
            // title: const Text('Title'),
            // message: const Text('Message'),
            actions: <CupertinoActionSheetAction>[
              for (final o in label)
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context, o);
                  },
                  child: PointerInterceptor(child: Text(o.label)),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
          ));
}
