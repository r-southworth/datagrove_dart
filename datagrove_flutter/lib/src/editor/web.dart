import 'package:flutter/cupertino.dart';
import "package:webview_flutter_web/webview_flutter_web.dart";
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:html' as html;

void registerWeb() {
  WebView.platform = WebWebViewPlatform();
  usePathUrlStrategy();
}

class Editor extends StatefulWidget {
  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    var host = html.window.location.host;
    return WebView(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        controller.loadUrl('http://$host/assets/assets/index.html');
      },
    );
  }
}
