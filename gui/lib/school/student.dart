// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';

import '../datagrove_flutter/ui/app.dart';
import '../datagrove_flutter/ui/confirm.dart';
import '../datagrove_flutter/client/datagrove_flutter.dart';
import '../datagrove_flutter/ui/date.dart';
import '../datagrove_flutter/tabs/home.dart';
import '../datagrove_flutter/tabs/scaffold.dart';
import '../datagrove_flutter/ui/mdown.dart';
import 'plugin/rules.dart';
import 'app.dart';
import '../datagrove_flutter/ui/schoolform.dart';
import 'district.dart';

// this may be our student, or a student in a related school
// these should be built in slivers.
// this should just be part of pawpaw, its not generated.
class StudentPage extends StatefulWidget {
  const StudentPage({Key? key}) : super(key: key);

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  @override
  initState() {
    super.initState();
    // here we can go get our controllers
    // they will fill with values asynchronously.
  }

  @override
  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
        trailing: [],
        title: Text("student"),
        slivers: [
          // here we should build the list of
        ]);
  }
}

class StudentEditor extends StatefulWidget {
  JurisdictionRules rules;
  SchoolData family;
  Student student;
  StudentEditor(this.family, this.student, this.rules);

  static show(BuildContext context, SchoolData f, Student s) async {
    var r = await ruleManager.rules(f.jurisdiction);
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return StudentEditor(f, s, r);
    }));
  }

  @override
  State<StudentEditor> createState() => _StudentEditorState();
}

class _StudentEditorState extends State<StudentEditor> {
  final cs = ControllerSet();
  int year = 2022;

  bool common = true;
  _grade(int x) {
    setState(() {
      widget.student.grade = x;
    });
  }

  get grade => widget.student.grade;

  @override
  dispose() {
    cs.dispose();
    super.dispose();
  }

  _common(bool x) {
    setState(() {
      common = x;
    });
  }

  int quarter = 0;
  _setQuarter(int x) {
    setState(() {
      quarter = x;
    });
  }

  _pickCourses() async {
    //await CourseEditor.show(context, widget.family, widget.student);
    setState(() {});
  }

  _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // final f = widget.family;
    final st = widget.student;
    final tf = Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: CupertinoTextField());

    var title = widget.student.firstLast;
    if (title.isEmpty) title = "Add Student";

    final date = widget.student.birth;
    // In this example, the date value is formatted manually. You can use intl package
    // to format the value based on user's locale settings.

    var mdx = "";
    if (common) {
      // display the options that still allow it to be common core.
      mdx =
          """English Lit, Algebra, World History, Art, Music, French, Latin, Geology""";
    } else {
      mdx = """
[NYSED requirements for home school instruction](https://www.datagrovecr.com)

[Form for providing a IHIP (Individualized Homeschool Instruction Plan).](https://www.datagrovecr.com) 

[Click here to review your custom IHIP.](https://www.datagrovecr.com)
 """;
    }
/*
    final ip = CupertinoFormSection.insetGrouped(
        header: Text("Instructional Plan"),
        children: [
          CupertinoFormRow(
              prefix: label("Common Core"),
              child: CupertinoSwitch(
                onChanged: _common,
                value: common,
              )),
          if (!common)
            CupertinoFormRow(
                prefix: label("Custom"),
                child: Row(children: [
                  Expanded(child: Container()),
                  CupertinoButton(
                    onPressed: () async {
                      await getDesktopFile();
                    },
                    child: Text("Upload"),
                  ),
                ])),
          if (common)
            listTile(
                child: label("Courses (optional)"),
                onTap: () async {
                  await CourseEditor.show(
                      context, widget.family, widget.student);
                  setState(() {});
                }),
        ]);*/
    var requiresTest = true;

    return SingleScaffold2(
        title: title,
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
          // we could start with a card with actions that allow the parent to drop the child
          //
          Mdown(widget.rules.evaluateStudent(widget.student),
              info: (String key) {
            //showInfo(context, widget.rules.info(key));
          }),
          CupertinoFormSection.insetGrouped(
              header: Row(
                children: [
                  Text("Student"),
                ],
              ),
              children: [
                name(
                  cs.at("firstName", st.firstName, (s) {
                    st.firstName = s;
                  }),
                  cs.at("lastName", st.lastName, (s) {
                    st.lastName = s;
                  }),
                ),
                CupertinoFormRow(
                    prefix: Text("Birth"),
                    child: DateField(
                        date: widget.student.birth,
                        onChange: (DateTime d) {
                          widget.student.birth = d;
                          // if the grade is unknow, we should try to estimate it here.
                        })),
                //if (widget.student.birth != null)
                CupertinoFormRow(
                    prefix: Text("Grade"),
                    child: gradesetPicker(grade,
                        _grade)), // GradeField(grade: grade, onChange: _grade)),
                //if (widget.student.birth != null)
                CupertinoFormRow(
                  prefix: label("District"),
                  child: districtPicker(context, st.district, (String s) {
                    st.district = s;
                    _refresh();
                  }),
                ),
                CupertinoFormRow(
                    prefix: label("Homeschooling"),
                    child: CupertinoSwitch(
                      onChanged: (bool x) {},
                      value: true,
                    )),
                if (requiresTest)
                  testScore(cs.at("testScore", st.testScore, (s) {
                    st.testScore = s;
                  })),
                if (requiresTest)
                  testScore(cs.at("testType", st.testType, (s) {
                    st.testType = s;
                  })),
                if (widget.family.isNyc)
                  CupertinoFormRow(
                      prefix: label("NYC ID"),
                      child: CupertinoTextField(
                        placeholder: "Optional",
                      )),
              ]),
          Center(
              child: CupertinoButton(
                  onPressed: _pickCourses, child: Text("Choose courses"))),
          if (widget.student.subject.isNotEmpty)
            HoursSheet2(widget.student, grade),
          if (widget.student.subject.isNotEmpty)
            GradeSheet(widget.family, widget.student),

          //Mdown(mdx)
        ]))));
  }
}

