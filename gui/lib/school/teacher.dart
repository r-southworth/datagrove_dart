import 'package:flutter/cupertino.dart';
import '../datagrove_flutter/client/datagrove_flutter.dart';
import 'plugin/rules.dart';

import 'app.dart';
import '../datagrove_flutter/ui/schoolform.dart';

// Teachers in this case are authorized writes to this datum
// so here we are granting rights to other users as well as capturing some
// basic data.

class TeacherEditor extends StatefulWidget {
  SchoolData family;
  Teacher parent;
  TeacherEditor(this.family, this.parent);

  static show(BuildContext context, SchoolData f, Teacher s) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return TeacherEditor(f, s);
    }));
  }

  @override
  State<TeacherEditor> createState() => _TeacherEditorState();
}

class _TeacherEditorState extends State<TeacherEditor> {
  final cs = ControllerSet();
  @override
  dispose() {
    cs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.parent;
    return SingleScaffold2(
        title: widget.parent.firstLast,
        trailing: CupertinoButton(
            child: Icon(CupertinoIcons.delete),
            onPressed: () async {
              var delete = await confirmDelete(context);
              if (delete) {
                Navigator.of(context).pop();
              }
            }),
        child: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          CupertinoFormSection.insetGrouped(
              header: Row(
                children: [
                  Text("Teacher"),
                ],
              ),
              children: [
                name(
                    cs.at("firstName", f.firstName, (s) {
                      f.firstName = s;
                    }),
                    cs.at("lastName", f.lastName, (s) {
                      f.lastName = s;
                    })),
                address(
                  cs.at("address", f.address, (s) {
                    f.address = s;
                  }),
                  cs.at("address2", f.address2, (s) {
                    f.address2 = s;
                  }),
                ),
                city(
                  cs.at("city", f.city, (s) {
                    f.city = s;
                  }),
                ),
                stateZip(
                  cs.at("state", f.state, (s) {
                    f.state = s;
                  }),
                  cs.at("zip", f.zip, (s) {
                    f.zip = s;
                  }),
                ),
                phone(
                  cs.at("phone", f.phone, (s) {
                    f.phone = s;
                  }),
                  cs.at("phone2", f.phone2, (s) {
                    f.phone2 = s;
                  }),
                ),
                email(
                  cs.at("email", f.email, (s) {
                    f.email = s;
                  }),
                )
              ])
        ]))));
  }
}
