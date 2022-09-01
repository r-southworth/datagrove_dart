// grid? rows? data table? some kind of cursor driven table.

import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../datagrove_flutter/client/datagrove_flutter.dart';
import '../datagrove_flutter/tabs/home.dart';
import '../datagrove_flutter/tabs/scaffold.dart';
import 'app.dart';
import '../datagrove_flutter/ui/app.dart';

// this will show students joined with primary supervisor
//

class StudentList extends StatefulWidget {
  StudentList();

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  late ListState<Student> student;

  @override
  Widget build(BuildContext context) {
    return PageScaffold(title: null, trailing: [], slivers: [
      student.build()
      // here we want just a single list with no editability.
    ]);
  }

  @override
  initState() {
    super.initState();
    // here we can go get our controllers
    // they will fill with values asynchronously.

    student = ListState(builder:
        (BuildContext context, Student s, Animation<double> animation) {
      return SizeTransition(
          sizeFactor: animation,
          child: lt.CupertinoListTile(
            title: Text("title"),
            subtitle: Text("subtitle"),
            leading: Text(""),
          ));
    });

    @override
    dispose() {
      super.dispose();
    }
  }
}

// we need specialized forms that are more complex than we can build?
// what if we just added custom slivers?

class TableList extends StatefulWidget {
  App app;
  String active;
  TableList(this.app, this.active);
  @override
  State<TableList> createState() => _TableListState();
}

class _TableListState extends State<TableList> {
  late String active;
  // List<Student> student = [];
  List<int> found = [];
  final search = TextEditingController();
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final sc = ScrollController();

  AppTable get table => widget.app.table[active]!;

  @override
  void initState() {
    this.active = widget.active;
    // when does index help us more than pointers?
    //
    super.initState();
    search.addListener(() {
      _filter();
    });
    widget.app.addListener(_update);
    _filter();
  }

  Widget _deleteItem(BuildContext context, Animation<double> d) {
    return Container();
  }

  _update() {
    _listKey.currentState!.insertItem(10);
    _listKey.currentState!.removeItem(5, _deleteItem);
    // if the table
    _filter();
  }

  // filter after _update here; if a remote user adds a tuple
  // that doesn't pass the filter, we won't see it until the filter changes.
  _filter() {
    // filter according to txt
    // use contains?
    setState(() {
      found = table.where(search.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    // there might be invitations that we should show whether empty or not
    // somebody needs to add the students, then that data should be shared
    // with other schools by whoever added it.

    // don't show if there is a menubar, or show anyway?
    final menuButton = CupertinoButton(
        onPressed: () =>
            table.menu(context), // AddLogEntry1.show(context, widget.family),
        child: Icon(CupertinoIcons.ellipsis_circle));

    final addButton = CupertinoButton(
        onPressed: () =>
            {table.add(context)}, // AddLogEntry1.show(context, widget.family),
        child: Icon(CupertinoIcons.add_circled));

    final t = table;
    final body = CupertinoPageScaffold(
        child: CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
        largeTitle: Text(widget.app.label),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          // maybe show new in place of + if we are in import mode
          menuButton,
          addButton
        ]),
      ),
      Search(search, placeholder: "Search ${table.label}"),
      SliverAnimatedList(
          key: _listKey,
          initialItemCount: t.length,
          itemBuilder: (BuildContext context, int x, Animation<double> y) {
            var o = 0;
            return lt.CupertinoListTile(
                title: t.rowTitle.build(t[o]), // Text(o.firstLast),
                subtitle: t.subtitle.build(t[o]),
                leading: t.subtitle.build(t[o]), // Text(o.statusAsEmoji),
                onTap: () async {
                  t.onTap(o);
                });
          }),
      SliverToBoxAdapter(
          child: CupertinoButton(
              child: Text("Add"),
              onPressed: () {
                table.add(context);
              }))
    ]));
    if (widget.app.isMenuBar) {
      return PlatformMenuBar(menus: widget.app.menu, body: body);
    } else {
      return body;
    }
  }
}

