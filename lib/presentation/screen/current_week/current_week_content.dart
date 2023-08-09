import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/current_week_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/shimmer.dart';
import '../../extension/widgets_list_extensions.dart';
import 'current_week_day_item.dart';
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
        _ListOfDays(),
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
        CardBody(child: _ListOfDays()),
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
            child: _ListOfDays(),
          ),
        ),
        GapHorizontal16(),
        CurrentWeekDesktopStats(),
      ],
    );
  }
}

class _ListOfDays extends StatelessWidget {
  const _ListOfDays();

  @override
  Widget build(BuildContext context) {
    final List<Day>? days = context.select(
      (CurrentWeekCubit cubit) => cubit.state,
    );

    return Column(
      children: <Widget>[
        if (days == null)
          for (int i = 0; i < 7; i++) const CurrentWeekDayItemShimmer(),
        if (days != null) ...days.map((day) => CurrentWeekDayItem(day: day)),
      ].addSeparator(const Divider(height: 16)),
    );
  }
}
