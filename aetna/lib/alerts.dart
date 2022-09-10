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

class Alerts extends StatelessWidget {
  const Alerts({super.key});

  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);
    return Search(title: "Alerts", searchChip: []);
  }
}
