//
import 'package:flutter/cupertino.dart';

// a text field is like the dom,
// a controller is like EditorView
// EditorState is like AttributedTextValue
class DocumentModel {}

abstract class Plugin {}

class EditorState {
  DocumentModel model;
  EditorState(this.model) {}
}

class EditorTransaction {}

class EditorView {}

class DocumentController extends ChangeNotifier {
  late EditorState _state;
  List<Plugin> plugins;
  Function(EditorTransaction)? dispatchTransaction;

  DocumentController({required this.plugins});

  EditorState get state => _state;
}

class DgTextField extends StatefulWidget {
  // our controller here already has the plugin for collaboration
  // all we need to do is redraw the layout by diffing the old state
  DocumentController controller;

  DgTextField(this.controller);

  @override
  State<DgTextField> createState() => _DgTextFieldState();
}

class _DgTextFieldState extends State<DgTextField> {
  late EditorState state;

  @override
  void initState() {
    state = widget.controller.state;

    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
