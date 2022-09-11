import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

registerWeb() {}

class WebDiv extends StatefulWidget {
  String html;
  WebDiv(this.html);

  @override
  State<WebDiv> createState() => _WebDivState();
}

class _WebDivState extends State<WebDiv> {
  late html.DivElement div;
  late String viewType;
  static int counter = 0;

  @override
  void initState() {
    super.initState();

    div = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..innerHtml = widget.html;
    viewType = "div-${counter++}";

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (_) {
      return div;
    });
  }

  @override
  Widget build(BuildContext context) {
    return HtmlElementView(viewType: viewType);
  }
}
