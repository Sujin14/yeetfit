import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatelessWidget {
  final WebViewController webViewController;

  const PaymentWebView({super.key, required this.webViewController});

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: webViewController);
  }
}