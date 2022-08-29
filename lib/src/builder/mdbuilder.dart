import 'dart:io';

import '../platform/platform.dart';
import 'builder.dart';

// should the release be markdown too? maybe this isn't markdown at all?
// but we need search filters to handle most things
// should we await here?

// our markdown file system is .

loadBuilder(SegmentBuilder b, String path) async {
  var o = Directory(path);
  for (var fe in o.listSync()) {
    if (fe is File) {
      //b. fe.path, (fe as File).readAsBytes();
    }
  }
}
