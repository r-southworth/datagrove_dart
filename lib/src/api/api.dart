import 'dart:typed_data';

//

class Prepare {
  int tag = 0;
  List<String> sql = [];
}

class DidPrepare {
  int tag = 0;
  List<int> handle = [];
}

class StreamQuery {
  int tag = 0;
  int offset = 0;
  int count = 0;
  bool reverse = false;
  bool stream = true;
}

class Search extends StreamQuery {
  String query = "";
}

class Range extends StreamQuery {
  var begin = Uint8List(0);
}

class SqlQuery extends StreamQuery {
  int handle = 0;
}

class StreamReply {
  int tag = 0;
  int snapshot =
      0; // not clear what we can do with this? should it be in a transaction?
  int author = 0;
  var update = <int>[]; // at
  var insert = <int>[]; // insert-before, count
  var remove = <int>[]; // previouslyAt, count

  // first the updates, then the inserts
  // the first byte list of an insert is the referenced snapshot
  List<List<Uint8List>> step = [];
}

class UncomittedUpdate extends StreamReply {
  // if the update is uncommitted, we need to the update count when the step was produced
  List<int> context = [];
}

class Begin {
  int tag = 0;
  bool readOnly = true;
}

class DidBegin {
  int tag = 0;
  int snapshot = 0;
}

// this is not like commiting an ACID transaction; the result can be "maybe" if you are offline
class CommitSteps {
  int tag = 0;
  int newTag = 0;
  int snapshot = 0; // what updates has the committer seen?
  bool allowTransform =
      true; // if step is old and can't be transformed, it's dropped.
  List<Uint8List> insert = [];
  List<Uint8List> remove = []; //
  List<List<Uint8List>> update =
      []; // key, step, step must begin with the step enum int.
}

class Committed {
  int tag = 0;
  String failed = ""; // if it didn't fail, then assume maybe.
}

// Steps need to be transformable, and our engine needs to be customized to support the necessary step type. Steps are stored offline, then applied when reconnect.

// not strictly api, move
class StepRegistry {
  List<Step> step = [];
}

// for now can we only support a replaceAll step?
class Step {}
