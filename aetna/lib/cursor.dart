// how can we return a list of slivers as a sliver?
// how can we use a virtual scroller?
// how can a webview act as a sliver?
import 'package:flutter/cupertino.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';

class TupleList {}

class ListDelta<T> {
  List<int> insert = [];
  List<int> remove = [];
  List<int> replace = [];
  List<T> data = [];
}

class CursorNotifier<T> extends ChangeNotifier {
  List<T> runway = [];
  int begin = 0, end = 0, anchor = 0;
  update(ListDelta<T> delta) {}

  ListDelta<T> value = ListDelta<T>();
  get length => end - begin;

  CursorNotifier(List<T> init) {
    runway = init;
    end = init.length;
  }
}

class Cursor<T> extends StatefulWidget {
  CursorNotifier<T> value;
  Widget Function(BuildContext context, int index, T value) builder;
  Cursor({required this.value, required this.builder});

  @override
  State<Cursor<T>> createState() => _CursorState<T>();
}

class _CursorState<T> extends State<Cursor<T>> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();

  @override
  initState() {
    super.initState();
    widget.value.addListener(_update);
  }

  _update() {
    var ls = _listKey.currentState;
    for (var i = 0; i < widget.value.value.insert.length; i++) {}
    for (var i = 0; i < widget.value.value.insert.length; i++) {}
  }

  @override
  Widget build(BuildContext context) {
    return SliverAnimatedList(
        key: _listKey,
        initialItemCount: widget.value.length,
        itemBuilder: (BuildContext context, int index, Animation<double> d) {
          return widget.builder(context, index, widget.value.runway[index]);
        });
  }
}
