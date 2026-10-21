import 'package:flutter/material.dart';

// Imagine din proiect (asset) dacă există, altfel de la adresa din JSON;
// dacă nu se poate încărca niciuna, arată o iconiță.
class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.asset,
    required this.url,
    required this.width,
    required this.height,
    this.fit = BoxFit.cover,
    this.placeholderIcon = Icons.person,
  });

  final String? asset;
  final String? url;
  final double width;
  final double height;
  final BoxFit fit;
  final IconData placeholderIcon;

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      width: width,
      height: height,
      color: const Color(0xFFD9DDE3),
      child: Icon(placeholderIcon, color: Colors.white, size: width * 0.6),
    );

    final asset = this.asset;
    if (asset != null && asset.isNotEmpty) {
      return Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (_, _, _) => placeholder,
      );
    }

    final url = this.url;
    // Image.network nu poate afișa fișiere SVG
    if (url == null || url.isEmpty || url.contains('.svg')) return placeholder;

    return Image.network(
      url,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (_, child, frame, _) => frame == null ? placeholder : child,
      errorBuilder: (_, _, _) => placeholder,
    );
  }
}
