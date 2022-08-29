import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rules.g.dart';

class Family {
  int year = 2022;
  String get yearText => "$year-${year + 1}";
  List<Teacher> supervisor = [];
  List<Student> student = [];
  District district = District();
  String jurisdiction = "";
  bool isNyc = false;
  Map<String, DateTime?>? filedDate = {};
  Administrator admin = Administrator();
  bool districtCustom = false;

  final duedate = <int>[
    DateTime(2022, 11, 1, 1).millisecondsSinceEpoch,
    DateTime(2023, 2, 1, 1).millisecondsSinceEpoch,
    DateTime(2023, 4, 1, 1).millisecondsSinceEpoch,
    DateTime(2023, 6, 1, 1).millisecondsSinceEpoch,
  ];
  Family();

  static empty() {
    return Family();
  }
}

class SchoolData extends Family {
  List<Student> student = [];
  List<Teacher> teacher = [];
  String jurisdiction = "us.ny";
}

final ruleManager = RuleManager();
final DateFormat yyyymmdd = DateFormat('yyyy-MM-dd');
final DateFormat mmddyyyy = DateFormat('MMM-dd-yyyy');
typedef Csv = List<List<dynamic>>;
typedef CsvRow = List<dynamic>;

@JsonSerializable(explicitToJson: true)
class ReferenceLink {
  String taxonomy;
  String description;
  String url;
  ReferenceLink(
      {required this.taxonomy, required this.description, required this.url});

  factory ReferenceLink.fromJson(Map<String, dynamic> json) =>
      _$ReferenceLinkFromJson(json);
  Map<String, dynamic> toJson() => _$ReferenceLinkToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubjectSet {
  late List<Subject> subject = [];
  late Map<String, List<ReferenceLink>> reference = {};
  SubjectSet(
      {List<Subject>? subject, Map<String, List<ReferenceLink>>? reference}) {
    this.subject = subject ?? [];
    this.reference = reference ?? {};
  }

  factory SubjectSet.fromJson(Map<String, dynamic> json) =>
      _$SubjectSetFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectSetToJson(this);
}

// does this need to be abstract? should it be a bag of properties?
class JurisdictionRole {
  static const family = "family";
  static const school = "school";
  static const admin = "admin";
  static const evaluator = "evaluator";

  String id = "family";
}

class MenuContext {
  bool admin;
  bool school;
  bool eval;
  Family? family;

  MenuContext(
      {this.family,
      this.admin = false,
      this.school = false,
      this.eval = false});
}

// maybe instead of list<role>, context we should have
// a menu search with general properties.
//
// List<JurisdictionRole> role, String context

// this can only go so far, a lot of this needs to be custom coded.
// we can have some level of block configurability though.
//@JsonSerializable(explicitToJson: true)
abstract class JurisdictionRules {
  static JurisdictionRules empty() {
    return EmptyRules();
  }

  DgMenu menu(MenuContext context);

  Filing file(DgMenuItem mi, SchoolData f);

  String evaluateFamily(Family f);
  String evaluateStudent(Student s);

  String? info(String key);

  List<String> codeset(String name);

  // we need to supplement this with locally stored
  // should we just load them locally once and let the user edit after that?
  Future<List<District>> district();
}

class EmptyRules extends JurisdictionRules {
  @override
  String evaluateFamily(Family f) => "";
  @override
  String evaluateStudent(Student s) => "";
  @override
  Filing file(DgMenuItem mi, SchoolData f) => Filing();

  @override
  List<String> codeset(String name) => [];

  @override
  String? info(String key) {}

  @override
  DgMenu menu(MenuContext context) {
    return DgMenu();
  }

  @override
  Future<List<District>> district() {
    // TODO: implement district
    throw UnimplementedError();
  }
}

class RuleManager {
  Map<String, JurisdictionRules> rules_ = {};

  Future<JurisdictionRules> rules(String s) async {
    var v = rules_[s];
    return v ?? EmptyRules();
  }
}

// the district will have its own database of students, but does the
// admin need extra info?

@JsonSerializable(explicitToJson: true)
class Student {
  @JsonKey(ignore: true)
  List<Teacher> supervisor = [];

  Teacher get supervisor0 => supervisor[0];
  String id = "";
  String firstName;
  String lastName;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime? birth;
  String testScore;
  String testType;
  String district;
  int grade = -1; // -1 is "don't know"
  List<int> hours = [];
  // key to this is grade.slotid.unit, default is "Pass"
  // adding grade here covers us if they change to another grade and change back
  // it also means that we are accumulating some history for good or bad.
  Map<String, String> slotScore = {};

  // the key here maps to the jurisdiction slot for the grade
  Map<String, Subject> subject = {};

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);

