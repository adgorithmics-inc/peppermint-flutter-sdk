import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peppermint_sdk/src/widgets/loading.dart';

class VImageLoader extends StatelessWidget {
  const VImageLoader({
    Key? key,
    this.boxFit = BoxFit.cover,
    this.url,
    this.file,
    this.asset,
    this.width,
    this.height,
    this.uint8list,
    this.color,
    this.errorText,
    this.loading,
  }) : super(key: key);

  final BoxFit boxFit;
  final String? url;
  final File? file;
  final String? asset;
  final Uint8List? uint8list;
  final double? width;
  final double? height;
  final Color? color;
  final String? errorText;
  final Widget? loading;

  @override
  build(BuildContext context) {
    Image returnImg;
    if (url != null) {
      return CachedNetworkImage(
        imageUrl: url!,
        width: width,
        height: height,
        fit: boxFit,
        placeholder: (context, url) => loading ?? const PeppermintLoading(),
        errorWidget: (context, url, error) => SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Image.asset(
                'assets/images/img_placeholder.png',
                fit: BoxFit.fitHeight,
                width: width,
                height: height,
              ),
              if (errorText != null)
                Center(
                  child: Text(
                    errorText ?? '',
                    style: const TextStyle(
                      color: Color(0xffF00F13),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      );
    } else if (file != null) {
      returnImg = Image.file(file!,
          fit: boxFit, height: height, width: width, color: color);
    } else if (asset != null) {
      returnImg = Image.asset(asset!,
          fit: boxFit, height: height, width: width, color: color);
    } else if (uint8list != null) {
      returnImg = Image.memory(uint8list!,
          fit: boxFit, height: height, width: width, color: color);
    } else {
      return Image.asset(
        'assets/images/img_placeholder.png',
        fit: boxFit,
        height: height,
        width: width,
      );
    }
    return returnImg;
  }
}
