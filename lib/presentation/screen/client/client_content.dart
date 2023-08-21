import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../component/responsive_layout_component.dart';
import '../../config/navigation/router.dart';
import 'client_content_desktop.dart';
import 'client_content_mobile.dart';

class ClientContent extends StatelessWidget {
  const ClientContent({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ClientCalendarRoute(),
        ClientStatsRoute(),
        ClientRacesRoute(),
        ClientBloodTestsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return ResponsiveLayout(
          mobileBody: ClientContentMobile(
            activePageIndex: tabsRouter.activeIndex,
            onPageChanged: tabsRouter.setActiveIndex,
            child: child,
          ),
          desktopBody: ClientContentDesktop(
            activePageIndex: tabsRouter.activeIndex,
            onPageChanged: tabsRouter.setActiveIndex,
            child: child,
          ),
        );
      },
    );
  }
}
