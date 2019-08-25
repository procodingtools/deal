import 'dart:convert';

import 'package:deal/utils/values.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String title, file;

  const WebviewScreen({Key key, this.title, this.file}) : super(key: key);

  createState() => _WebviewState();
}

class _WebviewState extends State<WebviewScreen>{

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    WebViewController _controller;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}", style: TextStyle(color: Colors.black),),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back,
            color: Values.primaryColor,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          _isLoading ? Center(
          child: CircularProgressIndicator(backgroundColor: Values.primaryColor,),
      ) : Container(),
          WebView(
            initialUrl: "",
            onWebViewCreated: (WebViewController webViewController) {
              _controller = webViewController;
              _loadHtmlFromAssets(_controller);
            },
          ),
        ],
      ),
    );
  }

  _loadHtmlFromAssets(WebViewController _controller) async {
    String fileText = await rootBundle.loadString('assets/${widget.file}');
    _controller.loadUrl( Uri.dataFromString(
        fileText,
        mimeType: 'text/html',
        encoding: Encoding.getByName('utf-8')
    ).toString());
    setState(() {
      _isLoading = false;
    });
  }
}
