import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Полноэкранный просмотр картинки из чата с возможностью зума.
class ChatImageViewer extends StatelessWidget {
  const ChatImageViewer({required this.url, super.key});
  final String url;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: InteractiveViewer(
            child: CachedNetworkImage(imageUrl: url),
          ),
        ),
      );
}
