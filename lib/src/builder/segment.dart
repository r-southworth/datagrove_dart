// segments are identified by the cid and their offset
// big segments may be split over multiple files
// data.datagrove.com/segment/cid/segmentid
// checkpoint segment id's can simply move in sequence
// the last segment can be flushed/replaced, the others are immutable
//

import 'dart:typed_data';

typedef bstr = Uint8List;

// segment server is constantly spewing out new segments that
// needed to be added to active query screens
// it is also retiring them.
class SegmentServer {}

class SegmentDelta {
  List<SegmentReader> added;
  List<SegmentReader> removed;
  SegmentDelta(this.added, this.removed);

  static empty() {
    return SegmentDelta([], []);
  }
}

// segments are immutable so nothing to listen to.
class Segment {}

class TermRange {
  SegmentReader s;
  bstr from, to;

  TermRange(this.s, this.from, this.to);
}

class SegmentReader {
  Future<TermRange> termRange(bstr fromInclusive, bstr toExclusive) async {
    return TermRange(this, fromInclusive, toExclusive);
  }

  close() {}
}
