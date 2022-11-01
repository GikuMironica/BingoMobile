import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebvPage extends StatefulWidget {
  final String initialUrl;
  final String _title;

  WebvPage(this._title, this.initialUrl);

  @override
  _WebvPageState createState() => _WebvPageState();
}

class _WebvPageState extends State<WebvPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return WebView(
      initialUrl: widget.initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      /*appBar: AppBar(
        title: Text(widget._title),
        backgroundColor: Colors.pink,
        leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),*/
    );
  }
}
