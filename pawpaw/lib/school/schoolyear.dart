import 'package:flutter/cupertino.dart';
import 'package:datagrove_flutter/datagrove_flutter.dart';
import 'schoolform.dart';

// Pick a school year using the year-year convention.
// This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
void _showDialog(BuildContext context, Widget child) {
  showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
            height: 216,
            padding: const EdgeInsets.only(top: 6.0),
            // The Bottom margin is provided to align the popup above the system navigation bar.
            margin: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            // Provide a background color for the popup.
            color: CupertinoColors.systemBackground.resolveFrom(context),
            // Use a SafeArea widget to avoid system overlaps.
            child: SafeArea(
              top: false,
              child: child,
            ),
          ));
}

const double _kItemExtent = 32.0;

class SchoolYear extends StatefulWidget {
  int year;
  Function(int value) onChanged;
  SchoolYear(this.year, this.onChanged);
  @override
  State<SchoolYear> createState() => _SchoolYearState();
}

const _kBase = 2022;

class _SchoolYearState extends State<SchoolYear> {
  int year = _kBase;
  @override
  void initState() {
    super.initState();
    year = widget.year;
  }

  @override
  Widget build(BuildContext context) {
    pick() {
      var yearList = List<Widget>.generate(
          50, (e) => Center(child: Text("${_kBase + e}-${_kBase + 1 + e}")));

      _showDialog(
        context,
        CupertinoPicker(
          scrollController:
              FixedExtentScrollController(initialItem: year - _kBase),
          magnification: 1.22,
          squeeze: 1.2,
          useMagnifier: true,
          itemExtent: _kItemExtent,
          // This is called when selected item is changed.
          onSelectedItemChanged: (int selectedItem) {
            setState(() {
              year = selectedItem + _kBase;
            });
          },
          children: yearList,
        ),
      );
    }

    return CupertinoFormRow(
        prefix: label("Year"),
        child: CupertinoButton(
            onPressed: () => pick(), child: Text("$year-${year + 1}")));
  }
}
