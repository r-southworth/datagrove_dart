import 'dart:collection';

import 'package:aetna/shared/shared.dart';

// everything needs a web representation or how would we view and manipulate it?

class Db {
  final Map<String, StepHistory> history = <String, StepHistory>{};

  final Map<String, Document> view = <String, Document>{};

  // how should we sync with the server so that all our documents stay in sync?
  // can we build them up locally and create a cut time? how does work with local changes though?

  void remoteCommit(Tx tx) {
    Set<String> url = {};
    while (true) {}

    notify(url);
  }

  void notify(Set<String> url) {
    for (final o in url) {
      Document? doc = view[o];
      if (doc != null) {
        // the listeners can obtain the sync time if they care about consistency more than availability
        doc.notifyListeners();
      }
    }
  }

  void localCommmit(Tx tx) {}

  void observe(String key, Function() onchange) {}
}

// documents are materialized views
// documents can have child documents, e.g. the cell in a spreadsheet

abstract class Document extends ChangeNotifier {
  Db db;
  StepHistory history = StepHistory();
  Document({required this.db});
}

class BasicDoc extends Document {
  BasicDoc({required super.db});
}

// A chat doc is a set of documents sorted by time of creation
// each doc can be edited, but stays in order by its creation time
class ChatDoc extends ChangeNotifier {
  int oldest = 0;
  int newest = 0;

  SplayTreeMap<int, Document> cache = SplayTreeMap();

  // If url is already open this should add a listener.
  static ChatDoc? open(Db db, String url, {bool create = false}) {
    return ChatDoc();
  }
}

class PmStep {}

abstract class Tracked {
  int refCount = 0;
  void dispose() {}
}

abstract class Observable {
  int version = 0;
  void observe() {}
}

class StepHistory {
  int version = 0;
  int refCount = 0;

  // when can we trim this? how do we manage concurrency?
  Queue<PmStep> step = Queue<PmStep>();
  PmDoc snapshot = PmDoc();
}

class PmDoc {
  int key = 0;
  void applySteps(List<PmStep> step) {}
}

// target spreadsheet and see if we can get other things as a special case
// can we embed web scrollers into web scrollers?

// each Step history could have listeners? not sure that would help though.
// we could keep pointers and reference count the step history and pin them.

class Tx {}
