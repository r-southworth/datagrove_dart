import 'package:flutter/cupertino.dart';

class DgTheme {
  //
  final TextStyle logEntryDate;
  final TextStyle logEntryComment;

  DgTheme({required this.logEntryDate, required this.logEntryComment});
}

class DgDarkTheme extends DgTheme {
  DgDarkTheme()
      : super(
            logEntryComment: const TextStyle(fontSize: 14),
            logEntryDate: const TextStyle(
                fontSize: 12, color: CupertinoColors.lightBackgroundGray));
}

var theme = DgDarkTheme();
