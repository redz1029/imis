// ignore_for_file: depend_on_referenced_packages

import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

class UniversalWebView extends StatefulWidget {
  final String url;
  final bool enableInteraction;

  const UniversalWebView({
    super.key,
    required this.url,
    this.enableInteraction = true,
  });

  @override
  State<UniversalWebView> createState() => UniversalWebViewState();
}

class UniversalWebViewState extends State<UniversalWebView> {
  late final String viewType;
  web.HTMLIFrameElement? _iframe;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    viewType = 'iframe-${DateTime.now().microsecondsSinceEpoch}';

    ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
      final iframe =
          web.HTMLIFrameElement()
            ..src = widget.url
            ..style.border = '0'
            ..style.width = '100%'
            ..style.height = '100%'
            ..style.display = 'block'
            ..allow = 'clipboard-read; clipboard-write; fullscreen;'
            ..style.pointerEvents = widget.enableInteraction ? 'auto' : 'none';

      iframe.onLoad.listen((_) {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      });

      _iframe = iframe;
      return iframe;
    });
  }

  @override
  void didUpdateWidget(covariant UniversalWebView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.url != widget.url && _iframe != null) {
      _isLoading = true;
      _iframe!.src = widget.url;
    }

    if (oldWidget.enableInteraction != widget.enableInteraction &&
        _iframe != null) {
      _iframe!.style.pointerEvents = widget.enableInteraction ? 'auto' : 'none';
    }
  }

  void _syncSize(BoxConstraints constraints) {
    if (_iframe == null) return;

    final width = '${constraints.maxWidth}px';
    final height = '${constraints.maxHeight}px';

    if (_iframe!.style.width == width && _iframe!.style.height == height) {
      return;
    }

    _iframe!
      ..style.width = width
      ..style.height = height;
  }

  void onResize() {
    if (!mounted || _iframe == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final size = renderBox.size;

    _iframe!
      ..style.width = '${size.width}px'
      ..style.height = '${size.height}px';
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _syncSize(constraints);
        });

        return Stack(
          fit: StackFit.expand,
          children: [
            HtmlElementView(viewType: viewType, key: ValueKey(viewType)),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }
}
