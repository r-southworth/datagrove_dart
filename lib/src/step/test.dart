import 'cell.dart';
import 'db.dart';
import 'grid.dart';
import 'gridtx.dart';

void test() {
  final db = Db();

  // grid is a listener
  final x = Grid.create(db);
  x.addListener(() {
    // when it changes we need to be able to access the grid, but also the most recent delta. The delta might be a local delta or a remote delta?
    // when using web render we need to know if its a local delta or not.
    // prosemirror uses historys and diffs
    print("${x.width}, ${x.height}");
  });

  final dtx = db.begin();
  //final tx = GridTx(dtx, x);

  // tx.insert(0, 0, 10);
  // tx.insert(1, 0, 5);
  // MarkdownCell(tx, [1, 0]).reset("hello, world");
  // dtx.commit();
  // tx.remove(0, 5, 1);
}
