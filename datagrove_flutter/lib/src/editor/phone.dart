import 'package:flutter/cupertino.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class Editor extends StatefulWidget {
  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  @override
  Widget build(BuildContext context) {
    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        final int? port = controller.serverPort;
        controller.loadUrl('assets/index.html');
      },
    );
  }
}
