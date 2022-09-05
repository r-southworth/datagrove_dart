// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'plugin/rules.dart';
import 'parentFile.dart';
import 'schoolyear.dart';
import 'schoolform.dart';
import 'teacher.dart';
import 'student.dart';

import 'app.dart';
import 'settingsdlg.dart';

// what state do I need to let the user change the school state?
// how does affect browser tabs?

// done is active only if
// we started with 0 and added 1 child
// we started with 1.
// or we are in school database.

// this might be more like settings?

// there are two ideas of school here
// a group of users sharing the student record
//

class School extends StatefulWidget {
  bool needChild = false;
  School({this.needChild = false});

  static show(BuildContext context) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return School();
    }));
  }

  @override
  State<School> createState() => _SchoolState();
}

class _SchoolState extends State<School> {
  SchoolData school = SchoolData();
  final _formKey = GlobalKey<FormState>();
  var rules = JurisdictionRules.empty();
  var filing = DgMenu();
  bool standardDate = true;
  bool start0 = true;
  int year = 2022;

  @override
  initState() {
    super.initState();
    // family = widget.initialFamily;
    // if (family.jurisdiction.isNotEmpty) {
    //   _jurisdiction();
    // }
  }

  _jurisdiction() async {
    var x = await ruleManager.rules(school.jurisdiction);
    setState(() {
      rules = x;
      // filing = rules.filing(family);
    });
  }

  _standardDate(bool x) {
    setState(() {
      standardDate = x;
    });
  }

  @override
  setState(Function() f) {
    //client.update();
    super.setState(f);
  }

  Widget toFile(DgMenuItem o) {
    var m = "File";
    var err = "";

    // we need to check if the report is ready
    if (school.student.isEmpty) {
      err = "Add student";
    }
    if (school.teacher.isEmpty) {
      err = "Add teacher";
    }

/*
    var filed = (school.filedDate ?? {})[o.lastSentKey];
    //if (i == 0) filed = DateTime.now();
    if (filed != null) {
      m = mmddyyyy.format(filed);
    }*/

    // PrintFn fn = printLetter;

    // fn = printQuarter(i - 2);

    Widget child = CupertinoButton(
        onPressed: () {
          ParentFile.show(context, school, o);
        },
        child: Text(m));
    if (err.isNotEmpty) {
      child = Text(err,
          style: TextStyle(
              fontSize: 13.0,
              color: CupertinoColors.secondaryLabel.resolveFrom(context)));
    }

    return CupertinoFormRow(prefix: Text(o.title), child: child);
  }

  final tf = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: CupertinoTextField());

  @override
  Widget build(BuildContext context) {
    var wtf = Row(children: [
      Expanded(child: Container()),
      Icon(CupertinoIcons.right_chevron)
    ]);

    var mdx = "";
    if (standardDate) {
      mdx =
          "You have elected to report on November 15, January 30, April 15 and June 30";
    } else {
      mdx = """The number of reports should be proportional to the
period of home instruction (e.g. for a student beginning home school in February submit only 3rd and 4th quarterly
reports).""";
    }

    // spinning the date wheel is going to spin the value in the field
    // so we don't want to update the value until the dialog is dismissed.

    List<Widget> ds() {
      return [
        for (final o in [0, 1, 2, 3])
          CupertinoFormRow(
              prefix: Text(dname[o]),
              child: DateField(
                  date: DateTime.fromMillisecondsSinceEpoch(school.duedate[o]),
                  onChange: (DateTime d) {
                    school.duedate[o] = d.millisecondsSinceEpoch;
                    setState(() {});
                  })),
      ];
    }

    final style = TextStyle(
        fontStyle: FontStyle.italic,
        color: CupertinoColors.lightBackgroundGray);

    final filingBlock = filing.children.isEmpty
        ? Container()
        : CupertinoFormSection.insetGrouped(
            header: Text("Recommended Filings"),
            children: [for (final o in filing.children) toFile(o)]);

    final parentBlock =
        CupertinoFormSection.insetGrouped(header: Text("Teacher"), children: [
      for (final o in school.teacher)
        listTile(
            child: label(o.firstLast),
            onTap: () {
              TeacherEditor.show(context, school, o);
            }),
      listTile(
          child: label("Teacher"),
          onTap: () async {
            var s = Teacher();
            school.supervisor.add(s);
            await TeacherEditor.show(context, school, s);
            setState(() {});
          })
    ]);

    final studentBlock =
        CupertinoFormSection.insetGrouped(header: Text("student"), children: [
      for (final o in school.student)
        listTile(
            child: label(o.firstLast),
            onTap: () {
              StudentEditor.show(context, school, o);
            }),
      listTile(
          child: label("Add Student"),
          onTap: () async {
            var s = Student();
            school.student.add(s);
            await StudentEditor.show(context, school, s);
            setState(() {});
          })
    ]);

    final blocks = [
      // check list for all the things you need to do

      CupertinoFormSection.insetGrouped(
          header: Text("Dates of Quarterly Report Submission"),
          children: [
            CupertinoFormRow(
                prefix: label("Standard dates"),
                child: CupertinoSwitch(
                    value: standardDate, onChanged: _standardDate)),
            if (!standardDate) ...ds()
          ]),
      Mdown(mdx)
    ];

    final girl = ["👧", "👧🏾", "👧🏽", "👧🏻"][DateTime.now().second % 4];

    bool schoolOk = school.district.name.isNotEmpty;
    bool parentOk = school.supervisor.isNotEmpty;
    bool studentOk = school.student.isNotEmpty;
    bool filingOk = schoolOk && parentOk && studentOk;
    final page = SingleScaffold(

        // leading: CupertinoButton(
        //     padding: EdgeInsets.all(10),
        //     child: Text("Done"),
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     }),
        back: false,
        title: "$girl Pawpaw",
        trailing: settingsButton(context),
        children: [
          if (schoolOk) SliverToBoxAdapter(child: parentBlock),
          if (parentOk) SliverToBoxAdapter(child: studentBlock),
          if (studentOk)
            for (final e in blocks) SliverToBoxAdapter(child: e),
          if (filingOk) SliverToBoxAdapter(child: filingBlock),
        ]);

    return page;
  }
}

var dname = [
  "1st Quarter",
  "2nd Quarter",
  "3rd Quarter",
  "4th Quarter",
];

// seems like I keep writing this? how do we reuse?

// choose a related school
/*
    final schoolBlock = SliverToBoxAdapter(child: s
        CupertinoFormSection.insetGrouped(header: Text("School"), children: [
      listTile(
          child: label(school.district.name.isEmpty
              ? "Tap to choose school"
              : school.district.name),
          onTap: () async {
            // we should go directly to the school picker, then only go to the
            // entry screen if the picker fails. they can also seach from the DistrictEditor
            // await pickSchool(context, family);
            _jurisdiction();
          }),
      //SchoolYear(year, (int) {}),
    ]));

    */
