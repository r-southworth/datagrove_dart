import 'package:flutter/cupertino.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/material.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pull_down_button/pull_down_button.dart';
import 'package:badges/badges.dart';

import 'cursor.dart';
import '../issue_new.dart';
import '../issue.dart';

// we need to add an optional facet pane. this will be used for alerts.

// the first two tabs
class Search extends StatefulWidget {
  String title;
  List<String> searchChip;
  Widget? trailing;
  Search({required this.title, required this.searchChip, this.trailing});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  // what about no choice?
  final selectedChips = [];
  List<Widget> cache = [];
  final recentCursor =
      CursorNotifier<String>(List<String>.generate(100, (e) => "$e"));
  final folderCursor =
      CursorNotifier<String>(List<String>.generate(100, (e) => "${e + 200}"));

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);

    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(
          largeTitle: Text(widget.title), trailing: widget.trailing),
      const SliverToBoxAdapter(
          child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CupertinoSearchTextField(),
      )),
      SliverToBoxAdapter(
          child: Row(children: [
        for (final o in widget.searchChip)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(label: Text(o)),
          )
      ])),
      Cursor<String>(
          value: recentCursor,
          builder: (BuildContext context, int index, String value) {
            return CupertinoListTile(
                title: Text(value),
                onTap: () {
                  // this needs to slide out all the tabs.
                  context.urlRouter.url = "/0/$index";
                });
          })
    ]);
  }
}

class SearchPane extends StatefulWidget {
  const SearchPane({super.key});

  @override
  State<SearchPane> createState() => _SearchPaneState();
}

// the search here may specify groups, which will extend the search engine options
// maybe even add chips?

class _SearchPaneState extends State<SearchPane> {
  final controller = TextEditingController();
  @override
  void initState() {
    controller.addListener(() {});
    final u = Uri.parse(context.url);
    final t = u.queryParameters["t"] ?? "unspecified";
    final q = u.queryParameters["q"] ?? "";

    // might be for a subset of groups
    // merge all the schemas to get a relevant query language.
    final g = u.queryParametersAll["g"];

    controller.text = q;
    _query();
    super.initState();
  }

  _query() async {}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recentCursor = List<String>.generate(100, (e) => "$e");

    return Container(
      color: CupertinoColors.darkBackgroundGray,
      child: Column(children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: CupertinoSearchTextField(
            placeholder: "Search",
          ),
        ),
        Expanded(
          child: ListView(children: [
            for (final o in recentCursor)
              CupertinoListTile(title: Text(o), selected: o == "4")
          ]),
        )
      ]),
    );
  }
}
