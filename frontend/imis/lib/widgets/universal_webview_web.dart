import 'dart:ui_web' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';

class UniversalWebView extends StatefulWidget {
  final String url;

  const UniversalWebView({super.key, required this.url});

  @override
  State<UniversalWebView> createState() => _UniversalWebViewState();
}

class _UniversalWebViewState extends State<UniversalWebView> {
  late final String viewType;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    viewType = 'iframe-${widget.url.hashCode}';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe =
          html.IFrameElement()
            ..src = widget.url
            ..style.border = '0'
            ..style.width = '100%'
            ..style.height = '100%'
            ..allow = 'clipboard-read; clipboard-write; fullscreen;'
            ..style.overflow = 'hidden';

      iframe.onLoad.listen((event) {
        setState(() => _isLoading = false);
      });

      return iframe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [HtmlElementView(viewType: viewType)]);
  }
}
