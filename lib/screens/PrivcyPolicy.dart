import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivcyPolicy extends StatefulWidget {
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<PrivcyPolicy> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.

    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    Widget loadingIndicator = isLoading
        ? new Container(
            child: SpinKitCircle(
              color: Colors.red,
            ),
          )
        : new Container();
    return Stack(
      children: [
        WebView(
          initialUrl: 'https://sites.google.com/view/pricemeapp/%D8%A7%D9%84%D8%B5%D9%81%D8%AD%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9?authuser=0',
          javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (String url) {
            print('Page started loading: $url');
            isLoading = true;
          },
          onPageFinished: (String url) {
            isLoading = false;
            print('Page finished loading: $url');

            setState(() {
              isLoading = false;
            });
          },
          gestureNavigationEnabled: true,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
        ),
        new Align(
          child: loadingIndicator,
          alignment: FractionalOffset.center,
        ),
      ],
    );
  }
}
