import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
// import 'controller.dart';
// import 'client.dart';
import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import 'chat_theme.dart';

export 'messagetype.dart';
import 'messagetype.dart' as types;

// we could use one message controller for everything?
// we would have to restore scroll state.
class MessageController extends ChangeNotifier {
  List<types.Message> messages = [];
  final user = const types.User(id: '06c33e8b-e835-4736-80f4-63f44b66666c');
  //DgThread channel = DgThread(DgChannel());
  MessageController() {
    load();
  }
  ChatStyle style = ChatStyle();

  //setChannel(DgThread ch) {}

  load() async {
    final response = await rootBundle.loadString('assets/messages.json');
    // this is in order of newest = [0]. there is no right choice for this
    // maybe should be two arrays.
    messages = (jsonDecode(response) as List)
        .map((e) => types.Message.fromJson(e as Map<String, dynamic>))
        .toList();

    notifyListeners();
  }

  // this should be a rich text/form controller
  var textController = TextEditingController();
  FocusNode textFocusNode = FocusNode();
  var files = List<types.MessageFile>.empty();

  send() {
    var message = types.Message(
        author: user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        text: textController.text,
        file: files);
    // this needs to pack up the files and text.
    messages.insert(0, message);
    notifyListeners();
  }

  addFile(XFile f) {
    //files.add(f);
    notifyListeners();
  }

  onAvatarTap(BuildContext context, Message) {}
  onMessageTap(BuildContext context, Message) {}
  onMessageDoubleTap(BuildContext context, Message) {}
  onMessageLongpress(BuildContext context, Message) {}
  onMessageStatusLongPress(BuildContext context, Message) {}
  onMessageStatusTap(BuildContext context, Message) {}
  onMessageVisibilityChanged(message, bool visible) {}

  onBackgroundTap() {}

  sendBasic() {
    /*
          final bytes = await result.readAsBytes();
      final image = await decodeImageFromList(bytes);

      final message = types.ImageMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        height: image.height.toDouble(),
        id: const Uuid().v4(),
        name: result.name,
        size: bytes.length,
        uri: result.path,
        width: image.width.toDouble(),
      );

      _addMessage(message);
    var fm = types.FileMessage(
        author: _user,
        createdAt: DateTime.now().millisecondsSinceEpoch,
        id: const Uuid().v4())
      */
  }
}
