import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:math';
import 'package:flutter_app_badger/flutter_app_badger.dart';

// https://developer.apple.com/ios/universal-links/
/*
import 'package:filesystem_picker/filesystem_picker.dart';
Future<String?> pickFolder(
  BuildContext context,
) async {
  //var appDocDir = await getApplicationDocumentsDirectory();
  return FilesystemPicker.open(
    title: 'Save to folder',
    context: context,
    //rootDirectory: appDocDir,
    fsType: FilesystemType.folder,
    pickText: 'Save file to this folder',
    folderIconColor: CupertinoColors.activeBlue,
  );
}

Future<bool> initBadger(int count) async {
  String appBadgeSupported;
  try {
    bool res = await FlutterAppBadger.isAppBadgeSupported();
    if (res) {
      appBadgeSupported = 'Supported';
    } else {
      appBadgeSupported = 'Not supported';
    }
  } on PlatformException {
    appBadgeSupported = 'Failed to get badge support.';
  }

  // // If the widget was removed from the tree while the asynchronous platform
  // // message was in flight, we want to discard the reply rather than calling
  // // setState to update our non-existent appearance.
  // if (!mounted) return;

  // setState(() {
  //   _appBadgeSupported = appBadgeSupported;
  // });

  if (count == 0)
    FlutterAppBadger.removeBadge();
  else
    FlutterAppBadger.updateBadgeCount(count);

  return false;
}

*/