class HoursSheet2 extends StatefulWidget {
  Student student;
  int grade;

  HoursSheet2(this.student, this.grade);
  //List<TextEditingController>.generate(4,(e)=>TextEditingController(text: "${student.hours[e]}")

  @override
  State<HoursSheet2> createState() => _HoursSheet2State();
}

class _HoursSheet2State extends State<HoursSheet2> {
  late List<TextEditingController> tc;
  @override
  void initState() {
    super.initState();
    tc = List<TextEditingController>.generate(
        4, (e) => TextEditingController(text: "${widget.student.hours[e]}"));

    for (int q = 0; q < 4; q++) {
      var v = q;
      tc[q].addListener(() {
        _set(tc[v].text, v);
      });
    }
  }

  @override
  dispose() {
    for (final o in tc) {
      o.dispose();
    }
    super.dispose();
  }

  _set(String s, int q) {
    setState(() {
      var v = int.tryParse(s) ?? 0;
      widget.student.hours[q] = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    var target = widget.grade < 7 ? 900 : 990;
    var target4 = "${target / 4}";
    var header = List<TableCell>.generate(
      5,
      (e) => TableCell(
          child: Container(
              alignment: Alignment.center,
              child: e == 0 ? Text("=") : Text("Q${e}"))),
    );

    var total = widget.student.hours.reduce((a, b) => a + b);
    var w = List<TableCell>.generate(
        5,
        (e) => e == 0
            ? TableCell(
                child: Container(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Text("$total", style: TextStyle(fontSize: 18)),
                    )))
            : TableCell(
                child: CupertinoTextField(
                  controller: tc[e - 1],
                  textAlign: TextAlign.center,
                  //placeholder: target4,
                  // onSubmitted: (s) => _set(s, e - 1),
                  decoration: BoxDecoration(),
                ),
              ));

    return CupertinoFormSection.insetGrouped(
        header: Text("Hours ($target required)"),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Table(columnWidths: {
              0: FractionColumnWidth(.2),
              1: FractionColumnWidth(.2),
              2: FractionColumnWidth(.2),
              3: FractionColumnWidth(.2),
              4: FractionColumnWidth(.2),
            }, children: [
              TableRow(children: header),
              TableRow(children: w)
            ]),
          )
        ]);
  }
}

class HoursSheet extends StatelessWidget {
  Student student;
  HoursSheet(this.student);

  @override
  Widget build(BuildContext context) {
    var quarters = ["Q1", "Q2", "Q3", "Q4"];

    var w = List<TableRow>.generate(
        4,
        (e) => TableRow(children: [
              CupertinoTextField(
                textAlign: TextAlign.right,
                placeholder: "grade",
                decoration: BoxDecoration(),
              ),
              Text(quarters[e])
            ]));

    return CupertinoFormSection.insetGrouped(header: Text("Hours"), children: [
      Table(columnWidths: {
        0: FixedColumnWidth(80),
      }, children: w)
    ]);
  }
}

class GradeSheet extends StatefulWidget {
  Family family;
  Student student;
  GradeSheet(this.family, this.student);
  @override
  State<GradeSheet> createState() => _GradeSheetState();
}

class _GradeSheetState extends State<GradeSheet> {
  final row = ["one", "two", "three"];
  final col = ["Q1", "Q2", "Q3", "Q4", "➕", "🎯"];
  int quarter = 0;
  List<TextEditingController> tc = [];

  @override
  initState() {
    super.initState();
    tc = List<TextEditingController>.generate(
        widget.student.subject.length, (e) => TextEditingController());
    // _quarter(widget.family.guessQuarter);
  }

  @override
  dispose() {
    for (int i = 0; i < tc.length; i++) {
      tc[i].dispose();
    }
    super.dispose();
  }

  _set(int quarter, int subj, String s) {
    setState(() {
      //widget.student.subject[subj].unit[quarter]?.evaluation = s;
    });
  }

  _quarter(int x) {
    setState(() {
      quarter = x;
      for (int i = 0; i < widget.student.subject.length; i++) {
        // tc[i].text = widget.student.subject[i].unit[quarter]?.evaluation ?? "";
        tc[i].addListener(() {
          _set(quarter, i, tc[i].text);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return CupertinoFormSection.insetGrouped(
        header: Text("Grade book"),
        children: [
          CupertinoFormRow(
              child: ChoicePicker(["Q1", "Q2", "Q3", "Q4"], quarter, _quarter)),
          Table(columnWidths: {
            0: FixedColumnWidth(80),
          }, children: [
            for (final o in []) //  widget.student.subject)
              TableRow(children: [
                CupertinoTextField(
                  controller: tc[i++],
                  textAlign: TextAlign.right,
                  placeholder: "Pass",
                  decoration: BoxDecoration(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                      child: Text(
                        o.rowTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () async {
                        // await showSubject(
                        //     context, widget.family.jurisdiction, o);
                      }),
                )
              ])
          ])
        ]);
  }
}

/*
    return Row(children: [
      Column(children: [
        Text(""),
        for (final o in row) Text(o),
      ]),
      ListView(scrollDirection: Axis.horizontal, children: [
        for (final o in col)
          Column(children: [
            Text(o),
            for (final o in row) Text(o),
          ])
      ])
    ]);
  }*/
