import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/services.dart' show LogicalKeyboardKey, rootBundle;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'messagecontroller.dart';

class NewLineIntent extends Intent {
  const NewLineIntent();
}

class SendMessageIntent extends Intent {
  const SendMessageIntent();
}

class ChatInput extends StatefulWidget {
  MessageController controller;
  ChatInput(this.controller, {Key? key}) : super(key: key);
  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool textEmpty = true;

  @override
  void initState() {
    super.initState();
    widget.controller.textController.addListener(onChange);
  }

  @override
  void dispose() {
    widget.controller.textController.removeListener(onChange);
    super.dispose();
  }

  void onChange() {
    final s = widget.controller.textController.value.text;
    setState(() {
      textEmpty = s.isEmpty;
    });
  }

  get ctl => widget.controller.textController;

  void _handleSendPressed() {
    final trimmedText = ctl.text.trim();
    if (trimmedText != '') {
      widget.controller.send();
      ctl.clear();
    }
  }

  void _handleNewLine() {
    final _newValue = '${ctl.text}\n';
    ctl.value = TextEditingValue(
      text: _newValue,
      selection: TextSelection.fromPosition(
        TextPosition(offset: _newValue.length),
      ),
    );
  }

  Widget _input() {
    return Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.enter): const SendMessageIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.alt):
              const NewLineIntent(),
          LogicalKeySet(LogicalKeyboardKey.enter, LogicalKeyboardKey.shift):
              const NewLineIntent(),
        },
        child: Actions(
            actions: {
              SendMessageIntent: CallbackAction<SendMessageIntent>(
                onInvoke: (SendMessageIntent intent) => _handleSendPressed(),
              ),
              NewLineIntent: CallbackAction<NewLineIntent>(
                onInvoke: (NewLineIntent intent) => _handleNewLine(),
              ),
            },
            child: CupertinoTextField(
              minLines: null,
              maxLines: null,
              controller: widget.controller.textController,
              onSubmitted: (String s) {},
              focusNode: widget.controller.textFocusNode,
              suffix: CupertinoButton(
                child: Icon(textEmpty
                    ? CupertinoIcons.mic
                    : CupertinoIcons.upload_circle),
                onPressed: () {
                  widget.controller.send();
                },
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    // probably make this into its own widget.
    // text composer
    return SafeArea(
        child: Column(children: [
      Row(
        children: <Widget>[
          CupertinoButton(
            child: const Icon(CupertinoIcons.plus_circle),
            onPressed: () => {
              // showChannelMenu(
              //     context, widget.browser, widget.controller.channel)
            },
          ),
          Flexible(
            child: Padding(padding: const EdgeInsets.all(8.0), child: _input()),
          ),
          if (textEmpty)
            CupertinoButton(
              child: const Icon(CupertinoIcons.square_on_square),
              // can this clear the messages off the stack?
              // this just picks tabs ()
              onPressed: () => {}, // Picker.show(context),
            ),
        ],
      ),
    ]));
  }
}

// I need to me