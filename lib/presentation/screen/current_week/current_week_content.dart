import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/additional_model/calendar_week_day.dart';
import '../../../domain/cubit/current_week_cubit.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/body/big_body_component.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/shimmer/shimmer.dart';
import '../../component/week_day_item_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';
import 'current_week_day_item_shimmer.dart';
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
        _CurrentWeekDays(),
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
        CardBody(child: _CurrentWeekDays()),
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
            child: _CurrentWeekDays(),
          ),
        ),
        GapHorizontal16(),
        CurrentWeekDesktopStats(),
      ],
    );
  }
}

class _CurrentWeekDays extends StatelessWidget {
  const _CurrentWeekDays();

  @override
  Widget build(BuildContext context) {
    final CalendarDateRangeData? dateRangeData = context.select(
      (CurrentWeekCubit cubit) => cubit.state,
    );
    final CalendarWeek? currentWeek = context.select(
      (CalendarComponentBloc bloc) =>
          bloc.state.weeks?.isNotEmpty == true ? bloc.state.weeks!.first : null,
    );

    return Column(
      children: <Widget>[
        if (dateRangeData == null || currentWeek == null)
          for (int i = 0; i < 7; i++) const CurrentWeekDayItemShimmer(),
        if (dateRangeData != null && currentWeek != null)
          ...currentWeek.days.map(
            (CalendarWeekDay day) => WeekDayItem(
              day: day,
              onWorkoutPressed: _navigateToWorkoutPreview,
              onRacePressed: _navigateToRacePreview,
              onAddWorkout: () => _navigateToWorkoutCreator(day.date),
              onAddRace: () => _navigateToRaceCreator(day.date),
            ),
          ),
      ].addSeparator(const Divider(height: 16)),
    );
  }

  Future<void> _navigateToWorkoutPreview(String workoutId) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(WorkoutPreviewRoute(
      userId: loggedUserId,
      workoutId: workoutId,
    ));
  }

  Future<void> _navigateToRacePreview(String raceId) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(RacePreviewRoute(
      userId: loggedUserId,
      raceId: raceId,
    ));
  }

  Future<void> _navigateToWorkoutCreator(DateTime date) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(WorkoutCreatorRoute(
      userId: loggedUserId,
      dateStr: date.toPathFormat(),
    ));
  }

  Future<void> _navigateToRaceCreator(DateTime date) async {
    final String? loggedUserId = await getIt<AuthService>().loggedUserId$.first;
    navigateTo(RaceCreatorRoute(
      userId: loggedUserId,
      dateStr: date.toPathFormat(),
    ));
  }
}
