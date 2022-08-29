import 'graph.dart';

// this is going to be graph operations

// the graph is going to enlarge whenever new tuples are indexed.
// it's not clear how to do this implicitly and stay incremental, so we just do it explicitly and rebuild the query for each new index that's added
// the observers will attach to a node that merges the results of all the segments.

// addSegment(existingQuery, newSegment), maybe?
// how do we see the queries that it could be added to?

// create
class ScanOptions {
  // ev vectors are in blobs, we need
}

//
applyScan(QueryContext c, Apply me) async {
  // read the EF from the store and push it to the parent
  // if the parent doesn't get enough, it will need to reset the
  // parameters of the child and trigger another wave.
  // this seems complex when a child has more than one parent, and must
  // satisfy the union of their requests. Multiple children could be made
  // but then it would be hard to reuse the work?
}

mergeSegments(QueryContext c) {}
