library dg_prosemirror;

// we have a webview that's full of editors
// each editor has a root, where typically codemirror or prosemirror is mounted
// we need a channel to each .

import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

export 'web/prosemirror.dart';
export 'web/codemirror.dart';
export 'web/editor_list.dart';
export 'web/div.dart';
export 'web/chat.dart';
export 'web/html.dart';
