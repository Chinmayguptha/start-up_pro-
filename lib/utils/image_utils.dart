import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageUtils {
  static Widget buildNetworkImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => placeholder ?? const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => errorWidget ?? Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: const Icon(
          Icons.image_not_supported,
          color: Colors.grey,
        ),
      ),
    );
  }

  static Widget buildCircularNetworkImage({
    required String imageUrl,
    double? size,
    Widget? placeholder,
    Widget? errorWidget,
  }) {
    return ClipOval(
      child: buildNetworkImage(
        imageUrl: imageUrl,
        width: size,
        height: size,
        placeholder: placeholder,
        errorWidget: errorWidget,
      ),
    );
  }
} 