import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgPicture extends StatelessWidget {
  const AppSvgPicture(
      {super.key,
      required this.assetName,
      this.color,
      this.width,
      this.height});

  final String assetName;
  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
    );
  }
}
