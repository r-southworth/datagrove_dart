import '../datagrove_flutter/ui/app.dart';
import '../datagrove_flutter/tabs/home.dart';
import '../datagrove_flutter/tabs/scaffold.dart';
import '../school/school.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

import '../school/school.dart';
import '../datagrove_flutter/client/datagrove_flutter.dart';
import 'store/datagrove_pawpaw.dart';
import 'app.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      trailing: [],
      leading: Container(),
      title: Text("$girl Pawpaw"),
      slivers: [
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: MarkdownBody(onTapLink: (text, url, title) {}, data: settings),
        )),
      ],
    );
  }
}

final settings = '''
''';

Widget settingsButton(BuildContext context) {
  return CupertinoButton(
      onPressed: () {
        SettingsDialog.show(context);
      }, // AddLogEntry1.show(context, widget.family),
      child: Icon(CupertinoIcons.ellipsis_vertical));
}

class SettingsDialog extends StatefulWidget {
  const SettingsDialog({Key? key}) : super(key: key);

  static show(BuildContext context) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return SettingsDialog();
    }));
  }

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

Widget seg(String x) {
  return Text(x);
}

class _SettingsDialogState extends State<SettingsDialog> {
  final brand = "Pawpaw";
  @override
  Widget build(BuildContext context) {
    return SingleScaffold2(
        title: 'Settings',
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Column(children: [
                  CupertinoFormSection
                      .insetGrouped(header: Text("Get help"), children: [
                    listTile(
                      child: label("$brand on Youtube"),
                      trailing: Icon(CupertinoIcons.link),
                      onTap: () =>
                          launchUrl(Uri.https("youtube.com", "/c/datagrove")),
                    ),
                    listTile(
                      child: label("$brand on Twitter"),
                      trailing: Icon(CupertinoIcons.link),
                      onTap: () =>
                          launchUrl(Uri.https("twitter.com", "/datagrove_us")),
                    ),
                    listTile(
                      child: label("$brand on Discord"),
                      onTap: () => MarkdownHelp.show(context, "discord"),
                    ),
                    listTile(
                      child: label("$brand on Signal"),
                      onTap: () => MarkdownHelp.show(context, "signal"),
                    ),
                  ]),
                  if (false)
                    CupertinoFormSection.insetGrouped(
                        header: Text("Obscure settings"),
                        children: [
                          listTile(
                              child: label("Public School"),
                              onTap: () => SchoolActivation.show(context))
                        ]),
                ]))));
  }
}

class SchoolActivation extends StatefulWidget {
  static show(BuildContext context) async {
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return SchoolActivation();
    }));
  }

  @override
  State<SchoolActivation> createState() => _SchoolActivationState();
}

class _SchoolActivationState extends State<SchoolActivation> {
  bool ismulti = false;
  _ismulti(bool x) {
    setState(() {
      ismulti = x;
    });
  }

  int yearOffset = 1;
  _yearoffset(int? x) {
    setState(() {
      yearOffset = x!;
    });
  }

  Widget _offsetPicker() {
    return CupertinoSlidingSegmentedControl(
        groupValue: yearOffset,
        children: {0: seg("21-22"), 1: seg("22-23"), 2: seg("23-24")},
        onValueChanged: _yearoffset);
  }

  @override
  Widget build(BuildContext context) {
    return SingleScaffold2(
        title: 'Public School Settings',
        child: SafeArea(
            child: Column(children: [
          CupertinoFormSection.insetGrouped(header: Text(""), children: [
            CupertinoTextFormFieldRow(
              prefix: label("Key"),
              placeholder: 'Paste school key',
            ),
            CupertinoFormRow(prefix: label("Year"), child: _offsetPicker()),
            CupertinoFormRow(
                prefix: label("Multi-family"),
                child: CupertinoSwitch(value: ismulti, onChanged: _ismulti)),
          ]),
          CupertinoButton(
              child: Text("More info"),
              onPressed: () {
                showAboutDialog(
                    context: context,
                    applicationVersion: '1.0',
                    applicationIcon: Text("📚"),
                    children: []);
              })
        ])));
  }
}

class MarkdownHelp extends StatefulWidget {
  String text;
  MarkdownHelp(this.text);

  static show(BuildContext context, String name) async {
    var text = await rootBundle.loadString("assets/md/${name}.md");
    return Navigator.of(context)
        .push(CupertinoPageRoute(builder: (BuildContext c) {
      return MarkdownHelp(text);
    }));
  }

  @override
  State<MarkdownHelp> createState() => _MarkdownHelpState();
}

class _MarkdownHelpState extends State<MarkdownHelp> {
  @override
  Widget build(BuildContext context) {
    return SingleScaffold2(
        title: 'Help',
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            MarkdownBody(
              onTapLink: (text, url, title) {
                launchUrl(Uri.parse(url!));
              },
              extensionSet: md.ExtensionSet(
                md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                [
                  md.EmojiSyntax(),
                  ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                ],
              ),
              styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
              data: widget.text,
            )
          ]),
        )));
  }
}
