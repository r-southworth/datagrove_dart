import 'package:flutter/cupertino.dart';

import 'editor.dart';

class EditorListController extends ChangeNotifier {
  int length = 0; // virtual
  List<EditorStep> steps = [];

  Function(List<EditorStep>)? store;
  Future<EditorStep> Function(int i)? load;

  // alternate key,value
  void update(List<EditorStep> steps) {
    notifyListeners();
  }
}

// this is the web version.
class EditorListView extends StatefulWidget {
  EditorListController controller;

  EditorListView(this.controller, {super.key});

  @override
  State<EditorListView> createState() => _EditorListViewState();
}

class _EditorListViewState extends State<EditorListView> {
  @override
  Widget build(BuildContext context) {
    return const HtmlElementView(viewType: "");
  }
}
