import 'dart:collection';
import 'dart:typed_data';

import 'db.dart';
import 'cell.dart';
import './gen/data.pb.dart';

// id's are a grow-only set with an active 1d selection.
class Sequence {
  List<Style> style = [];
  int next = 0; // also a version?

  // when applying steps we need to rename these
  int newestLocal = 0;

  int get length => style.length;
}

// assumes the dimension is fixed, but this could be addressed

// the cells here may be a cache for really big spread sheets
class Grid extends DbDoc {
  List<Sequence> dim = [];
  Set<Cell> cell = {};
  Set<Cell> local =
      {}; // these cells will be renamed when the new row or column gets a global id.

  // the localSteps are part off of the offline state.
  Queue<GridStep> localStep = Queue<GridStep>();
  //
  int history = 0;
  Grid(super.db, super.url);

  int get width => dim[0].length;
  int get height => dim[1].length;

  static Grid create(Db db) {
    return Grid(db, db.createId("grid.datagrove.com"));
  }

  void apply(GridStep step) {}

  void addListener(Function() onevent) {}
}

abstract class CellContents {}

// styling steps can apply to ranges, anything else?
enum GridStepOp {
  dim,
  cell,
  style,
}

class GridStep extends DbStep {
  GridStepOp step;
  GridStep(this.step);
}

class SequenceStep {
  List<int> insert = [];
  List<int> remove = [];
  List<int> count = [];
}

class StyleStep {}
