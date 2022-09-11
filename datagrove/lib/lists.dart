import 'package:aetna/shared/suggest.dart';

import 'shared.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
//import 'package:webview_flutter/webview_flutter.dart';

import 'shared.dart';
import 'shared/taxonomy.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class Search extends StatefulWidget {
  //String title;
  List<String> searchChip;
  Widget? trailing;
  Search({required this.searchChip, this.trailing});

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
    super.initState();
    return;

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
            for (final o in recentCursor) CupertinoListTile(title: Text(o))
          ]),
        )
      ]),
    );
  }
}

class StartTicket extends StatefulWidget {
  StartTicket();
  @override
  State<StartTicket> createState() => _StartTicketState();
}

class _StartTicketState extends State<StartTicket> {
  late IssueHeader header;
  IssueSchema? schema;
  final to = SuggestionController();
  @override
  initState() {
    super.initState();
    header = IssueHeader(() {
      setState(() {});
    });
    to.addListener(() {
      setState(() {
        schema = ToService.getSchema(to.text);
      });
    });
  }

  @override
  void dispose() {
    to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: ModalNav(
          title: const Text("Add To List"),
          valid: schema != null && schema!.valid(header),
          action: const Text("Add"),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: [
              CupertinoFormSection.insetGrouped(children: [
                CupertinoTextFormFieldRow(
                  autofocus: true,
                  prefix: const Text("To"),
                  controller: to,
                ),
                if (schema != null)
                  for (final f in schema!.children) f.build(context, header)
              ])
            ]),
          ),
        ));
  }
}

class ToService {
  static final contacts = <String, IssueSchema>{
    'claims@aetna.com': aetnaIssueSchema(),
    'support@datagrove.com': IssueSchema(children: [])
  };

  static IssueSchema? getSchema(String id) {
    return id == "claims@aetna.com" ? aetnaIssueSchema() : null;
  }

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(contacts.keys);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

// general json
class IssueHeader {
  var item = <String, dynamic>{};
  Function() update;
  IssueHeader(this.update);
}

abstract class IssueField {
  late IssueSchema schema;
  String key;
  bool required = false;
  IssueField(this.key, {this.required = false});
  Widget build(BuildContext context, IssueHeader header);

  Widget get prefix => Text(schema.t(key));
  String get placeholder => schema.t("$key-ph");

  Widget row(Widget child) {
    return CupertinoFormRow(prefix: Text(schema.t(key)), child: child);
  }

  String? getString(IssueHeader h) {
    return h.item[key] as String?;
  }

  setString(IssueHeader h) {
    return (String s) {
      h.item[key] = s;
      h.update();
    };
  }
}

class IssueText extends IssueField {
  IssueText(super.key, {super.required = false});

  @override
  Widget build(BuildContext context, IssueHeader header) {
    return CupertinoTextFormFieldRow(
      prefix: prefix,
      placeholder: placeholder,
      initialValue: getString(header),
      onChanged: setString(header),
    );
  }
}

class IssueTaxonomy extends IssueField {
  StringTree children;
  IssueTaxonomy(super.key, this.children, {super.required = false});

  @override
  Widget build(BuildContext context, IssueHeader header) {
    var state = getString(header);
    return CupertinoFormRow(
        prefix: prefix,
        child: CupertinoButton(
            onPressed: () async {
              var a = await TaxonomyPicker.pick(context, children);
              if (a != null) {
                setString(header)(a);
              }
            },
            child: Text(state ?? "Tap to pick issue")));
  }
}

String fallbackTranslation(String s, {dynamic options}) => s;

class IssueSchema {
  String Function(String, {dynamic options}) t = fallbackTranslation;

  List<IssueField> children = [];

  bool valid(IssueHeader h) {
    for (final f in children) {
      if (f.required && h.item[f.key] == null) {
        return false;
      }
    }
    return true;
  }

  IssueSchema({required this.children, this.t = fallbackTranslation}) {
    for (var o in children) {
      o.schema = this;
    }
  }
}

IssueSchema aetnaIssueSchema() {
  return IssueSchema(
      t: (String s, {dynamic options}) {
        return {
              "type": "Issue",
              "claimid": "Aetna Claim Id",
              "altid": "Alternate Id",
              "type-ph": "Tap to pick",
              "claimid-ph": "id1, id2, ...",
              "altid-ph": "id1, id2, ...",
            }[s] ??
            "";
      },
      children: [
        IssueTaxonomy("type", StringTree.from(aetnaTypes)!, required: true),
        IssueText("claimid", required: true),
        IssueText("altid")
      ]);
}