  String get age {
    if (birth == null) return "";
    final years = (DateTime.now().difference(birth!).inDays / 365).floor();
    return "age $years";
  }

  String getScore(String slot, int unit) {
    return slotScore["$grade.$slot.$unit"] ?? "Pass";
  }

  void setScore(String slot, int unit, String score) {
    slotScore["$grade.$slot.$unit"] = score;
  }

  String get lastFirst => "$lastName, $firstName";
  String get statusAsEmoji {
    return "👍";
  }

  bool get valid {
    return lastName.isNotEmpty;
  }

  String get firstLast => "$firstName $lastName";

  Student get summary => this;
  Student(
      {this.id = "",
      this.firstName = "",
      this.lastName = "",
      this.birth,
      this.testScore = "",
      this.testType = "",
      this.grade = -1,
      this.district = "",
      Map<String, String>? slotScore,
      Map<String, Subject>? subject,
      List<int>? hours}) {
    this.hours = hours ?? <int>[0, 0, 0, 0];
    this.subject = subject ?? {};
    this.slotScore = slotScore ?? {};
  }
}

@JsonSerializable(explicitToJson: true)
class Teacher {
  @JsonKey(ignore: true)
  List<Student> student = [];
  String id,
      address,
      address2,
      city,
      state,
      zip,
      lastName,
      firstName,
      phone,
      phone2,
      email,
      country;
  Teacher(
      {this.id = "",
      this.address = "",
      this.city = "",
      this.state = "",
      this.address2 = "",
      this.zip = "",
      this.lastName = "",
      this.firstName = "",
      this.phone = "",
      this.phone2 = "",
      this.email = "",
      this.country = ""});

  Map<String, dynamic> toMap() {
    return {
      "address1": address,
      "address2": address2,
      "city": city,
      "state": state,
      "zip": zip,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "phone2": phone2,
    };
  }

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$SupervisorFromJson(json);
  Map<String, dynamic> toJson() => _$SupervisorToJson(this);

  String get lastFirst => "$lastName  $firstName";

  bool get valid {
    return lastName.isNotEmpty;
  }

  Teacher get summary => this;
  String get firstLast =>
      (firstName.isEmpty ? "Name required" : "$firstName $lastName") +
      (valid ? "" : "❗");

  String get initials => lastName.substring(0, 1) + firstName.substring(0, 1);
}

final _dateFormatter = new DateFormat('M/d/yyyy');
DateTime _fromJson(String date) => _dateFormatter.parse(date);
String _toJson(DateTime? date) =>
    date == null ? "" : _dateFormatter.format(date);

// from the grade we get the subjects
// user switches for optional.
typedef Grade = int;

// jurisdictions by country. do we still need this using sqlite?
@JsonSerializable(explicitToJson: true)
class JurisdictionSet {
  List<String> country;
  Map<String, List<Jurisdiction>>? byCountry;
  JurisdictionSet(this.country, this.byCountry);

  factory JurisdictionSet.fromJson(Map<String, dynamic> json) =>
      _$JurisdictionSetFromJson(json);
  Map<String, dynamic> toJson() => _$JurisdictionSetToJson(this);
}

// first download this file, then have the user pick a jurisdiction
// then download that file
@JsonSerializable(explicitToJson: true)
class Jurisdiction {
  String code;
  String description;

  Jurisdiction(this.code, this.description);

  factory Jurisdiction.fromJson(Map<String, dynamic> json) =>
      _$JurisdictionFromJson(json);
  Map<String, dynamic> toJson() => _$JurisdictionToJson(this);
}

@JsonSerializable(explicitToJson: true)
class DistrictSet {
  List<District> district = [];
  Map<int, Administrator> admin = {};
  DistrictSet(this.district, this.admin);
  factory DistrictSet.fromJson(Map<String, dynamic> json) =>
      _$DistrictSetFromJson(json);
  Map<String, dynamic> toJson() => _$DistrictSetToJson(this);

  DistrictSet index() {
    for (final o in district) {
      o.admin = admin[o.adminNumber];
    }
    return this;
  }
}

@JsonSerializable(explicitToJson: true)
class Administrator {
  int number = 0;
  String name, address1, address2, city, state, zip, firstName, lastName;
  String email, phone, phone2, country;

  Administrator({
    this.name = "",
    this.firstName = "",
    this.lastName = "",
    this.address1 = "",
    this.address2 = "",
    this.city = "",
    this.state = "",
    this.zip = "",
    this.email = "",
    this.phone = "",
    this.phone2 = "",
    this.country = "",
  });

  factory Administrator.fromJson(Map<String, dynamic> json) =>
      _$AdministratorFromJson(json);
  Map<String, dynamic> toJson() => _$AdministratorToJson(this);
}

