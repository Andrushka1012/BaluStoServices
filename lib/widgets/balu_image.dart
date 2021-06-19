import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class BaluImage extends StatelessWidget {
  final String imageUrl;

  BaluImage({
    required this.imageUrl,
    required this.placeholder,
    this.shape = BoxShape.circle
  });

  final Widget placeholder;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    return !kIsWeb
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => placeholder,
            errorWidget: (context, url, error) => placeholder,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: shape,
                image: DecorationImage(
                  image: imageProvider,
                  onError: (e, _) => placeholder,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(imageUrl),
              ),
            ),
          );
  }
}
