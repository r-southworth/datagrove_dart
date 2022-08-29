import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:markdown/markdown.dart' as md;
import 'app.dart';

// Filing should be a bottom sheet? we need a style for that.
// basically show some legal stuff
class Filing extends StatelessWidget {
  Family family;
  String letter;
  Filing(this.family, this.letter);

  @override
  Widget build(BuildContext context) {
    final m = Markdown(
      styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
      data: letter,
      extensionSet: md.ExtensionSet(
        md.ExtensionSet.gitHubFlavored.blockSyntaxes,
        [md.EmojiSyntax(), ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes],
      ),
    );

    return SingleScaffold2(
        title: 'File',
        child: SafeArea(
            child: Column(children: [
          Expanded(child: m),
          CupertinoButton(
              child: Text("Send"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ])));
  }

  static show(BuildContext context, Family f) async {
    final letter = await rootBundle.loadString('assets/signform.md');
    Navigator.of(context).push(CupertinoPageRoute(builder: (BuildContext c) {
      return Filing(f, letter);
    }));
  }
}
