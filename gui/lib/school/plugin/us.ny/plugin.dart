import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../rules.dart';

// we need codes for this
// maybe 3 letter + 3 number codes like college?
// how are going to match this to
var k6 = """Arithmetic\n
Reading\n
Spelling\n
Writing\n
English Language\n
Geography\n
US History\n
Science\n
Health Education\n
Music\n
Visual Arts\n
Physical Education\n"""
    .split("\n");

var m78 = """English\n (two units)
History and Geography\n (two units)
Science\n (two units)
Mathematics\n (two units)
Physical Education\n (on a regular basis)
Health Education\n (on a regular basis)
Art\n (one-half unit)
Music\n (one-half unit)
Practical Arts\n (on a regular basis)
LIbrary Skills\n (on a regular basis)"""
    .split("\n");

var hs = """English\n (four units)
Social Studies\n (four units, which will include one unit American History, one-half unit government, one-half unit economics)
Science\n (two units)
Mathematics\n (two units)
Physical Education\n (two units)
Health Education\n (one-half unit)
Art and/or Music\n (one unit)
Electives\n (three units)"""
    .split("\n");

final DateFormat mmddyyyy = DateFormat('MMM-dd-yyyy');
List<String> assessSelect(Family f) {
  return [
    "Notice of assessment",
    for (final o in f.student)
      if (true)
        """A written narrative format completed by ${f.supervisor[0].firstName}, will serve as the final assessment for ${o.firstLast}, for the 2021-22 school year. """,
    if (false)
      """The EXAM NAME administered by PARENT/GUARDIAN NAME, will serve as the final assessment for STUDENT NAME, for the 2021-22 school year."""
  ];
}

class NyRules extends JurisdictionRules {
  @override
  DgMenu menu(MenuContext context) {
    if (context.family != null) {
      return filing(context.family!);
    } else {
      return DgMenu();
    }
  }

  DgMenu filing(Family f) {
    return DgMenu(children: [
      DgMenuItem(method: "loi", title: "Letter of Intent"),
      DgMenuItem(method: "ihip", title: "Instruction Plan"),
      DgMenuItem(
        method: "q1",
        title: "Quarter 1",
      ),
      DgMenuItem(
        method: "q2",
        title: "Quarter 2",
      ),
      DgMenuItem(
        method: "q3",
        title: "Quarter 3 and Assessment election",
      ),
      DgMenuItem(method: "q4", title: "Quarter 4 and Assessment"),
    ]);
  }

  get today => mmddyyyy.format(DateTime.now());

  // how does our evaluation return recommended purchase of test?
  // markdown link?
  signed() {
    return """\n\n\n\n### Signatures of Parent/Legal Guardian:

      \n\n#### _________________________ Date: $today
      """;
  }

  @override
  String evaluateFamily(Family f) {
    return "";
  }

  @override
  String evaluateStudent(Student s) {
    return mergeStrings([
      if (s.grade == 5 || s.grade == 7 || s.grade >= 9)
        """${s.firstName} is required to take a standardized test this year. [Tap here to purchase](https://www.datagrove.com) the California Achievement Test. It is low cost, online, and untimed. Tests don't expire and ${s.firstName} can take it at any time. [ℹ️](info:test)
        """
      else
        "${s.firstName} is not required to take a standardized test this year"
    ]);
  }

  String? info(String key) {
    return {
      "test": """ what more can I say?""",
    }[key];
  }

  Filing loi(Family f) {
    var date = mmddyyyy.format(DateTime.now());
    Administrator admin = f.district.admin!;
    return Filing().addMd("Letter of intent", [
      """\n\n# Notice of Intent to Commence a Home Instruction Program
      \n\nTo whom it may concern
      \n\n${admin.name}
      \n\n${admin.address1}
      \n\n${admin.city}, ${admin.state} ${admin.zip}
      \n\n\n## Parent/Legal Guardian Information""",
      for (final s in f.supervisor)
        """\n${s.firstName} ${s.lastName}
      \n${s.address} ${s.address2}
      \n${s.city}, ${s.state} ${s.zip}""",
      """\n\nThe following children of compulsory attendance age will be educated at home during
      the ${f.yearText} school year in accordance with Section 100.10 of the Regulations of
      the Commissioner of Education.
      """,
      for (final s in f.student)
        "\n\n - ${s.firstName} ${s.lastName} born ${mmddyyyy.format(s.birth!)}.}",
      signed()
    ]);
  }

