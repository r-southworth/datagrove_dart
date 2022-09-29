import 'dart:collection';

import 'db.dart';
import 'gridtx.dart';
import './gen/data.pb.dart';

// build up a change to the grid surface
// must
class WebTx {
  var bits = <String, String>{};

  void sendString(String path, String json) {}
}

abstract class Cell {
  GridTx tx;
  List<int> loc = [];
  Cell(this.tx, this.loc);

  Style? style; //

  Queue<CellStep> history = Queue<CellStep>();

  void render(WebTx tx);
  void update(Tx tx, Map<String, dynamic> json);
}

class CellStep {
  List<int> key = []; // one for each dim.

  static CellStep fromMarkdown(String s) {
    return CellStep();
  }
}

// each cell can have its own javascript renderer.

class MarkdownCell extends Cell {
  MarkdownCell(super.tx, super.loc);

  // render sends steps to the js editor.
  @override
  void render(WebTx tx) {
    // TODO: implement render
  }

  void reset(String s) {}

  @override
  void update(Tx tx, Map<String, dynamic> json) {
    // TODO: implement update
  }
}

// something like this should probably be able to extend
class CanvasCell extends Cell {
  CanvasCell(super.tx, super.loc);

  @override
  void render(WebTx tx) {
    // TODO: implement render
  }

  @override
  void update(Tx tx, Map<String, dynamic> json) {
    // TODO: implement update
  }
}
