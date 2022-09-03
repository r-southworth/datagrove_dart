import 'package:flutter/cupertino.dart';

// This should generalize to confirm some action

// This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
Future<bool> confirm(
    {required Widget prompt, required BuildContext context}) async {
  bool shouldDelete = false;
  await showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text('Alert'),
      content: prompt,
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            shouldDelete = true;
            Navigator.pop(context, true);
          },
          child: const Text('Yes'),
        )
      ],
    ),
  );
  return shouldDelete;
}

Future<bool> confirmDelete(BuildContext context) async {
  return confirm(prompt: const Text('Delete?'), context: context);
}
