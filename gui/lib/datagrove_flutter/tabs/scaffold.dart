import 'package:flutter/material.dart';
import '../client/datagrove_flutter.dart';

import '../client/identity.dart';
import 'chat.dart';
import 'contact.dart';
import 'nav.dart';
import 'profile.dart';

// this needs a router, and global keys for its delegates
class TabScaffold extends StatefulWidget {
  List<Widget> children;
  Widget? leading;
  Widget title;
  String label; // this is the plural name for your databases, e.g. "Schools"
  List<Widget> trailing;
  TabScaffold(
      {Key? key,
      required this.children,
      this.leading,
      required this.title,
      required this.trailing,
      required this.label})
      : super(key: key) {}

  @override
  State<TabScaffold> createState() => TabScaffoldState();
}

// override each tab, but allow a default?
// the primary thing we need is a database widget that supports add/edit/delete

class TabScaffoldState extends State<TabScaffold> {
  int _selectedIndex = 0;
  late List<NavTab> tab = [];

  initState() {
    super.initState();
    tab = [
      NavTab(
          key: UniqueKey(),
          icon: Icon(Icons.home),
          label: 'Home',
          child: HomeTab(title: widget.title, label: widget.label)),
      NavTab(
          key: UniqueKey(),
          icon: Icon(Icons.chat_bubble),
          label: 'Chat',
          child: ChatTab()),
      NavTab(
          key: UniqueKey(),
          icon: Icon(Icons.contacts),
          label: 'Contacts',
          child: ContactTab()),
      NavTab(
        key: UniqueKey(),
        icon: Icon(Icons.settings),
        label: 'Profile',
        child: ProfileTab(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.of(context).size.width > 700;
    final dg = Dgf.of(context);
    // this needs to change to a different list
    if (dg.unlinked) {
      return OnboardDesktop();
    }

    return Material(
        child: Scaffold(
            bottomNavigationBar: wide
                ? null
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    items: [
                        for (var o in tab)
                          BottomNavigationBarItem(icon: o.icon, label: o.label)
                      ]),
            // we need to keep the navigation rail alive, and fade it out.
            body: Row(children: <Widget>[
              if (wide)
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.selected,
                  destinations: [
                    for (var o in tab)
                      NavigationRailDestination(
                        icon: o.icon,
                        selectedIcon: o.icon,
                        //selectedIcon: o.activeIcon,
                        label: Text(o.label),
                      )
                  ],
                ),
              if (wide) const VerticalDivider(thickness: 1, width: 1),

              // This is the main content.
              Expanded(
                  child: IndexedStack(
                      index: _selectedIndex, children: [for (var o in tab) o]))
            ])));
  }
}

// database > views > pickers
// maintain position
//

abstract class PageStacker {
  push(Widget w);
  pop();
}
