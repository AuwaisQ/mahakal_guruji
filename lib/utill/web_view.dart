import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:url_launcher/url_launcher.dart';

class InAppWebViewPage extends StatefulWidget {
  final Uri url;

  const InAppWebViewPage(
      {Key? key,
      required this.url,
      required Future<Null> Function(dynamic u) onOpenExternally})
      : super(key: key);

  @override
  State<InAppWebViewPage> createState() => _InAppWebViewPageState();
}

class _InAppWebViewPageState extends State<InAppWebViewPage> {
  late final WebViewController _controller;
  bool _isLoading = true;
  int _progress = 0;

  @override
  void initState() {
    super.initState();

    // 🔹 Configure Android-specific settings (only needed on Android)
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is AndroidWebViewPlatform) {
      params = const PlatformWebViewControllerCreationParams();
      AndroidWebViewController.enableDebugging(true);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress),
          onPageStarted: (_) => setState(() => _isLoading = true),
          onPageFinished: (_) => setState(() => _isLoading = false),
          onNavigationRequest: (request) {
            // Open external schemes (e.g. tel:, mailto:) in system browser
            if (!request.url.startsWith('http')) {
              launchUrl(Uri.parse(request.url),
                  mode: LaunchMode.externalApplication);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(widget.url);

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.url.host),
        actions: [
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () =>
                launchUrl(widget.url, mode: LaunchMode.externalApplication),
          ),
        ],
        bottom: _isLoading
            ? PreferredSize(
                preferredSize: const Size.fromHeight(3.0),
                child: LinearProgressIndicator(value: _progress / 100.0),
              )
            : null,
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
