import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WashOrderIcon extends StatelessWidget {
  final double? width;
  final double? height;

  const WashOrderIcon({
    super.key,
    this.width = 24,
    this.height = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'lib/assets/wash-order-icon.svg',
      package: 'shared_assets',
      width: width,
      height: height,
    );
  }
}
