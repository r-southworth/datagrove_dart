import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../datagrove_flutter/client/datagrove_flutter.dart';
import 'app.dart';
import '../datagrove_flutter/ui/app.dart';
import '../datagrove_flutter/ui/menu.dart';
import 'school.dart';
import 'share.dart';
import 'student.dart';

class TableEdit extends StatefulWidget {
  AppTable table;
  int row;
  TableEdit(this.table, this.row) {}

  static show(BuildContext context, AppTable f, int row) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return TableEdit(f, row);
    }));
  }

  @override
  State<TableEdit> createState() => _TableEditState();
}

class _TableEditState extends State<TableEdit> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
          largeTitle: Text("Add record"),
          trailing: CupertinoButton(
              child: Icon(CupertinoIcons.delete),
              onPressed: () async {
                var delete = await confirmDelete(context);
                if (delete) {
                  Navigator.of(context).pop();
                }
              })),
      SliverList(
          delegate: SliverChildListDelegate([
        Text("something here"),
      ]))
    ]));
  }
}
