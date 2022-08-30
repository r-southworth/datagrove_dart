import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/cupertino.dart';

import 'widget.dart';
import 'app.dart';

class Codeset {
  List<String> code = [];
  List<String> value = [];

  Codeset(this.code, this.value);
}

// we should store the entire district, not just the id?
// tradeoffs. can custom ones be uuids perhaps?
// but then we need to load this entire list whenever we need a single district?
// do we need to store a list of the relevant districts, and this copies into that
// district subset?
Widget districtPicker(context, String value, Function(String) setter) {
  Future<Codeset> getCodes() async {
    var d = await plugin.district();
    var id = d.map((District d) => d.id).toList();
    var name = d.map((District d) => d.name).toList();
    return Codeset(id, name);
  }

  return codesetPicker(context, value, setter, getCodes);
}

// this assumes that the name is unique and the id is unique - why have the id then?
// we need this to take a function to get a list, since this may be async?
Widget codesetPicker(context, String value, Function(String) setter,
    Future<Codeset> Function() getCodes) {
  return CupertinoButton(
      onPressed: () async {
        var cs = await getCodes();
        var index = cs.value.indexOf(value);
        var code = index == -1 ? "" : cs.code[index];
        var v = await FullPagePicker.show(context, code, cs);
        setter(v);
      },
      child: Text(value));
}

//
class FullPagePicker extends StatefulWidget {
  String code;
  Codeset cs;
  FullPagePicker(this.code, this.cs);

  static show(BuildContext context, String value, Codeset cs) async {
    return await Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return FullPagePicker(value, cs);
    }));
  }

  @override
  State<FullPagePicker> createState() => _FullPagePickerState();
}

class _FullPagePickerState extends State<FullPagePicker> {
  late List<int> selected;
  late List<int> all;
  final tc = TextEditingController();
  @override
  void initState() {
    super.initState();
    // we could have a check next to the selected one and scroll to that location
    all = List<int>.generate(widget.cs.value.length, (e) => e);
    tc.addListener(_filter);
    _filter();
  }

  @override
  void dispose() {
    tc.dispose();
    super.dispose();
  }

  _filter() {
    setState(() {
      var v = tc.text.toLowerCase();
      selected = v.isEmpty
          ? all
          : all
              .where((e) => widget.cs.value[e].toLowerCase().contains(v))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var x = <Widget>[];
    return CupertinoPageScaffold(
        child: Column(children: [
      Row(children: [
        CupertinoButton(
            child: const Icon(CupertinoIcons.left_chevron),
            onPressed: () => Navigator.of(context).pop(widget.code)),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: CupertinoSearchTextField(
              controller: tc, placeholder: "Search districts"),
        )),
      ]),
      Expanded(
          child: ListView(children: [
        for (var o in selected)
          lt.CupertinoListTile(
            title: Text(widget.cs.value[o]),
            onTap: () {
              Navigator.of(context).pop(widget.cs.code[o]);
            },
          )
      ]))
    ]));
  }
}
