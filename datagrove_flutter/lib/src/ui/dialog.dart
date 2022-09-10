import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalNav extends StatelessWidget
    implements ObstructingPreferredSizeWidget {
  Widget? title;
  Widget? action;
  bool valid;
  ModalNav({this.action, this.valid = false, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: CupertinoButton(
        padding: const EdgeInsets.all(0),
        onPressed: !valid
            ? null
            : () {
                Navigator.of(context).pop();
              },
        child: action ?? Container(),
      ),
      trailing: CupertinoButton(
          padding: const EdgeInsets.all(0),
          child: const Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop();
          }),
      middle: title,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kMinInteractiveDimensionCupertino);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}

class ModalScaffold extends StatelessWidget {
  Widget? title;
  Widget? action;
  bool valid;
  Widget child;
  ModalScaffold(
      {required this.child, this.action, this.valid = false, this.title});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: ModalNav(
          title: title,
          valid: valid,
          action: action,
        ),
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: child)));
  }
}

showModal(BuildContext context, Widget w) async {
  return showCupertinoModalBottomSheet(
      isDismissible: true,
      builder: (BuildContext context) {
        return w;
      },
      context: context);
}

// This shows a CupertinoModalPopup which hosts a CupertinoAlertDialog.
Future<bool> confirm2(BuildContext context, Widget content) async {
  return await showCupertinoModalPopup<bool>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No undo'),
          content: content,
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              /// This parameter indicates this action is the default,
              /// and turns the action's text to bold text.
              isDefaultAction: true,
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('No'),
            ),
            CupertinoDialogAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as deletion, and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      ) ??
      false;
}
