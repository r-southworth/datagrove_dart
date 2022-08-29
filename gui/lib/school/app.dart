import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../datagrove_flutter/ui/codeset.dart';
import 'plugin/rules.dart';
import 'plugin/us.ny/plugin.dart';

export 'style.dart';
export 'platform.dart';
export 'widget.dart';
export 'settingsdlg.dart';
export 'plugin/rules.dart';

const uuid = Uuid();

Widget gradesetPicker(int value, Function(int) onChange) {
  var desc = [
    "Grade K",
    for (final o in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]) "Grade $o"
  ];

  return CodesetPicker(value: value, label: desc, onChange: onChange);
}

final JurisdictionRules plugin = NyRules();
