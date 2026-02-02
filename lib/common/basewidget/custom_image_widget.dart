import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mahakal/utill/images.dart';

class CustomImageWidget extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? placeholder;
  const CustomImageWidget(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.contain,
      this.placeholder = Images.placeholder});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Image.asset(
          placeholder ?? Images.placeholder,
          height: height,
          width: double.infinity,
          fit: BoxFit.fill),
      imageUrl: image,
      fit: fit ?? BoxFit.fill,
      height: height,
      width: width,
      errorWidget: (c, o, s) => Image.asset(placeholder ?? Images.placeholder,
          height: height, width: width, fit: BoxFit.fill),
    );
  }
}
