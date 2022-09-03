import 'dart:typed_data';

import '../builder/segment.dart';

import 'lexer.dart';
import 'package:stemmer/stemmer.dart';

// each query is an expression tree that can be executed bottom to top
// potentially incrementally.

// does nothing, but maybe someday.
// if if dart does nothing, shared memory can be hacked.
class Mutex {
  lock() {}
  unlock() {}
}

class Bag<T> {
  final mu = Mutex();
  var c = <T>{};

  add(T x) {
    c.add(x);
  }

  Set<T> all() {
    mu.lock();
    var r = c;
    c = {};
    mu.unlock();
    return c;
  }
}

// having this be completely abstract is bad for optimization
// we can have still have special applies that override the calc though.
class Apply {
  int op; // use enumeration of what sort of operation this is like for the optimizer.
  int flags = 0; // pass some things to optimizer or
  Future<void> Function(QueryContext c, Apply me) calc;
  final List<Apply> children;
  final List<Apply> parent = [];
  final mu = Mutex();
  Apply(this.op, this.calc, this.children);
  int dirty = 0;

  Future<void> exec(QueryContext c) async {
    if (0 == c.g.waveCount) {
      c.g.completeWave();
    } else {
      await calc(c, this);
      for (final p in parent) {
        if (0 == --p.dirty) {
          p.exec(c);
        }
      }
    }
  }
}

class QueryContext {
  QueryGraph g;
  QueryContext(this.g);
}

class Snapshot {}

// every observer is defined by a query
// its updated by writing new segments
class Observer {
  QueryGraph graph;
  SegmentDelta delta = SegmentDelta.empty();
  Function() listener = () {};
  Observer(this.graph, this.listener);
}

//
class QueryGraph {
  // flutter listener
  var observer = <Observer>[];
  var snapshot = Snapshot();

  var leaf = <Apply>[];

  var bag = Bag<Apply>();
  bool inExec = false;
  int waveCount = 0;

  Future<SegmentReader> open() async {
    return SegmentReader();
  }

  write(Uint8List data, bool committed) async {
    // packed list of add/remove/delta tuples.
    // should we flip a bit for deletions, or write a tombstone into
    // the newer segment? a bit flip would need to trigger a change in an older segment. what would an overlay do?
    // 1. find two versions of the same tuple
  }

  // this isn't correct we need to feed a delta to the observer to drive
  // animated lists. also, the observer might not have changed at all
  // so we shouldn't call in this situation
  completeWave() {
    inExec = false;
    for (var o in observer) {
      o.listener();
    }
  }

  // recalc batches update transactions.
  recalc(Set<Apply> dirtyLeaf) {
    if (inExec) {
      for (var o in dirtyLeaf) {
        bag.add(o);
      }
    } else {
      inExec = true;
      exec(bag.all());
    }
  }

  // calculates entire graph atomically. You could start calcing again in the leaves
  // before completing the entire wave, but we prefer to collect them and
  // do them in a batch to potentially reduce the work.
  // at the end of a wave, there is one consistent snapshot of the world; so if an observer doesn't declare all their dependencies, they won't see torn updates
  // there is some increase in latency to this, if it matters we may have to reconsider.
  exec(Set<Apply> dirty) {
    final c = QueryContext(this);

    // calculate the dirty count of all parents.
    // we could also schedule here, currently last child starts on parent.
    waveCount = 0;
    List<Apply> stack = [...dirty];
    while (stack.isNotEmpty) {
      var o = stack.removeLast();
      stack = [...stack, ...o.parent];
      o.dirty++;
      waveCount++;
    }

    // start all the dirty leaves. they can start all their parents
    for (var x in dirty) {
      x.exec(c);
    }
  }
}

// searches return [(doc,relevance)]
// searches could be relational expressions themselves.
// should we be thinking of this as a materialized relation (incrementally update results)

class QueryCursor {
  final leaf = <String, Apply>{};

  update() {}
}

// when we update the search index, will we add segments? or will be e tree
// style update of individual terms? It seems like that would be faster. since very few terms will really matter. does this mess with determinism though? Do we need to completely flush the tree to get a deterministic update?

// each community has its own authentication set and snapshot log
// the snapshot log
class Community {}
