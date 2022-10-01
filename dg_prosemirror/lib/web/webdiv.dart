import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'web.dart';
import 'dart:ui' as ui;

class DivProperties {
  int id = 0;
  String toJson() {
    return "{}";
  }
}

class DivEvent {
  int id = 0;
}

// we need timeline
// we need a way to communicate prosemirror steps
// it's not clear with dragging if we want to round trip to dart.
class DivController {
  final div = List<DivProperties>.filled(10000, DivProperties());
  final dartUpdated = <int>{};
  final webUpdated = <int>{};

  final fromWeb = ChangeNotifier();
  final fromDart = ChangeNotifier();

  updateFromDart(List<DivProperties> prop) {}
  updateFromWeb(List<DivEvent> event) {}

  String jsonToWeb() {
    return "";
  }
}

class DivWeb extends StatefulWidget {
  DivController controller;
  DivWeb({required this.controller});

  @override
  State<DivWeb> createState() => _DivWebState();
}

var text =
    """Parses the HTML fragment and sets it as the contents of this element. This ensures that the generated content follows the sanitization rules specified by the validator or treeSanitizer.

If the default validation behavior is too restrictive then a new NodeValidator should be created, either extending or wrapping a default validator and overriding the validation APIs.""";

class _DivWebState extends State<DivWeb> {
  late html.DivElement div;
  late String viewType;
  static int counter = 0;

  @override
  void initState() {
    super.initState();

    var b = StringBuffer();
    for (int i = 0; i < 2; i++) {
      b.write(
          "<div content-editable style='position: fixed; transform: translate(0px,${i * 32}px)' id='c$i'  >$text</div>");
    }

    div = html.DivElement()
      ..style.width = '100%'
      ..style.height = '100%'
      ..setInnerHtml(b.toString(),
          treeSanitizer: html.NodeTreeSanitizer.trusted);
    viewType = "DivWeb-${counter++}";

    // we should try to set up in javascript so we can

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