// a code set is pairs of string [ code, desc, code, desc]
// this is the code lookup
String codeLookup(String code, List<String> s) {
  for (int i = 0; i < s.length; i += 2) {
    if (s[i] == code) return s[i + 1];
  }
  return "";
}

// If I try to serialize this then admin ends up getting copied too many times.
// could districts have more than one administrator?
// is there a general concept of  group {x} student?
//

@JsonSerializable(explicitToJson: true)
class District {
  String id; // this is unique  enforced by plugin or uuid.
  String name;
  // either a number or a administrator, then we can join these in Assets.
  int adminNumber;
  Administrator? admin;
  District({this.id = "", this.name = "", this.adminNumber = 0, this.admin});

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$DistrictToJson(this);
}

// menus are used for filing

@JsonSerializable(explicitToJson: true)
class DgMenu {
  List<DgMenuItem> children = [];
  DgMenu({List<DgMenuItem>? children}) {
    this.children = children ?? [];
  }

  factory DgMenu.fromJson(Map<String, dynamic> json) => _$DgMenuFromJson(json);
  Map<String, dynamic> toJson() => _$DgMenuToJson(this);
}

// Can each menu item return a string?
// Maybe it can return a list of errors + a markdown string
// it could use and enum to give some interpretation as to the string.
// some of these strings may
// cbor? a module itself needs to hydrate itself into something that
// can pass boundaries;  function() => RuleSet( foo(family)=>menu,)

// needs to be serializable so that we can pass isolates
@JsonSerializable(explicitToJson: true)
class DgMenuItem {
  late List<String> assets; //  assets that should go back to the isolate
  String title = ""; // show in the interface
  String method = ""; // this is going to go back to the isolate to execute
  Map<String, dynamic> params = {}; // also going back; method can
  String prereq = ""; // Describe things needed before this can be filed.
  String due = "";
  String lastSentKey =
      ""; // this is could be kept by pawpaw, but would need a unique key that doesn't change. so this could be the lastSet
  String alert =
      ""; // we need to be able to call out menu items that need to be executed.
  String information = ""; // information like "last filed on x"
  String svg = ""; // if provided, makes it prettier. inlineable.

  DgMenuItem(
      {this.method = "",
      this.title = "",
      List<String>? assets,
      Map<String, dynamic>? params}) {
    this.assets = assets ?? [];
    this.params = params ?? {};
  }

  factory DgMenuItem.fromJson(Map<String, dynamic> json) =>
      _$DgMenuItemFromJson(json);
  Map<String, dynamic> toJson() => _$DgMenuItemToJson(this);
}

// assets are effectively the jurisdiction, we need to
// we really need to just return a list of districts.

// rules must be a glob of javascript that when executed provides us
// with a set of functions representing the rule set
//
// each of these menu items

@JsonSerializable(explicitToJson: true)
class Filing {
  List<FilingItem> children = [];

  Teacher?
      family; // filing can change the state of the family. must be modal or
  // we need a diff/merge strategy.
  Filing({List<FilingItem>? children}) {
    this.children = children ?? [];
  }
  // returns a new family state? Can we send a delta instead?
  // or maybe

  factory Filing.fromJson(Map<String, dynamic> json) => _$FilingFromJson(json);
  Map<String, dynamic> toJson() => _$FilingToJson(this);

  Filing addMd(String name, List<String> s) {
    var text = s.reduce((a, b) => a + b);

    if (children.isEmpty) {
      children.add(FilingItem(to: [], attach: []));
    }
    var o = children[0];
    o.attach.add(Attach(path: "$name.md", content: text));
    return this;
  }
}

String mergeStrings(List<String> s) {
  return s.reduce((a, b) => a + b);
}

@JsonSerializable(explicitToJson: true)
class FilingItem {
  List<String> to;
  bool signed;
  List<Attach> attach; // first attach is content.

  FilingItem({required this.to, required this.attach, this.signed = false});

  factory FilingItem.fromJson(Map<String, dynamic> json) =>
      _$FilingItemFromJson(json);
  Map<String, dynamic> toJson() => _$FilingItemToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Attach {
  String path =
      ""; // extension type here can tell us what to do with the content
  dynamic content;
  Attach({required this.path, required this.content});

  factory Attach.fromJson(Map<String, dynamic> json) => _$AttachFromJson(json);
  Map<String, dynamic> toJson() => _$AttachToJson(this);
}

// For one grade, one regulation.
// alt is a list of the subjects that would meet the regulation
@JsonSerializable(explicitToJson: true)
class GradeSlot {
  String id = "";
  String title = "";
  String description = ""; // markdown describing, linking to regulations
  var subject = Subject();
  List<String> hash = [];
  bool require;

  GradeSlot(
      {this.id = "",
      this.description = "",
      this.title = "",
      this.require = true,
      Subject? subject,
      List<String>? hash}) {
    //this.alt = alt ?? [];
    //this.reference = reference ?? {};
    this.subject = subject ?? Subject();
    this.hash = hash ?? [];
  }

