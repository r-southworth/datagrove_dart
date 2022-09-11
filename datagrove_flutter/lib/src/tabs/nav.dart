// wrap a navigator around
import 'package:flutter/cupertino.dart';

// more like nav buttons? some should have a navigator other nah?
// but maybe we are down to one navigator anyway? or maybe two with a global one and nested one?
class NavTab extends StatefulWidget {
  final Widget icon;
  final String label;
  // build the home page of the stack
  //final Widget Function(BuildContext) builder;
  final Widget? child;
  Function(BuildContext context)? onPressed;

  @override
  State<NavTab> createState() => _NavTabState();

  NavTab({required this.icon, required this.label, this.child, this.onPressed})
      : super(key: ValueKey(label));
}

class _NavTabState extends State<NavTab> {
  _NavTabState() {}

  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //return widget.child;
    if (widget.child != null)
      return Navigator(onGenerateRoute: (st) {
        return CupertinoPageRoute(builder: (c) => widget.child!);
      });
    else {
      return Text(
          "This space is unintentionally empty, did you want to define onPressed?");
    }
  }
}
