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

import 'shared/cursor.dart';
import 'issue_new.dart';
import 'issue.dart';
import 'shared/search.dart';

// I need a way to merge the datagrove_flutter settings
// the identity section should be the same for all dg apps

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      CupertinoSliverNavigationBar(largeTitle: Text("Settings")),
      SliverToBoxAdapter(child: IdentitySettings())
    ]);
  }
}


// CupertinoFormSection.insetGrouped(children: [if (ScanQrRow.available()) ScanQrRow()])