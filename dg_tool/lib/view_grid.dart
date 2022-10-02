// we need a document tab set.
// eventually we need this to split.
// is there a provider for open documents?
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:split_view/split_view.dart';

final red = (String s) =>
    Text(s, style: const TextStyle(color: CupertinoColors.systemRed));

class Doc {}

class DocView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return red("hello from DocView");
  }
}

class TabList extends StatelessWidget {
  List<DocView> tab = [];

  @override
  Widget build(BuildContext context) {
    return red("TabList");
  }
}

// Display the viewTree.
class ViewGrid extends ConsumerWidget {
  // this is split in irregular chunks.

  ViewGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vt = ref.watch(viewTreeProvider);
    return vt;
  }
}

// vs code uses this for top commands, logo. we should have "get started"
class Wallpaper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return red("wallpaper");
  }
}

class ViewTree extends StatelessWidget {
  double percent = 1.0; // percent of list.
  Axis dir = Axis.vertical;
  // Widget could be a
  List<ViewTree> split = [];
  TabList tabset = TabList(); // leaf
  DocView? doc = DocView();

  Widget build(BuildContext context) {
    if (split.isNotEmpty) {
      return SplitView(
          viewMode: SplitViewMode.Horizontal,
          indicator: SplitIndicator(viewMode: SplitViewMode.Horizontal),
          children: []);
    } else if (tabset.tab.isNotEmpty) {
      return tabset;
    } else if (doc != null) {
      return doc!;
    } else {
      return Wallpaper();
    }
  }
}

class ViewTreeNotifier extends StateNotifier<ViewTree> {
  ViewTreeNotifier(super.state);
}

final viewTreeProvider = StateNotifierProvider<ViewTreeNotifier, ViewTree>(
    (ref) => ViewTreeNotifier(ViewTree()));

class PlatformOptions {
  bool singleView = true;
}

class PlatformOptionsNotifier extends StateNotifier<PlatformOptions> {
  PlatformOptionsNotifier(super.state);
}

final optionsProvider =
    StateNotifierProvider<PlatformOptionsNotifier, PlatformOptions>(
        (ref) => PlatformOptionsNotifier(PlatformOptions()));
