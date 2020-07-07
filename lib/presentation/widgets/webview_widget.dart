import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebvPage extends StatelessWidget {
  final String initialUrl;
  final String _title;
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  WebvPage(this._title, this.initialUrl) {
    setStatusBar();
  }

  void setStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light));
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: initialUrl,
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.pink,
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              flutterWebViewPlugin.close();
              flutterWebViewPlugin.dispose();
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
