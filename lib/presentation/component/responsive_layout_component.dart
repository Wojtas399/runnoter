import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../config/screen_sizes.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  final Widget? tabletBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.desktopBody,
    this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    final ScreenSizes screenSizes = GetIt.I.get<ScreenSizes>();
    final int maxMobileWidth = screenSizes.maxMobileWidth;
    final int maxTabletWidth = screenSizes.maxTabletWidth;
    final double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth <= maxMobileWidth) {
      return mobileBody;
    } else if (screenWidth <= maxTabletWidth) {
      return tabletBody ?? desktopBody;
    } else {
      return desktopBody;
    }
  }
}
