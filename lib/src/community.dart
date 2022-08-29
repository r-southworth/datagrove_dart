// a community is a lsm representation of a relational database
// together with an inverted index of its attributes.

// each 10mb of log causes a new segment to be written.
// isolates or workers are used to merge levels.
// In memory uses a splay tree.
//
import 'dart:typed_data';

import 'dart:collection';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;

typedef Cid = int;
typedef Deviceid = int;

// Communities may be reordered in Sponsor or datagrove level indices
// these are not primary though, since we still need to build
// community specific indices

class DatagroveSnapshot {
  // Read only image from disk
  final community = <Cid, Community>{};

  //
  final uncommitted = <Deviceid, Intent>{};

  // committed but not flushed to disk

  // uncommitted transactions. we mfight know uncommitted transactions from
  // other devices and users not ourselves.
  // we can have two uncommitted transactions for this device; one immutable in flight
  // and one waiting.

  // this will create a consistent update across multiple communities
  DatagroveSnapshot update(List<LogUpdate> upd, List<Intent> d) {
    return this;
  }
}

// intents reduce latency by sending the building state of a transaction
// only the last one sent can be changed, we trim from the front when
// the transaction is received as committed.
class Intent {
  Deviceid id = 0;
  int lsn = 0;
}

//
class LogUpdate {
  final Uint64List cid;
  final Uint64List length;
  LogUpdate(this.cid, this.length);

  static LogUpdate fromBytes(Uint8List data) {
    return LogUpdate(Uint64List(0), Uint64List(0));
  }
}

class Datagrove {
  String ip;
  IOWebSocketChannel? socket;

  recv(s) {}

  Datagrove({this.ip = 'wss://echo.websocket.events', required}) {
    //
  }
  retry() {
    socket = null;
    Future.delayed(const Duration(milliseconds: 500), () {
      tryConnect();
    });
  }

  tryConnect() async {
    if (socket == null) {
      try {
        socket = IOWebSocketChannel.connect(Uri.parse(ip));
        socket?.stream.listen(
          recv,
          onDone: () {
            retry();
          },
          onError: (error) {
            retry();
          },
        );
      } catch (e) {
        retry();
      }
    }
  }

  send(Uint8List data) {
    socket?.sink.add(data);
  }

  close() {
    socket?.sink.close(status.goingAway);
  }

  var dg = DatagroveSnapshot();

  // this is going to
  fromServer(Uint8List data) async {
    // check the validity of the update before writing it to the log
    final log = LogUpdate.fromBytes(data);
    if (log.cid.isNotEmpty) {}
  }

  commit() {
    // we need to flush this to the log.
  }

  // an update is an intent to commit, but these are best effort, may be lost

}

class Community {
  final data = SplayTreeMap<Uint8List, Uint8List>();
}

class Tx {
  // every change updates the dg, not just commit (read your writes)
  Datagrove store;

  Tx(this.store);

  update() {
    // this is going to trigger a datagrove update and all the cursors open on it will potentially be updated as well.
    // if we are online then we want to broadcast this update so that other applications can present appropriate interfaces.
  }
  commit() async {}
}

// cursors can be defined over a set of Communities
// they can be accessed by nth and offer fast length, so can be used
// like an array. The general strategy is to use PAM style join trees, but lazily merge the trees.

// cursors can be defined over a query and incrementally updated.

class Curslet {
  Cid cid;

  Curslet(this.cid);
}

class Tuple {}

class CursorDelta {
  List<Tuple> tuple;
  List<int> inserted;
  List<int> removed;

  CursorDelta(this.tuple, this.inserted, this.removed);
}

class Cursor {
  late int length;
  late final c = <Curslet>[];

  listen(int start, int end, Function(CursorDelta) onChange) async {
    return [];
  }
}

// each community has its own log,
class DatagroveLog {}