/*
    final pick = SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: pickSheet(sheet, (int x) {
        setState(() {
          sheet = x;
        });
      }),
    ));
Widget pickSheet(int selected, Function(int) onChange) {
  final m = <int, Widget>{
    0: Text("Student"),
    1: Text("Report"),
    2: Text("Library")
  };
  return CupertinoSegmentedControl(
      // Provide horizontal padding around the children.
      padding: const EdgeInsets.symmetric(horizontal: 12),
      // This represents a currently selected segmented control.
      groupValue: selected,
      // Callback that sets the selected segmented control.
      onValueChanged: (int x) {
        onChange(x);
      },
      children: m);
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const SliverAnimatedListSample());

class SliverAnimatedListSample extends StatefulWidget {
  const SliverAnimatedListSample({Key? key}) : super(key: key);

  @override
  State<SliverAnimatedListSample> createState() =>
      _SliverAnimatedListSampleState();
}

class _SliverAnimatedListSampleState extends State<SliverAnimatedListSample> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  late ListModel<int> _list;
  int? _selectedItem;
  late int
      _nextItem; // The next item inserted when the user presses the '+' button.

  @override
  void initState() {
    super.initState();
    _list = ListModel<int>(
      listKey: _listKey,
      initialItems: <int>[0, 1, 2],
      removedItemBuilder: _buildRemovedItem,
    );
    _nextItem = 3;
  }

  // Used to build list items that haven't been removed.
  Widget _buildItem(
      BuildContext context, int index, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: _list[index],
      selected: _selectedItem == _list[index],
      onTap: () {
        setState(() {
          _selectedItem = _selectedItem == _list[index] ? null : _list[index];
        });
      },
    );
  }

  // Used to build an item after it has been removed from the list. This
  // method is needed because a removed item remains visible until its
  // animation has completed (even though it's gone as far this ListModel is
  // concerned). The widget will be used by the
  // [AnimatedListState.removeItem] method's
  // [AnimatedListRemovedItemBuilder] parameter.
  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return CardItem(
      animation: animation,
      item: item,
    );
  }

  // Insert the "next item" into the list model.
  void _insert() {
    final int index =
        _selectedItem == null ? _list.length : _list.indexOf(_selectedItem!);
    _list.insert(index, _nextItem++);
  }

  // Remove the selected item from the list model.
  void _remove() {
    if (_selectedItem != null) {
      _list.removeAt(_list.indexOf(_selectedItem!));
      setState(() {
        _selectedItem = null;
      });
    } else {
      _scaffoldMessengerKey.currentState!.showSnackBar(const SnackBar(
        content: Text(
          'Select an item to remove from the list.',
          style: TextStyle(fontSize: 20),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: const Text(
                'SliverAnimatedList',
                style: TextStyle(fontSize: 30),
              ),
              expandedHeight: 60,
              centerTitle: true,
              backgroundColor: Colors.amber[900],
              leading: IconButton(
                icon: const Icon(Icons.add_circle),
                onPressed: _insert,
                tooltip: 'Insert a new item.',
                iconSize: 32,
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: _remove,
                  tooltip: 'Remove the selected item.',
                  iconSize: 32,
                ),
              ],
            ),
            SliverAnimatedList(
              key: _listKey,
              initialItemCount: _list.length,
              itemBuilder: _buildItem,
            ),
          ],
        ),
      ),
    );
  }
}

typedef RemovedItemBuilder = Widget Function(
    int item, BuildContext context, Animation<double> animation);

// Keeps a Dart [List] in sync with an [AnimatedList].
//
// The [insert] and [removeAt] methods apply to both the internal list and
// the animated list that belongs to [listKey].
//
// This class only exposes as much of the Dart List API as is needed by the
// sample app. More list methods are easily added, however methods that
// mutate the list must make the same changes to the animated list in terms
// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    required this.listKey,
    required this.removedItemBuilder,
    Iterable<E>? initialItems,
  }) : _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> listKey;
  final RemovedItemBuilder removedItemBuilder;
  final List<E> _items;

  SliverAnimatedListState get _animatedList => listKey.currentState!;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(index, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}

// Displays its integer item as 'Item N' on a Card whose color is based on
// the item's value.
//
// The card turns gray when [selected] is true. This widget's height
// is based on the [animation] parameter. It varies as the animation value
// transitions from 0.0 to 1.0.
class CardItem extends StatelessWidget {
  const CardItem({
    Key? key,
    this.onTap,
    this.selected = false,
    required this.animation,
    required this.item,
  })  : assert(item >= 0),
        super(key: key);

  final Animation<double> animation;
  final VoidCallback? onTap;
  final int item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2.0,
        right: 2.0,
        top: 2.0,
      ),
      child: SizeTransition(
        sizeFactor: animation,
        child: GestureDetector(
          onTap: onTap,
          child: SizedBox(
            height: 80.0,
            child: Card(
              color: selected
                  ? Colors.black12
                  : Colors.primaries[item % Colors.primaries.length],
              child: Center(
                child: Text(
                  'Item $item',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

*/
