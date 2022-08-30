import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../client/datagrove_flutter.dart';

// might need begin, end? can't begin be negative? or 0 be set to 2^52?
// we need to be able to compute the difference between immutable states

class RangeDiff {
  static const up = -1;
  static const down = 1;
  static const same = 0;

  int direction = same;
  List<int> insert = [];
  List<int> delete = [];
  // this might not be enough? do we want to diff each value? maybe ok.
  List<int> updated = [];
}

class RangeUpdate<T> {
  var update = <int>[]; // at
  var insert = <int>[]; // insert-before, count
  var remove = <int>[]; // previouslyAt, count
  List<T> data = [];
}

// what can we do with T?
// we want this to give us deltas, and potentially create them.
// this is not a change notifier because it only allows one listener and it may return a future. if it's a future than no more updates will be sent until it completes.
// T might need to support json or cbor?
class RangeController<T> {
  FutureOr<void> Function(RangeUpdate<T> u) listener = (_) {};

  int get length => end - begin;
  int begin = 0;
  int end = 0;
  // the anchor is where we are focused, it should be between begin and end.
  //
  int beginCache = 0; // endCache is beginCache + data.length
  int anchor = 0;

  List<T?> data = [];
  T? operator [](int i) {
    return (i < beginCache || i >= beginCache + data.length) ? null : data[i];
  }

  dispose() {}
  range(
    Dgf dgf, {
    Uint8List? pkey,
  }) {}
}

// this should be able to display at least a tuple range
// maybe some more general idea.

class RangeBuilder<T> extends StatefulWidget {
  final RangeController<T> controller;
  Widget Function(BuildContext context, T x) builder;
  RangeBuilder({required this.controller, required this.builder});

  @override
  State<RangeBuilder<T>> createState() => _RangeBuilderState<T>();
}

class _RangeBuilderState<T> extends State<RangeBuilder<T>> {
  final key = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    widget.controller.listener = (RangeUpdate<T> diff) {
      // these indices are only relevant to the old list? do they stack?
      for (var o in diff.insert) {
        key.currentState?.insertItem(o);
      }
      for (var o in diff.remove) {
        key.currentState?.removeItem(o, (c, d) {
          // this should use animation d
          var t = widget.controller[o];
          return t != null ? widget.builder(c, t) : Container();
        });
      }
      setState(() {});

      super.initState();
    };
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  Widget _test() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: index % 2 == 0 ? Colors.green : Colors.greenAccent,
              height: 80,
              alignment: Alignment.center,
              child: Text(
                "Item $index",
                style: const TextStyle(fontSize: 30),
              ),
            ),
          );
        },
        // 40 list items
        childCount: 40,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // animated build rebuilds the list when the

    final count = widget.controller.length;
    // if (count == 0) {
    //   return SliverToBoxAdapter(child: Text("Empty"));
    // }
    // this needs its own controller? can we subclass ScrollController?
    // the scroll controller needs to be on CustomScr
    return SliverAnimatedList(
        key: key,
        initialItemCount: count,
        itemBuilder: ((context, i, animation) {
          // can I use controller this way as an array?
          // update is asynchronous, and then the state will change when that completes
          var o = widget.controller[i];
          if (o == null) {
            return const CupertinoActivityIndicator();
          } else {
            return widget.builder(context, o);
          }
        }));
  }
}
