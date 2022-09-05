import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/widgets.dart' as pw;
import 'widget.dart';
import 'plugin/rules.dart';

import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import 'package:markdown/markdown.dart' as md;

Future<Uint8List> printMd(PdfPageFormat format, String text) async {
  final font = await PdfGoogleFonts.nunitoExtraLight();
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  //final font = await PdfGoogleFonts.nunitoExtraLight();
  pdf.addPage(
    pw.Page(
      pageFormat: format,
      build: (pw.Context context) => pw.Center(
        child: pw.Text(text),
      ),
    ),
  );
  return pdf.save();
}

typedef PrintFn = FutureOr<Uint8List> Function(Family family);

// this needs to be able to display a more general filing that may have multiple
// attachments. could look like an automatically generated email.
// there could be multiple things to send as well, so potentially multiple emails
//
class ParentFile extends StatefulWidget {
  SchoolData family;
  DgMenuItem menuItem;
  Filing filing;
  ParentFile(this.family, this.menuItem, this.filing, {Key? key})
      : super(key: key);

  // this can change the family - should it return it or set it into the
  // store and return a "database changed"? I think the database ultimately
  // has to be a notifier, so changing the store directly seems useful.
  // Is the family itself a notifier? or maybe there is a family box notifier?
  static show(BuildContext context, SchoolData family, DgMenuItem fn) async {
    // here we need to execute the plugin's filing report, then display that
    // for final confirmation
    var rules = await ruleManager.rules(family.jurisdiction);

    var fs = rules.file(fn, family);

    Navigator.of(context).push(CupertinoPageRoute(builder: (_) {
      return ParentFile(family, fn, fs);
    }));
  }

  @override
  State<ParentFile> createState() => _ParentFileState();
}

class _ParentFileState extends State<ParentFile> {
  @override
  Widget build(BuildContext context) {
    var fs1 = widget.filing.children[0]; // only one supported right now.
    // maybe we don't need to preview here? will email allow?

    // concatenate all the markdown
    var text = "";
    for (final a in fs1.attach) {
      text = '$text \n--- ${a.content}';
    }

    // this needs to show the list of filing items, or if there is one just show
    // that one.
    return SingleScaffold2(
        title: widget.menuItem.title,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("To:"),
            ),
            MarkdownBody(
                selectable: true,
                paddingBuilders: <String, MarkdownPaddingBuilder>{
                  'h3': PPaddingBuilder(),
                  'h1': PPaddingBuilder(),
                  'h2': PPaddingBuilder(),
                },
                extensionSet: md.ExtensionSet(
                  md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                  [
                    md.EmojiSyntax(),
                    ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                  ],
                ),
                styleSheetTheme: MarkdownStyleSheetBaseTheme.cupertino,
                data: text)
          ]),
        )
            // first field we should show how many different items will be sent if more than one.
            // for sends, we need x,y, 108 more... (click to show all).
            // for now assume we will send one thing, with multiple attachments.
            ));
  }
}

class PPaddingBuilder extends MarkdownPaddingBuilder {
  @override
  EdgeInsets getPadding() => const EdgeInsets.only(top: 24, bottom: 8);
}

class AttachPreview extends StatelessWidget {
  Attach attach;
  AttachPreview(this.attach);

  @override
  Widget build(BuildContext context) {
    Uint8List content = Uint8List(0);
    return SingleScaffold2(
        title: attach.path,
        child: SafeArea(
            child: PdfPreview(
                canChangeOrientation: false,
                canDebug: false,
                canChangePageFormat: false,
                build: (format) => content)));
  }
}


/*
Future<Uint8List> file(Family f, DgMenuItem mi) async {
  final letter = await rootBundle.loadString('assets/md/${mi.path}');
  var template = mt.Template(letter,
      htmlEscapeValues: false, lenient: true, name: 'template-filename.html');

  var data = f.toJson();
  data["menu"] = mi.params;
  data["date"] = mmddyyyy.format(DateTime.now());
  data["schoolYear"] = "${f.schoolYear}-${f.schoolYear + 1}";
  print(data);
  var output = template.renderString(data);
  print(output);

  return printMd(PdfPageFormat.letter, output);
}
*/