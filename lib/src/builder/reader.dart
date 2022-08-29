// every community has a snapshot
// when we join a community we generally will read it's snapshot
// we don't need to join to read a public snapshot.

// can we make all global searches offline searches?
// document lists in ef can be multi-tier; for long lists we may not need to
// read the entire list.

import 'dart:async';
import 'dart:typed_data';
import 'package:tuple/tuple.dart';

typedef Kv = Tuple2<Uint8List, Uint8List>;

// each list will start with partitioning information
// then each partition will have the high bits

// fastfields: termstart (get count from this.)
// always read this?

// in general we are going to push things up the graph, but maybe not for the builder? builder is different though. for this we are trying to feed the query graph. To feed the query graph we want vectors?

class EfPartition {
  // an ef partition.

//   ef = EliasFano([0, 0, 0, 5, 6, 8, 12])
// ef.selection(3) # 5
// ef.rank(6) # 4

}

// we can start each segment a cbor header that we are going to read all of.
// we can put this in its own file .hdr
//

class SegmentHeader {}

class Tuplelist {
  // we might not want to read all the fast fields immediately?
  // if none of the documents intersect we can skip that read.
  // also we can limit the io since fast fields are fixed size.
  //
  List<int> fastFields = [];
  List<int> partitionStart = [];

  Future<EfPartition> read(int index) async {
    return EfPartition();
  }

  Future<EfPartition> readFast(int which, int from, int to) async {
    return EfPartition();
  }
}

class SegmentReader {
  int tuples = 0;

  SegmentReader(this.url);
  String url;

  // we can do range searches on indices, these may be unique or nah

  // Tuples = Lucene stored fields. They each have a unique key.
  Future byKey(Uint8List from, Uint8List to) async {
    //
    return Kv(Uint8List(0), Uint8List(0));
  }

  Stream<Kv> byId(int from, int to) async* {
    //
    yield Kv(Uint8List(0), Uint8List(0));
  }

  Future<Kv> byId1(int from) async {
    //
    return Kv(Uint8List(0), Uint8List(0));
  }

  // these are table.field.term -> {tupleid}
  Stream<Tuplelist> readTermRange(Uint8List from, Uint8List to) async* {}

  // list of fast fields you want? generally want a count per document for relevancy
  //
  Future<Tuplelist> readTerm(Uint8List from) async {
    return Tuplelist();
  }

  static Future<SegmentReader> open(String url) async {
    return SegmentReader(url);
  }
}

// maybe the stream should return complete doclists?
