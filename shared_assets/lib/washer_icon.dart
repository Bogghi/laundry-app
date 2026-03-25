import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WasherIcon extends StatelessWidget {
  const WasherIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'lib/assets/washer-icon.svg',
      package: 'shared_assets',
      width: 24,
      height: 24,
    );
  }
}
