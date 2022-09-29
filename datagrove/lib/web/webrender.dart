// this is more like a render object - how do we use that system?
// we can use row 0 as the tombstone row.
import 'package:flutter/cupertino.dart';

import 'db.dart';

typedef WebRenderValue = Viewport2d<Cell>;
typedef WebRenderStep = Viewport2dStep<Cell>;

// we may or may not want to

// rows maybe sized; if they are not then we need to compute based on size of the cells.

// we need a separate way to manage fully 2d like interactive viewer
// but these might also be embedded in a document.

abstract class DocStep {
  String toJson();
}

// the data model is that we have a grid of Prosemirror documents
// the reason for the grid is to allow efficiently instantiating documents that
// don't need to be completely in memory.

class WebRender extends ChangeNotifier {
  List<JsEvent> event = []; // listeners can see the most recent event.
  Axis axis = Axis.vertical;
  late DivChannel channel;
  Map<String, StepHistory> cell = {};
  WebRenderValue target = WebRenderValue(), view = WebRenderValue();
  bool updating = false;

  WebRender() {
    channel = DivChannel(onMessage: (String s) {
      List<JsEvent> ev = [];
      fromJs(ev);
    });
  }

  // when
  set value(Viewport2d<Cell> x) {
    // this is where all the work is; diff all the changes into the javascript thread
    target = x;
    if (!updating) {
      _setViewToTarget();
    }
  }

  // generate json diff to update the grid.
  // this will
  void _setViewToTarget() {
    final WebRenderStep diff = target.diff(view);

    // we need to update some wrapper things, but mostly send to javascript
    final json = diff.toJson();
    channel.send(json);
    view = target;
  }

  void _scroll(Offset offset) {}

  // when we get scroll events we need to update the cell list
  void fromJs(List<JsEvent> ev) {
    event = ev;
    for (final o in ev) {
      switch (o.op) {
        case JsOp.sync:
          if (!updating && target.version != view.version) {
            updating = true;
            _setViewToTarget();
          } else {
            updating = false;
          }
          break;
        case JsOp.pointer:
          break;
        case JsOp.scroll:
          _scroll(o.data as Offset);
          break;
        case JsOp.step:
          // TODO: Handle this case.
          break;
      }
    }
    notifyListeners(); // builder needs to watch and create a new view.
  }
}

enum JsOp {
  sync,
  pointer,
  scroll, // could be pointer events? hard I think.
  step, // a javascript editor is requesting a step to a cell.
  selection, // selection can involve more then one cell.
  keyboard, // we could maybe stop these before they reach webview?
}

class TapEvent {}

class JsEvent {
  final JsOp op;
  final dynamic data;
  const JsEvent(this.op, this.data);
}

//
class Viewport2d<T> {
  int version = 0;
  int xLength = 0;
  int yLength = 0;

  int offsetX = 0;
  int offsetY = 0;
  List<T> data = [];

  Viewport2d<T> apply(Viewport2dStep x) {
    // create a new list and copy pointers to it.
    return this;
  }

  Viewport2dStep<T> diff(Viewport2d<T> old) {
    throw "";
  }
}

// T itself needs to be diffable so we can
class Viewport2dStep<T> {
  List<int> insert_ = [];
  List<int> remove_ = [];
  List<int> update_ = [];
  List<T> data_ = [];

  void insert(int dim, int after, int count) {}
  void remove(int dim, int start, int count) {}
  void update(int x, int y, T value) {}

  String toJson() {
    return "";
  }
}

class Cell {
  StepHistory history;
  Cell({required this.history});
}

class DivChannel {
  void send(String data) {}
  Function(String data)? onMessage;
  DivChannel({this.onMessage});
}
