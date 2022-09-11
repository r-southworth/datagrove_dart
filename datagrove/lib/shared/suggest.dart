// need to move this to datagrove_fullter

import 'package:flutter/cupertino.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

/// Supply an instance of this class to the [TypeAhead.suggestionsBoxController]
/// property to manually control the suggestions box
class SuggestionController extends TextEditingController {
  /*
  SuggestionsBox? _suggestionsBox;
  FocusNode? _effectiveFocusNode;

  /// Opens the suggestions box
  void open() {
    _effectiveFocusNode!.requestFocus();
  }

  /// Closes the suggestions box
  void close() {
    _effectiveFocusNode!.unfocus();
  }

  /// Opens the suggestions box if closed and vice-versa
  void toggle() {
    if (_suggestionsBox!.isOpened) {
      close();
    } else {
      open();
    }
  }

  /// Recalculates the height of the suggestions box
  void resize() {
    _suggestionsBox!.resize();
  }
  */
}

/*
CupertinoTypeAheadFormField(
                  getImmediateSuggestions: true,
                  suggestionsBoxController: _suggestionsBoxController,
                  textFieldConfiguration: CupertinoTextFieldConfiguration(
                    controller: to,
                  ),
                  suggestionsCallback: (pattern) {
                    return Future.delayed(
                      const Duration(seconds: 1),
                      () => ToService.getSuggestions(pattern),
                    );
                  },
                  itemBuilder: (context, String suggestion) {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(suggestion,
                          style: TextStyle(color: Colors.black)),
                    );
                  },
                  onSuggestionSelected: (String suggestion) {
                    to.text = suggestion;
                  },
                  validator: (value) => value!.isEmpty ? '...' : null,
                )*/