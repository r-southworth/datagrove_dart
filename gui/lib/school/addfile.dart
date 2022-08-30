import 'package:url_launcher/url_launcher.dart';

import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'plugin/rules.dart';
import 'app.dart';

// basic idea here is to add a file to the record for a student in the school

class Import extends StatefulWidget {
  ///String path;
  List<Student> student = [];
  Import();

  static show(BuildContext context) async {
    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return Import();
    }));
  }

  @override
  State<Import> createState() => _ImportState();
}

class _ImportState extends State<Import> {
  String? path;
  var tc = TextEditingController();
  List<Student> student = [];

  initState() {
    super.initState();
    tc.addListener(_update);
    _update();
  }

  _update() {
    var tx = tc.text.toLowerCase();
    setState(() {
      student = widget.student
          .where((e) => e.lastFirst.toLowerCase().startsWith(tx))
          .toList();
    });
  }

  _upload() async {
    var f = await getDesktopFile();
    if (f != null &&
        f.paths != null &&
        f.paths.isNotEmpty &&
        f.paths[0] != null) {
      await launchUrl(Uri.file(f.paths[0]!));
      setState(() {
        path = f.paths[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold2(
        title: basenameWithoutExtension(path ?? "Upload file"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
                child: Icon(CupertinoIcons.upload_circle), onPressed: _upload),
            CupertinoButton(
                child: Icon(CupertinoIcons.plus),
                onPressed: () {
                  // begin a new family
                  //School.show(context, Family());
                }),
          ],
        ),
        child: SafeArea(
            child:
                // we need a searchable family list here, and a new option.
                // search can stay at the top of expanded list.
                Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            CupertinoSearchTextField(controller: tc, placeholder: 'search'),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(children: [
              for (final o in student)
                lt.CupertinoListTile(
                    title: Text(o.firstLast),
                    trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                      CupertinoButton(
                          child: Text("Hours"),
                          onPressed: () {
                            // we have to change this to hours per student only.
                            //Hours.show(context, o);
                          }),
                      CupertinoButton(
                          child: Text("Plan"),
                          onPressed: () {
                            // School.show(context, o);
                          })
                    ]),
                    onTap: () {
                      //School.show(context, o);
                    })
            ])))
          ]),
        )));
  }
}
