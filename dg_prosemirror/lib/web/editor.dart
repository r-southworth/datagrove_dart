// we have a webview that's full of editors
// each editor has a root, where typically codemirror or prosemirror is mounted
// we need a channel to each .

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

abstract class WebInteface {
  void send(Map<String, String> message);
}

// need conditional import
class Webx implements WebInteface {
  Function(Map<String, String>) onMessage;
  Webx(this.onMessage, String assetUrl) {}

  @override
  void send(Map<String, String> message) {}
}

// we need proto or freezed steps that we can send to the js editors.
// we need a wrapper around Editor set that manages the

// we need a standard api that our editor wrappers know, like beginEdit, focus
// we need a widget wrapper

// maybe move to proto?
class EditorStep {
  String key;
  Size? size;
  EditorStep(this.key);
}

class CodemirrorStep extends EditorStep {
  CodemirrorStep(super.key);
}

abstract class EditorContent {}

class EditorChannel {
  EditorContent? content;

  // receive changes from inside
  Function(List<EditorStep> ed)? store;

  // modify the editor from outside.
  Function(EditorStep step) update = badUpdate;
}

void badUpdate(EditorStep step) {
  throw "not ready";
}

class Editor extends StatefulWidget {
  final EditorChannel channel;

  Editor(this.channel, {super.key});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  EditorDiv div = EditorDiv();
  @override
  void initState() {}

  @override
  void dispose() {
    widget.channel.update = badUpdate;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return div.widget;
  }
}

var text =
    """Parses the HTML fragment and sets it as the contents of this element. This ensures that the generated content follows the sanitization rules specified by the validator or treeSanitizer.

If the default validation behavior is too restrictive then a new NodeValidator should be created, either extending or wrapping a default validator and overriding the validation APIs.""";

class EditorDiv {
  late html.DivElement div;
  late String viewType;
  static int counter = 0;

  EditorDiv() {
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

  Widget get widget => HtmlElementView(viewType: viewType);
}
