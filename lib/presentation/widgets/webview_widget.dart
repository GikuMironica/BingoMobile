import 'package:flutter/material.dart';
import 'package:hopaut/config/constants.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebvPage extends StatefulWidget {
  final String initialUrl;
  final String _title;

  WebvPage(this._title, this.initialUrl);

  @override
  _WebvPageState createState() => _WebvPageState();
}

class _WebvPageState extends State<WebvPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    flutterWebViewPlugin.close();
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.initialUrl,
      appBar: AppBar(
        title: Text(widget._title),
        backgroundColor: Colors.pink,
        leading: IconButton(
            icon: HATheme.backButton,
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
    );
  }
}