  GradeSet gradeset(int grade) {
    return GradeSet();
  }
  // zip the state slots together with the student slots and grades.

  // to fill out the ihip we need the GradeSet.
  // this is awkward because this is a plugin, so this needs to be injected.
  Filing ihip(Family f) {
    var date = mmddyyyy.format(DateTime.now());
    var r = Filing();
    var submissionDates = <String>[];
    for (final student in f.student) {
      GradeSet g = gradeset(student.grade);
      r.addMd(student.firstLast, [
        "\n\n# Individualized Home Instruction Plan (IHIP) ${f.yearText}",
        "\n\n For ${student.firstLast} born ${mmddyyyy.format(student.birth!)}, grade ${student.grade}",
        "\n\n Submitted on $date"
            "\n\n# Supervisors",
        for (final s in f.supervisor)
          """
      \n${s.firstName} ${s.lastName}
      \n${s.address} ${s.address2}
      \n${s.city}, ${s.state}, ${s.zip}
      \n${s.phone} ${s.phone2} ${s.email}
      """,
        ...submissionDates,
        for (final subject in g.slot)
          """\n\n# ${subject.title}
        \n${subject.description}""",
        signed()
      ]);
    }
    return r;
  }

  @override
  Filing file(DgMenuItem mi, Family f) {
    String date = mmddyyyy.format(DateTime.now());
    // currently we are making one attachment for loi, but one per student for everything else.
    if (mi.method == "loi") {
      return loi(f);
    }

    int quarter = 0;
    var r = Filing();
    for (final student in f.student) {
      var gs = gradeset(student.grade);
      var examName = codeLookup(student.testType, codeset("test"));
      List<String> prefix = [];
      switch (mi.method) {
        case 'ihip':
          return ihip(f);
        case 'q1':
          quarter = 1;
          break;
        case 'q2':
          quarter = 1;
          break;
        case 'q3':
          quarter = 3;
          prefix = [
            "\n# Notice of assessment election\n",
            if (examName.isEmpty)
              """A written narrative completed by ${f.supervisor[0].firstName}, will serve as the final assessment for ${student.firstLast}, for the ${f.yearText} school year. """
            else
              """The ${examName} administered by ${f.supervisor[0].firstName}, will serve as the final assessment for ${student.firstName} for the ${f.yearText} school year."""
          ];
          break;
        case 'q4':
          quarter = 4;
          prefix = [
            "\n# Assessment Results\n",
            if (examName.isNotEmpty)
              """ ${student.firstName} completed the ${examName} with a score of ${student.testScore}. """
            else
              """ This is the homeschool written narrative assessment for x for the
               ${f.yearText}. school year. Per 8 CRR-NY 100.10(h)(2)(iii) and following a review of ${student.firstName}’s work, ${student.firstName} has made adequate academic progress. ${student.firstName} has substantially completed the information set forth in his IHIP and this completes ${student.firstName}’s ${f.yearText} school year. """
          ];
          break;
      }
      List<String> mdq(Student s, GradeSlot sl) {
        Subject? o = s.subject[sl.id];
        if (o == null) {
          return [];
        }
        // the new subjects are not evenly mapped to
        List<Topic> ts = o.topicList(quarter);
        String eval = student.getScore(sl.id, quarter);
        return [
          "\n\n# ${o.title}",
          "\n\n Evaluation: $eval",
          for (final t in ts) "\n - ${t.title}"
        ];
      }

      r.addMd(student.firstLast, [
        "\n# Home Schooling Quarterly Report ${quarter} ${f.yearText}\n"
            "\n\n For ${student.firstLast} grade ${student.grade}",
        "\n\n Submitted on $date\n\n",
        "\n\n Hours completed were ${student.hours[quarter - 1]}",
        ...prefix,
        for (final o in gs.slot) ...mdq(student, o),
      ]);
    }
    return r;
  }

  @override
  List<String> codeset(String name) {
    switch (name) {
      case "test":
        return [
          "cat",
          "California Achievement Test",
          "i",
          "Iowa Test of Basic Skills",
          "s",
          "Stanford Achievement Test",
          "t",
          "Terra Nova",
          "m",
          "Metropolitan Achievement Test",
          "r",
          "Regents",
          "sat",
          "SAT",
          "a",
          "Alternative test which has been approved by the State Education Department",
        ];
      default:
        return [];
    }
  }

  List<District> district_ = [];
  @override
  Future<List<District>> district() async {
    return [];
  }
}
