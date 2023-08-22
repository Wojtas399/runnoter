import 'package:flutter/material.dart';

import '../../component/body/big_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/shimmer/shimmer.dart';
import 'current_week_days.dart';
import 'current_week_stats.dart';

class CurrentWeekContent extends StatelessWidget {
  const CurrentWeekContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: BigBody(
        child: Paddings24(
          child: Shimmer(
            child: ResponsiveLayout(
              mobileBody: _MobileContent(),
              tabletBody: _TabletContent(),
              desktopBody: _DesktopContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CurrentWeekMobileStats(),
        Gap32(),
        CurrentWeekDays(),
      ],
    );
  }
}

class _TabletContent extends StatelessWidget {
  const _TabletContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CurrentWeekTabletStats(),
        GapHorizontal32(),
        CardBody(child: CurrentWeekDays()),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: CardBody(
            child: CurrentWeekDays(),
          ),
        ),
        GapHorizontal16(),
        CurrentWeekDesktopStats(),
      ],
    );
  }
}
