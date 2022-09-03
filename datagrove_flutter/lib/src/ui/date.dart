import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateField extends StatelessWidget {
  DateTime? date;
  Function(DateTime) onChange;

  DateField({required this.date, required this.onChange});
  Widget build(BuildContext context) {
    void _showDialog(Widget child) async {
      await showCupertinoModalPopup<DateTime>(
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
      // now we have a value we can stick in the editor
    }

    final label = date?.year == null
        ? "unknown"
        : '${date?.month}-${date?.day}-${date?.year}';
    return CupertinoButton(
      child: Text(
        label,
      ),
      onPressed: () => _showDialog(CupertinoDatePicker(
        initialDateTime: date,
        mode: CupertinoDatePickerMode.date,
        use24hFormat: true,
        // This is called when the user changes the date.
        onDateTimeChanged: (DateTime newDate) {
          onChange(newDate);
        },
      )),
    );
  }
}
