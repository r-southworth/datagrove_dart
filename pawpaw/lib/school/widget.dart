import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'plugin/rules.dart';

final logo = Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(
      "Datagrove",
      style: TextStyle(color: Color(0)),
    ));

class SingleScaffold extends StatelessWidget {
  List<Widget> children = [];
  String title;
  bool back;

  Widget? trailing;
  SingleScaffold(
      {required this.title,
      required this.children,
      this.back = true,
      this.trailing});

  @override
  nav(BuildContext context) {
    return CupertinoSliverNavigationBar(
        leading: back
            ? CupertinoButton(
                child: const Icon(CupertinoIcons.left_chevron),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                })
            : Container(),
        largeTitle: GestureDetector(
          child: Text(title),
        ),
        trailing: trailing);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SafeArea(
            child: CustomScrollView(slivers: [nav(context), ...children])));
  }
}

class SingleScaffold2 extends StatelessWidget {
  Widget child;
  String title;
  Widget? trailing;
  Widget? leading;
  Function()? onClose;

  SingleScaffold2(
      {required this.title,
      required this.child,
      this.trailing,
      this.leading,
      this.onClose});

  @override
  nav(BuildContext context) {
    return CupertinoNavigationBar(
        leading: leading == null
            ? CupertinoButton(
                child: const Icon(CupertinoIcons.left_chevron),
                onPressed: () {
                  if (onClose != null) onClose!();
                  Navigator.of(context).pop();
                })
            : leading,
        middle: Text(title),
        trailing: trailing);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(navigationBar: nav(context), child: child);
  }
}

class TextLink extends StatelessWidget {
  String text;
  Function() onTap;
  TextLink(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(child: Text(text), onPressed: onTap);
  }
}

// probably need a text controller to listen to
// should we give it or get it?
class Search extends StatelessWidget {
  TextEditingController c;
  String placeholder;
  Search(this.c, {this.placeholder = "Search"});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
        child: Padding(
      padding: EdgeInsets.all(8.0),
      child: CupertinoSearchTextField(controller: c, placeholder: placeholder),
    ));
  }
}

class ChoicePicker extends StatelessWidget {
  int value;
  Function(int) onChange;
  List<String> label;
  ChoicePicker(this.label, this.value, this.onChange);

  @override
  Widget build(BuildContext context) {
    int i = 0;

    var m = Map<int, Widget>();
    for (final o in label) {
      m[i++] = Container(
          child: new Text(
        o,
        style: const TextStyle(fontSize: 13, color: CupertinoColors.white),
      ));
    }

    return Row(children: [
      Expanded(
          child: CupertinoSlidingSegmentedControl<int>(
              groupValue: value,
              onValueChanged: (int? i) {
                onChange(i!);
              },
              children: m))
    ]);
  }
}
