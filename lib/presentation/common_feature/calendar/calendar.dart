import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../../../domain/cubit/calendar_user_data_cubit.dart';
import '../../../domain/cubit/chart_date_range_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/calendar/bloc/calendar_component_bloc.dart';
import '../../component/calendar/calendar_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../component/shimmer/shimmer.dart';
import '../../config/navigation/router.dart';
import '../../dialog/day_preview/day_preview_dialog.dart';
import '../../dialog/day_preview/day_preview_dialog_actions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'calendar_stats.dart';

class Calendar extends StatelessWidget {
  final String userId;
  final DateRangeType initialDateRangeType;
  final bool canEditHealthMeasurement;

  const Calendar({
    super.key,
    required this.userId,
    this.initialDateRangeType = DateRangeType.month,
    this.canEditHealthMeasurement = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CalendarUserDataCubit(userId: userId)),
        BlocProvider(
          create: (_) => CalendarComponentBloc()
            ..add(CalendarComponentEventInitialize(
              dateRangeType: initialDateRangeType,
            )),
        ),
      ],
      child: const SingleChildScrollView(
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
        CalendarMobileStats(),
        Gap32(),
        _Calendar(),
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
        CalendarTabletStats(),
        GapHorizontal32(),
        CardBody(child: _Calendar()),
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
            child: _Calendar(),
          ),
        ),
        GapHorizontal16(),
        CalendarDesktopStats(),
      ],
    );
  }
}

class _Calendar extends StatelessWidget {
  const _Calendar();

  @override
  Widget build(BuildContext context) {
    final CalendarUserData? calendarUserData = context.select(
      (CalendarUserDataCubit cubit) => cubit.state,
    );

    return CalendarComponent(
      dateRangeType: DateRangeType.month,
      calendarUserData: calendarUserData,
      onDateRangeChanged: (DateTime startDate, DateTime endDate) =>
          _onDateRangeChanged(context, startDate, endDate),
      onDayPressed: (DateTime date) => _onDayPressed(context, date),
    );
  }

  void _onDateRangeChanged(
    BuildContext context,
    DateTime startDate,
    DateTime endDate,
  ) {
    context.read<CalendarUserDataCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final String userId = context.read<CalendarUserDataCubit>().userId;
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      DayPreviewDialog(userId: userId, date: date),
    );
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        navigateTo(WorkoutCreatorRoute(
          userId: userId,
          dateStr: action.date.toPathFormat(),
        ));
        break;
      case DayPreviewDialogActionAddRace():
        navigateTo(RaceCreatorRoute(
          userId: userId,
          dateStr: action.date.toPathFormat(),
        ));
        break;
      case DayPreviewDialogActionShowWorkout():
        navigateTo(
          WorkoutPreviewRoute(userId: userId, workoutId: action.workoutId),
        );
        break;
      case DayPreviewDialogActionShowRace():
        navigateTo(RacePreviewRoute(userId: userId, raceId: action.raceId));
        break;
    }
  }
}
