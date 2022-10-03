import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// builder instead of child? that would be a way to get the context to the tool.
class Tool {
  String id;
  String? description;
  // for building the toolpane
  Widget Function(BuildContext)? builder;
  Widget Function(BuildContext)? buildModal;
  Widget icon;
  Function(BuildContext context)? pane;
  Tool({required this.id, this.builder, this.buildModal, required this.icon});
}

class ToolState {
  Tool tool;
  int badge = 0;
  bool selected = false;
  bool modal = false;
  ToolState(this.tool);
}

// intended to be immutable.
class ToolSet {
  List<Tool> tool = [];
  int active = -1; // i
  int bottomCount = 0; // bottom tools are always modal.

  ToolSet({required this.tool, this.active = -1, bottomCount = 0});

  ToolState toolState(int index) {
    return ToolState(tool[index]);
  }

  ToolSet copyWith({int? active}) {
    return ToolSet(tool: tool, active: active ?? this.active, bottomCount: 0);
  }
}

class ToolSetNotifier extends StateNotifier<ToolSet> {
  ToolSetNotifier(ToolSet v) : super(v);

  toggleActive(int x) {
    state = state.copyWith(active: state.active == x ? -1 : x);
    print(state.active);
  }

  setTools(ToolSet s) {
    state = s;
  }
}

var _initialTools = ToolSet(tool: []);
initializeTools(ToolSet v) {
  _initialTools = v;
}

final toolProvider = StateNotifierProvider<ToolSetNotifier, ToolSet>(
    (ref) => ToolSetNotifier(_initialTools));

Override toolOverride(ToolSet v) {
  return toolProvider.overrideWithProvider(
      StateNotifierProvider<ToolSetNotifier, ToolSet>(
          (ref) => ToolSetNotifier(v)));
}
