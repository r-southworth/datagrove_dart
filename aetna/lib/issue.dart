// if the screen is wide enough, this should display the search as well.
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'issue_new.dart';
import 'shared/search.dart';

class Issues extends StatelessWidget {
  const Issues({super.key});

  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);
    return Search(
        title: dg.identity.name,
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          CupertinoButton(
            onPressed: () async {
              await showCupertinoModalBottomSheet(
                  useRootNavigator: true,
                  isDismissible: true,
                  builder: (BuildContext context) {
                    return StartTicket();
                  },
                  expand: true,
                  context: context);
            },
            child: const Icon(CupertinoIcons.add),
          ),
          // CupertinoButton(
          //   onPressed: () {},
          //   child: const Icon(CupertinoIcons.ellipsis),
          // )
        ]),
        searchChip: [
          "open",
          "issue",
        ]);
  }
}

// url will need to point to the ticket
// the search pane will default to order by date, scrolled to the active ticket.
// so one ticket page that inspects the router for info?
class IssuePage extends StatefulWidget {
  @override
  State<IssuePage> createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    final u = Uri.parse(context.url);
    final t = u.queryParameters["t"] ?? "unspecified";
    final q = u.queryParameters["q"] ?? "";

    // this is mostly going to be a web page, it probably needs a fixed header
    final wide = (MediaQuery.of(context).size.width > 800);
    return Row(children: [
      if (wide) const SizedBox(width: 300, child: SearchPane()),
      Expanded(
        child: CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
                middle: Text("Issue $t"),
                leading: CupertinoButton(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(CupertinoIcons.left_chevron),
                  onPressed: () {
                    context.urlRouter.pop();
                  },
                )),
            child: SafeArea(
                child: Expanded(
                    child: WebView(initialUrl: 'https://www.datagrove.com')))),
      )
    ]);
  }
}
