import 'package:flutter/cupertino.dart';

// this is a simple picker that lets the user pick the student grade k_12
// this should probably be generalized. It's  a cupertino button + dialog

class CodesetPicker extends StatefulWidget {
  int value;
  void Function(int) onChange;
  List<String> label;

  CodesetPicker(
      {required this.value, required this.onChange, required this.label});

  @override
  State<CodesetPicker> createState() => _CodesetPickerState();
}

class _CodesetPickerState extends State<CodesetPicker> {
  int grade = 0;
  //late FixedExtentScrollController sc;
  @override
  initState() {
    super.initState();
    grade = widget.value;
    // sc = FixedExtentScrollController(initialItem: widget.grade);
  }

  _grade(int x) {
    setState(() {
      grade = x;
    });
  }

  @override
  void dispose() {
    //sc.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // WidgetsBinding.instance!.addPostFrameCallback(
    //   /// [ScrollController] now refers to a
    //   /// [ListWheelScrollView] that is already mounted on the screen
    //   (_) => sc?.jumpToItem(grade),
    // );
    void _showDialog(Widget child) {
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

    return CupertinoButton(
        child:
            Text(widget.value == -1 ? "unknown" : widget.label[widget.value]),

        // Display a CupertinoDatePicker in date picker mode.
        onPressed: () => _showDialog(
              CupertinoPicker(
                scrollController:
                    FixedExtentScrollController(initialItem: widget.value),
                itemExtent: 32,
                onSelectedItemChanged: (int value) {
                  _grade(value);
                  widget.onChange(value);
                },
                children: [
                  for (var o in widget.label) Text(o),
                ],
              ),
            ));
  }
}
