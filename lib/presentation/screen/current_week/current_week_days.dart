import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../domain/additional_model/calendar_date_range_data.dart';
import '../../../domain/additional_model/calendar_week_day.dart';
import '../../../domain/cubit/current_week_cubit.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
import '../../component/gap/gap_components.dart';
import '../../component/shimmer/shimmer_container.dart';
import '../../component/week_day_item_component.dart';
import '../../config/navigation/router.dart';
import '../../dialog/health_measurement_creator/health_measurement_creator_dialog.dart';
import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class CurrentWeekDays extends StatelessWidget {
  const CurrentWeekDays({super.key});

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
          for (int i = 0; i < 7; i++) const _DayItemShimmer(),
        if (dateRangeData != null && currentWeek != null)
          ...currentWeek.days.map(
            (CalendarWeekDay day) => WeekDayItem(
              day: day,
              onWorkoutPressed: _navigateToWorkoutPreview,
              onRacePressed: _navigateToRacePreview,
              onEditHealthMeasurement: () =>
                  _openHealthMeasurementCreator(day.date),
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

  Future<void> _openHealthMeasurementCreator(DateTime date) async {
    await showDialogDependingOnScreenSize(
      HealthMeasurementCreatorDialog(date: date),
    );
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

class _DayItemShimmer extends StatelessWidget {
  const _DayItemShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(height: 24, width: 150),
          Gap16(),
          _HealthDataShimmer(),
          Gap16(),
          ShimmerContainer(height: 48, width: double.infinity),
        ],
      ),
    );
  }
}

class _HealthDataShimmer extends StatelessWidget {
  const _HealthDataShimmer();

  @override
  Widget build(BuildContext context) {
    return const IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            child: Column(
              children: [
                ShimmerContainer(height: 14, width: 130),
                Gap8(),
                ShimmerContainer(height: 16, width: 70),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
