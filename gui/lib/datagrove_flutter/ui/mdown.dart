import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:markdown/markdown.dart' as md;

class Mdown extends StatelessWidget {
  String data;
  Function(String)? info;
  Mdown(this.data, {this.info});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24),
        child: Row(children: [
          Expanded(
              child: MarkdownBody(
                  selectable: true,
                  onTapLink: (text, url, title) {
                    if (url!.startsWith("info:") && info != null) {
                      info!(url.substring(5));
                    } else {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    [
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                    ],
                  ),
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                  data: data))
        ]));
  }
}

class MarkdownSliver extends StatelessWidget {
  String data;
  MarkdownSliver(this.data);

  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: Mdown(data));
  }
}
