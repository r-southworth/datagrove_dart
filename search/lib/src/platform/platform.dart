import 'dart:io';
import 'dart:typed_data';

// it makes sense to split the files up into 10 mb chunks and then we can
// do parallel uploads, etc.

class Dir {
  writeFile(String path, Uint8List data) {
    File(path).writeAsBytes(data);
  }
}

class OsLog {
  write(Uint8List entry) {}
  fsync() async {}

  trim(int to) {}

  // It should be faster to do call backs because no gc, async overhead?
  recover(int uint64, Function(Uint8List data) foreach) {}
}