  factory GradeSlot.fromJson(Map<String, dynamic> json) =>
      _$GradeSlotFromJson(json);
  Map<String, dynamic> toJson() => _$GradeSlotToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GradeSet {
  List<GradeSlot> slot = [];
  GradeSet({List<GradeSlot>? slot}) {
    this.slot = slot ?? [];
  }

  factory GradeSet.fromJson(Map<String, dynamic> json) =>
      _$GradeSetFromJson(json);
  Map<String, dynamic> toJson() => _$GradeSetToJson(this);
}

/*
// we need to create an expanded family that we can pass to the plugin to compute
// reports. the expanded family has to resolve any assets that the reports may need.
// this is effectively a view that joins the information from the regulations with
// the information from the family
@JsonSerializable(explicitToJson: true)
class ExtendedFamily {
  Family family;
  List<ExtendedStudent> student;

  ExtendedFamily(this.family, this.student);

  factory ExtendedFamily.fromJson(Map<String, dynamic> json) =>
      _$ExtendedFamilyFromJson(json);
  Map<String, dynamic> toJson() => _$ExtendedFamilyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class ExtendedStudent {
  List<Subject> subject;
  factory ExtendedStudent.fromJson(Map<String, dynamic> json) =>
      _$ExtendedSudentFromJson(json);
  Map<String, dynamic> toJson() => _$ExtendedStudentToJson(this);
}
*/
//part 'opt.g.dart';

// each slot must have a plan.
// each slot records a list of validityHashes that have been approved for that slot

// subjects need properties, these will be resolved in a batch though.

// Objective's are the core piece, these are protected by a hash
// a Set is any set of objectives with commutative hash (order insensitive)
// the plan is is a set placed in order together with comments.
// these are not protected by hash to allow editing, copy the plan to protect.
// we copy the plan into the student.slot, it won't change from when the parent
// assigns it. It can be encrypted and the key handed out, or public.
@JsonSerializable(explicitToJson: true)
class Subject {
  String id = "";
  // order is important here. first is overall description.
  // order is not important to computing the validityHash
  // we can have unit descriptions that don't affect acceptance
  // we can have subobjectives that don't affect acceptance.
  // subobjectives are not in the same order as the objectives, although they
  // should be in the same unit, then map to the calendar
  List<Topic> topic = [];
  List<int> start = []; // first topic
  List<PlanStep> steps = [];
  String description = "";
  var minGrade = 0;
  var maxGrade = 12;
  Subject({this.id = "", List<Topic>? topic}) {
    this.topic = topic ?? [];
  }

  String get title {
    return topic.isEmpty ? "" : topic[0].title;
  }

  List<Topic> topicList(int unit) {
    if (unit > 3) {
      unit = 3;
    }
    if (start.isEmpty) {
      start = [0, 0, 0, 0, 0];
      for (int i = 0; i < topic.length; i++) {
        start[1 + (i % 4)]++;
      }
      for (int i = 2; i < 5; i++) {
        start[i] += start[i - 1];
      }
    }
    return topic.sublist(start[unit],
        start[unit + 1]); // this should select just the ones for the unit.
  }

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}

// days here should be relative and fuzzy. teacher will have to manage per
// class or student. these can be relative to the
@JsonSerializable(explicitToJson: true)
class PlanStep {
  // empty id can be a divider, giving a fuzzy schedule
  String objectiveId = "";
  String description = "";
  List<Link> link = [];
  PlanStep({this.objectiveId = "", this.description = ""});

  factory PlanStep.fromJson(Map<String, dynamic> json) =>
      _$PlanStepFromJson(json);
  Map<String, dynamic> toJson() => _$PlanStepToJson(this);
}

@JsonSerializable(explicitToJson: true)
class Topic {
  String id = ""; // these can be used to index
  String title = "";
  String description = ""; // abstract.

  List<SearchTag> tag = [];
  // these are in link database, allows blocking and some shortening
  List<String> link = [];
  Topic({this.id = "", required this.title, this.description = ""});

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
  Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SearchTag {
  String key;
  String value;
  SearchTag(this.key, this.value);

  factory SearchTag.fromJson(Map<String, dynamic> json) =>
      _$SearchTagFromJson(json);
  Map<String, dynamic> toJson() => _$SearchTagToJson(this);
}

// core maps can be special links, we can do a redirect if we don't trust
// the core site.
@JsonSerializable(explicitToJson: true)
class Link {
  //String hash;
  String description;
  String url;
  Link(this.description, this.url);

  factory Link.fromJson(Map<String, dynamic> json) => _$LinkFromJson(json);
  Map<String, dynamic> toJson() => _$LinkToJson(this);
}
