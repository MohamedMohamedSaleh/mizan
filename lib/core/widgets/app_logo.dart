import 'package:flutter/material.dart';

import '../constants/app_assets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  final double? width;
  final double? height;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.mizanLogo,
      width: width,
      height: height,
      fit: fit,
      filterQuality: FilterQuality.high,
    );
  }
}
