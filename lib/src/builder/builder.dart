// what would a snapshot builder look like? how do we feed it tuples?
// do we reuse any of the postings or start from scratch?

// leaf blocks can be any size up to full size of the file, so 32 bit offsets

// what if the bottom was purely tuples with block above it had every key?
//

// Therefore, the compression utility we ship in our code uses a 16KB sample for
// compressing each 4MB chunk of string data. T

import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import '../platform/platform.dart';

// do we want to put a divider so we can rip through the tables?
// for random we know the table from the key descending to the block
// we can put
class Leafblock {
  // packed according to schema. header[0] is the key, begins with table.
  // we can pack into a single binary string, carefully, sortably
  List<Uint64List> header = [];
  Uint8List string = Uint8List(0);
}

class CompressionSchema {}

class Fs {}

class Db {}
// the compressor is going to need some file-like access,
// it can leave its results in output.
// ls uses 16 bit offsets into string pool, so that would max out at 64k
// each block has its common prefix. suffix doesn't matter here.

// how do we pack row oriented tuples?
// []

// cbor the schema into the header?
// what is the unindexed format? can it be already in tuple form but uncompressed?
abstract class Writer {
  write(Uint8List data);
}

abstract class Reader {
  int read(Uint8List buffer);
}

// this assumes that everything is sorted, which it already should be?
// each l

// at each level of the tree we are building a block
// the block points to the next level beneath it.

class LeafBlock {
  List<int> tupleStart = [];
}

// we can afford a 10MB buffer in ram.
// each tuple is vector of 8 or 16 byte headers.

class Key {
  Uint8List key;
  int offset = 0;
  Key(this.key, this.offset);
}

class IndexBuilder {
  var block = BytesBuilder();
}

class SegmentBuilder {
  SegmentBuilder(this.table, this.dir);
  Dir dir;

  Table table;

  var bufferLeaf = BytesBuilder();

  List<IndexBuilder> stack = [];

  // we don't need to regard the 10MB cutoff point?
  // we can treat as a 2 level array.
  //List<Key> keyIndex = [];

  // if the 64K block will fill up then we need to eject the buffer.
  // this will contribute a key to the level above it.
  addIndex(int level, Uint8List key, int offset) {
    // key blocks are
  }

  // we should be able to build this in one pass
  int leafKeyCount = 0;

  beginTable(Table table) {}

  writeLeaf(Uint8List bytes) {}

  static const int maxLeafBlock = 10 * 1024 * 1024;
  int offset = 0;

  // when are we ever going to use an int key?
  // maybe it should be fixed size bytes.
  addTuple(Uint8List key, Uint8List cbor) {
    if (bufferLeaf.length + 18 + key.length + cbor.length > maxLeafBlock) {
      writeLeaf(bufferLeaf.takeBytes());
      offset += maxLeafBlock;
    }
    final start = bufferLeaf.length + offset;
    // trigger keys added to blocks above.
    bufferLeaf.addVarint(key.length);
    bufferLeaf.addVarint(cbor.length);
    bufferLeaf.add(key);
    bufferLeaf.add(cbor);

    addIndex(0, key, start);
  }

  // when we close out a table we can sort it and build an index on it?
  close() {}
}

extension on BytesBuilder {
  addVarint(int x) {}
}

// why not just cbor this? we get lots of things for free?
// some overhead encoding, how do we compress?

// uint8list  key
class Tuple {
  // headers are 8 bytes. for a string the first byte is
  // 4 byte prefix
  // 3 byte offset or tail
  // 1 byte 0-7 or 8 meaning find length in the tail.
  var h = BytesBuilder();
  var b = BytesBuilder();
  addInt64(int x) {}
  addString(String s) {}
  addReader(Reader r) {}
}

class Schema {
  List<Table> table = [];
}

class Attribute {
  append(BytesBuilder b, dynamic c) {}
}

class Table {
  List<Attribute> attribute = [];
  String name = "";
  // position in log there table tuples start.
  int start = 0;
}

class TypedArray {
  int type = 4;
  dynamic data; // List<T>
}

// row
compressBlock(Leafblock kb) {}

compress(Fs fs) {
  // shoot for 64K interior blocks. Leaves are just one continuous file
  //
}

dumpDb(Db db, Fs fs) {
  // write each table to a file
  // note
}
