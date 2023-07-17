import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/current_week/current_week_cubit.dart';
import '../../component/card_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import '../../extension/widgets_list_extensions.dart';
import 'current_week_day_item.dart';
import 'current_week_stats.dart';

class CurrentWeekContent extends StatelessWidget {
  const CurrentWeekContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: GetIt.I.get<BodySizes>().bigBodyWidth,
          ),
          child: const ResponsiveLayout(
            mobileBody: _MobileContent(),
            tabletBody: _TabletContent(),
            desktopBody: _DesktopContent(),
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
    return const Paddings24(
      child: Column(
        children: [
          CurrentWeekMobileStats(),
          SizedBox(height: 32),
          _ListOfDays(),
        ],
      ),
    );
  }
}

class _TabletContent extends StatelessWidget {
  const _TabletContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 24, bottom: 24),
      child: Column(
        children: [
          CurrentWeekTabletStats(),
          SizedBox(width: 32),
          CardBody(child: _ListOfDays()),
        ],
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(right: 24, bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CardBody(
              child: _ListOfDays(),
            ),
          ),
          SizedBox(width: 16),
          CurrentWeekDesktopStats(),
        ],
      ),
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

    return days == null
        ? const LoadingInfo()
        : Column(
            children: <Widget>[
              ...days.map((day) => CurrentWeekDayItem(day: day)),
            ].addSeparator(const Divider(height: 16)),
          );
  }
}
