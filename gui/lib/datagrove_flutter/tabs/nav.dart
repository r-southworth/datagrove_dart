// wrap a navigator around
import 'package:flutter/cupertino.dart';

class NavTab extends StatefulWidget {
  final Icon icon;
  final String label;
  // build the home page of the stack
  //final Widget Function(BuildContext) builder;
  final Widget child;
  UniqueKey key;

  @override
  State<NavTab> createState() => _NavTabState();

  NavTab(
      {required this.icon,
      required this.label,
      required this.child,
      required this.key})
      : super(key: key);
}

class _NavTabState extends State<NavTab> {
  _NavTabState() {}

  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    //return widget.child;
    return Navigator(onGenerateRoute: (st) {
      return CupertinoPageRoute(builder: (c) => widget.child);
    });
  }
}
