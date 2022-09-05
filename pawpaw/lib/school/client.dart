import 'dart:convert';

import 'package:flutter/services.dart';
import 'plugin/rules.dart';

abstract class HsClient {
  bool teacher = true;
  bool get isTeacher => teacher;
  var assets = Assets();
  var family = Family.empty();

  String get title => "Pawpaw";

  addListener(String familyId, Function(Family id) fn) {}
  removeListener(String familyid) {}
  // their is a problem with this merging steps.

  updateFamily(Family f) {}

  Future<Family> loadCurrent() async {
    try {
      family = await load(0);
    } catch (_) {
      family = Family.empty();
    }

    return family;
  }

  Future<Family> load(int year);
  update();
}

/*
class SembastClient extends HsClient {
  late Database db;
  late StoreRef<String, Map<String, dynamic>> store =
      stringMapStoreFactory.store('pawpaw');

  Future<Family> load(int year) async {
    var f = await store.record('$year').get(db);
    print("load $f");
    return f == null ? Family() : Family.fromJson(f);
  }

  @override
  update() async {
    await db.transaction((txn) async {
      print(family.toJson());
      await store.record('0').put(txn, family.toJson());
    });
  }

  init({bool deleteAll = false}) async {
    ruleManager.rules_["us.ny"] = NyRules();
    if (kIsWeb) {
      if (deleteAll) {
        databaseFactoryWeb.deleteDatabase('pawpaw');
      }
      db = await databaseFactoryWeb.openDatabase('pawpaw');
      html.window.onUnload.listen((event) async {
        update();
      });
    } else {
      final appDir = await getApplicationDocumentsDirectory();
      await appDir.create(recursive: true);
      final databasePath = join(appDir.path, "pawpaw.db");
      if (deleteAll) {
        io.File(databasePath).delete();
      }
      db = await databaseFactoryIo.openDatabase(databasePath);
    }
  }
}
*/

// this needs to be indexed db on the web, but sembast will load the entire file
// so we need a different sembast for the courses vs the

typedef Jkey = String;
typedef CountryKey = String;

/*
  Map<String, Archive> zip_ = {};

  Future<ByteData> zipAsset(String zipfile, String path) async {
    var r = zip_[zipfile];
    if (r==null) {
       var bd = await rootBundle.load(zipfile);
       r = ZipDecoder().decodeBytes(bd.buffer.asUint8List());
    }
    for (final o in r.files) {
      
      if (o.name == path) {
        o.writeContent(output)
      }
      output.close();
    }

    final archive = ZipDirectory().decodeBytes(r);

  }
*/

// for the web zip files are loaded into memory, so we should cache the zip file
// instead of reading it for each piece.
class Assets {
  // not clear how helpful this is to a jurisdiction picker; why not all?
  JurisdictionSet? jurisdiction_;

  Map<Jkey, DistrictSet> district_ = {};
  Map<Jkey, SubjectSet> subject_ = {};
  Map<Jkey, JurisdictionRules> rules_ = {};

  // potentially this loads the binary asset zip, then extracts it locally.
  // this allows the jurisdiction to work offline

  Future<String> stringAsset(String jurisdiction, String name) async {
    var path = "assets/data/$jurisdiction.$name.json";
    return await rootBundle.loadString(path);
  }

  Future<JurisdictionSet> jurisdictions() async {
    jurisdiction_ ??=
        JurisdictionSet.fromJson(await jsonAsset("world", "jurisdiction"));
    return jurisdiction_!;
  }

  Future<Map<String, dynamic>> jsonAsset(
      String jurisdiction, String name) async {
    return jsonDecode(await stringAsset(jurisdiction, name));
  }

  Future<SubjectSet> subjects(Jkey jurisdiction) async {
    var r = subject_[jurisdiction];
    if (r != null) {
      return r;
    }

    var json = await jsonAsset(jurisdiction, 'subject');
    r = SubjectSet.fromJson(json);
    subject_[jurisdiction] = r;
    return r;
  }

  Future<List<District>> districts(Jkey jurisdiction) async {
    var r = district_[jurisdiction];
    if (r != null) {
      return r.district;
    }
    var json = await jsonAsset(jurisdiction, 'district');
    r = DistrictSet.fromJson(json).index();
    district_[jurisdiction] = r;
    return r.district;
  }

  DateTime schoolEnd(String jurisdiction, int schoolYear) {
    return DateTime(2022, 6, 30);
  }

  DateTime schoolBegin(String jurisdiction, int schoolYear) {
    return DateTime(2022, 6, 30);
  }

  // we shouldn't load all the topics until we need them

  Future<String> subjectMarkdown(String jurisdiction, Subject s) async {
    return "";
    /*
    var ss = await subjects(jurisdiction);
    var r = """# ${s.title}

    ${s.description}

    """;
    int i = 1;
    for (final o in s.unit) {
      if (o != null) {
        r = "$r\n\n ## Unit $i\n";
        for (final j in o.topic) {
          r = "$r\n- ${j.title}";
        }
      }
      i++;
    }
    r = "$r\n\n ## See also";
    var links = ss.reference[s.taxonomy];
    if (links != null) {
      for (final o in links) {
        r = "$r\n - [${o.description}](${o.url})  ";
      }
    }

    return r;*/
  }
}

/*
  // jurisdiction ignored for now, placeholder.
  List<Subject> where(String jurisdiction, int grade,
      {List<Property>? property}) {
    return subject
        .where((e) => e.minGrade <= grade && e.maxGrade >= grade)
        .toList();
  }
  */

///
/// A file using Indexed DB
///
/*
class IdbFile {
  static const int _version = 1;
  static const String _dbName = 'files.db';
  static const String _objectStoreName = 'files';
  static const String _propNameFilePath = 'filePath';
  static const String _propNameFileContents = 'contents';

  IdbFile(this._filePath);

  String _filePath;

  Future<Database> _openDb() async {
    final idbFactory = getIdbFactory();
    if (idbFactory == null) {
      throw Exception('getIdbFactory() failed');
    }
    return idbFactory.open(
      _dbName,
      version: _version,
      onUpgradeNeeded: (e) => e.database
          .createObjectStore(_objectStoreName, keyPath: _propNameFilePath),
    );
  }

  Future<bool> exists() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath);
    await txn.completed;
    return object != null;
  }

  Future<Uint8List> readAsBytes() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if (object == null) {
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as Uint8List;
  }

  Future<String> readAsString() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadOnly);
    final store = txn.objectStore(_objectStoreName);
    final object = await store.getObject(_filePath) as Map?;
    await txn.completed;
    if (object == null) {
      throw Exception('file not found: $_filePath');
    }
    return object['contents'] as String;
  }

  Future<void> writeAsBytes(Uint8List contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put({
      _propNameFilePath: _filePath,
      _propNameFileContents: contents
    }); // if the file exists, it will be replaced.
    await txn.completed;
  }

  Future<void> writeAsString(String contents) async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.put({
      _propNameFilePath: _filePath,
      _propNameFileContents: contents
    }); // if the file exists, it will be replaced.
    await txn.completed;
  }

  Future<void> delete() async {
    final db = await _openDb();
    final txn = db.transaction(_objectStoreName, idbModeReadWrite);
    final store = txn.objectStore(_objectStoreName);
    await store.delete(_filePath);
    await txn.completed;
  }
}
*/