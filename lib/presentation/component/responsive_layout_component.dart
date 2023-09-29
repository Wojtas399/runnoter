import 'package:flutter/material.dart';

import '../extension/context_extensions.dart';

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
    if (context.isMobileSize) {
      return mobileBody;
    } else if (context.isTabletSize) {
      return tabletBody ?? desktopBody;
    } else {
      return desktopBody;
    }
  }
}
