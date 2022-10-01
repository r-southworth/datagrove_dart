library dg_taxonomy;

/// A Calculator.
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class TaxonomyPicker extends StatelessWidget {
  static Future<String?> pick(BuildContext context, StringTree items) async {
    return showCupertinoModalBottomSheet<String?>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoScaffold(
              body: Column(children: [
            CupertinoNavigationBar(
                leading: CupertinoButton(
                    onPressed: () {
                      Navigator.of(context).pop(null);
                    },
                    child: const Icon(CupertinoIcons.left_chevron)),
                middle: Text(items.name,
                    style: const TextStyle(color: CupertinoColors.white))),
            Expanded(
                child: ListView(children: [
              for (final o in items.children)
                CupertinoListTile(
                    onTap: () async {
                      if (o.children.isEmpty) {
                        Navigator.of(context).pop(o.path);
                      } else {
                        var v = await pick(context, o);
                        if (v != null) {
                          Navigator.of(context).pop(v);
                        }
                      }
                    },
                    title: Text(o.name,
                        style: const TextStyle(color: CupertinoColors.white)))
            ]))
          ]));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class StringTree {
  String name;
  String path;
  List<StringTree> children;

  StringTree(this.name, this.path, this.children);

  static StringTree empty() {
    return StringTree("", "", []);
  }

  static StringTree from(List<String> input) {
    List<StringTree> stack = [StringTree("", "", [])];
    int count(String s) {
      return s.split(".").length;
    }

    for (int i = 0; i < input.length; i++) {
      var s = input[i];
      int level = count(s);
      s = s.substring(level - 1);
      while (level < stack.length) {
        stack.removeLast();
      }
      if (level > stack.length) {
        return StringTree.empty(); // not valid to skip levels
      }
      if (level == stack.length) {
        var path = "${stack.last.path}/$s";
        var tr = StringTree(s, path, []);
        stack.last.children.add(tr);
        stack.add(tr);
      }
    }
    return stack[0];
  }
}

const aetnaTypes = [
  "Claim question",
  "Rework",
  ".Additional information received",
  ".Incorrect benefit applied",
  ".Aetna pricing error",
  ".Incorrect member",
  ".Incorrect Provider",

  "Appeals", // email alert
  "Clinical Notes",
  "Provider Billing Issue",
  "Stoploss", // email alert
  "ASD",
  "ATV",
  "Document Viewer",
  "Claim file issue",
];
