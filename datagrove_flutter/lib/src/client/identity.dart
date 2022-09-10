import 'package:cupertino_list_tile/cupertino_list_tile.dart' as lt;
import 'package:flutter/material.dart';

import 'package:convert/convert.dart';
// this is page, do we need an extra class for that?
// this is a special list, it comes from the keychain
import 'package:flutter/cupertino.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';

import 'datagrove_flutter.dart';
import '../ui/mdown.dart';
/*
class AddIdentity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dg = Dgf.of(context);
    final data = "";
    //dg.identity.privateKey.publicKey.toHex();
    return PageScaffold(title: Text('Link Phone'), slivers: [
    
      // SliverMarkdown(
      //     text: introMessage, link: {"new": () {}}),
      SliverQr(data),
      SliverCopyButton(data),
      SliverShareText(data: data, subject: 'link to new device'),
      SliverButton(
        child: Text("Create New Account"),
        onPressed: () {},
      ),
    ]);
  }
}


CupertinoFormRow(
              prefix: label("Common Core"),
              child: CupertinoSwitch(
                onChanged: _common,
                value: common,
              ))
            ButtonSliver(Text("Link Device"), () {}),
            */
//context.go('/settings');

class SliverMarkdown extends StatelessWidget {
  final String text;
  final Map<String, Function()> link;
  const SliverMarkdown({
    Key? key,
    required this.text,
    required this.link,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: MarkdownBody(
          onTapLink: (text, url, title) {
            final o = link[url];
            if (o != null) {
              o();
            }
          },
          data: text),
    ));
  }
}

@immutable
class SliverButton extends StatelessWidget {
  final Widget child;
  final Function() onPressed;
  const SliverButton({Key? key, required this.child, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: CupertinoButton(onPressed: onPressed, child: child));
  }
}

// this needs a online datagrove in order to post an offer link.
// this needs either statefullness to represent the possiblity of being offline
// (in this case linking is not possible). We could potentially offer a
// "paste private key" option; not great to encourage that though.

class SliverCopyButton extends StatelessWidget {
  String text;
  SliverCopyButton(this.text);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: CupertinoButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Copy to clipboard "),
                  Icon(CupertinoIcons.doc_on_clipboard_fill)
                ]),
            onPressed: () async {
              ClipboardData data = ClipboardData(text: text);
              await Clipboard.setData(data);
            }));
  }
}

class SliverShareText extends StatelessWidget {
  String data;
  String subject;
  SliverShareText({required this.data, required this.subject});
  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: CupertinoButton(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [Text("Share "), Icon(CupertinoIcons.share)]),
            onPressed: () async {
              await Share.share(data, subject: subject);
            }));
  }
}
