// display a view, maybe editable
import 'dart:typed_data';

import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/cupertino.dart';
import 'package:universal_html/html.dart' hide Text;
import '../client/datagrove_flutter.dart';
import '../ui/menu.dart';
import 'package:provider/provider.dart';

import 'range.dart';

// is the state for this kept alive?
class HomeTab extends StatefulWidget {
  Widget title;
  String label;
  Function()? add;

  HomeTab({required this.title, required this.label, Key? key, this.add})
      : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final controller = RangeController<DirectoryEntry>();
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // pins show on the top/recent page
  @override
  initState() {
    super.initState();
    controller.range(context.read<Dgf>());
  }

  // when the search bar or magnifying clicked we should route to the search
  // page with relevant arguments. How do we feel about the hidden search of apple?
  // the slide up/fade effect is nice instead of a full route slide

  // we need a cursor or table or something here for listing
  @override
  Widget build(BuildContext context) {
    final addMenu = [
      Cmd(label: "Community", then: () async {}),
    ];

    final pageMenu = [
      Cmd(id: "share", label: "Share"),
      Cmd(
          label: "Open in Finder",
          then: () async {
            final d = Dgf.of(context);
            // bool ok = await launchUrl(
            //     Uri.parse("file://${d.localFileServer.localRoot}"));
          })
    ];
    final fileMenu = [
      Cmd(id: "share", label: "Share"),
    ];
    // this would be cheaper as a global?
    FileStyle style = Dgf.of(context).fileStyle;

    return PageScaffold(
        leading: Container(),
        title: widget.title,
        add: () async {
          // we should skip this if there is exactly one thing to create.
          // but we might want to always support folders

          final m = await showCmd(context, addMenu);
          // could create a datum, a stream (of some kind), or a file of some kind
          // depending on the context.
          // this is is creating an object in the namespace of this page.
          // the top namespace
          if (m != null) {
            await m.then!();
          }
        },
        // menu at top of the page.
        menu: () async {
          final m = await showCmd(context, pageMenu);
          if (m != null) {
            await m.then!();
          }
        },
        search: "",
        slivers: [
          RangeBuilder<DirectoryEntry>(
              controller: controller,
              // this is the builder for RangeBuilder's animated list.
              builder: (c, DirectoryEntry d) {
                return lt.CupertinoListTile(
                  leading: style.folder,
                  trailing: CupertinoButton(
                    child: Icon(CupertinoIcons.ellipsis),
                    onPressed: () {},
                  ),
                  title: Text(d.name ?? "untitled"),
                  //subtitle: Text("${d.size??0} bytes"),
                  onTap: () {
                    if (fileMenu != null) {
                      showCmd(context, fileMenu);
                    }
                  },
                  onLongPress: () {},
                );
              })
        ]);
  }
}
