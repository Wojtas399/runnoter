import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/calendar_user_data.dart';
import '../../../domain/bloc/calendar/calendar_bloc.dart';
import '../../../domain/cubit/calendar_user_data_cubit.dart';
import '../../../domain/cubit/date_range_manager_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/date_range_header_component.dart';
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
import 'calendar_month.dart';
import 'calendar_stats.dart';
import 'calendar_week.dart';

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
    final List<Week>? calendarWeeks = context.read<CalendarBloc>().state.weeks;

    return BlocProvider(
      create: (_) => CalendarUserDataCubit(userId: userId)
        ..dateRangeChanged(
          startDate: calendarWeeks?.first.days.first.date,
          endDate: calendarWeeks?.last.days.last.date,
        ),
      child: const _BlocsListener(
        child: SingleChildScrollView(
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
      ),
    );
  }
}

class _BlocsListener extends StatelessWidget {
  final Widget child;

  const _BlocsListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CalendarBloc, CalendarState>(
          listenWhen: (previousState, currentState) =>
              previousState.dateRange != currentState.dateRange &&
              currentState.weeks != null,
          listener: _onDateRangeChanged,
        ),
        BlocListener<CalendarBloc, CalendarState>(
          listenWhen: (previousState, currentState) =>
              currentState.pressedDay != null,
          listener: _onDayPressed,
        ),
        BlocListener<CalendarUserDataCubit, CalendarUserData?>(
          listenWhen: (previousState, currentState) => currentState != null,
          listener: _onUserDataChanged,
        ),
      ],
      child: child,
    );
  }

  void _onDateRangeChanged(BuildContext context, CalendarState state) {
    final DateTime startDate = state.weeks!.first.days.first.date;
    final DateTime endDate = state.weeks!.last.days.last.date;
    context.read<CalendarUserDataCubit>().dateRangeChanged(
          startDate: startDate,
          endDate: endDate,
        );
  }

  void _onDayPressed(BuildContext context, CalendarState state) {
    _manageDayPreview(context, state.pressedDay!);
    context.read<CalendarBloc>().add(
          const CalendarEventResetPressedDay(),
        );
  }

  void _onUserDataChanged(BuildContext context, CalendarUserData? userData) {
    context.read<CalendarBloc>().add(
          CalendarEventUserDataUpdated(userData: userData!),
        );
  }

  Future<void> _manageDayPreview(BuildContext context, DateTime date) async {
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

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CalendarMobileStats(),
        Gap32(),
        _CalendarBody(),
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
        _DateRange(),
        Gap24(),
        CalendarTabletStats(),
        Gap16(),
        CardBody(child: _CalendarBody()),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _DateRange(),
        Gap24(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CardBody(
                child: _CalendarBody(),
              ),
            ),
            GapHorizontal16(),
            CalendarDesktopStats(),
          ],
        ),
      ],
    );
  }
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (CalendarBloc bloc) => bloc.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarBloc bloc) => bloc.state.dateRange,
    );

    return dateRange != null
        ? DateRangeHeader(
            selectedDateRangeType: dateRangeType,
            dateRange: dateRange,
            onWeekSelected: () =>
                _onDateRangeTypeChanged(context, DateRangeType.week),
            onMonthSelected: () =>
                _onDateRangeTypeChanged(context, DateRangeType.month),
            onPreviousRangePressed: () => _onPreviousDateRange(context),
            onNextRangePressed: () => _onNextDateRange(context),
          )
        : const SizedBox();
  }

  void _onDateRangeTypeChanged(
    BuildContext context,
    DateRangeType dateRangeType,
  ) {
    context.read<CalendarBloc>().add(
          CalendarEventChangeDateRangeType(dateRangeType: dateRangeType),
        );
  }

  void _onPreviousDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventPreviousDateRange(),
        );
  }

  void _onNextDateRange(BuildContext context) {
    context.read<CalendarBloc>().add(
          const CalendarEventNextDateRange(),
        );
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody();

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (CalendarBloc bloc) => bloc.state.dateRangeType,
    );

    return Column(
      children: [
        if (dateRangeType == DateRangeType.week)
          const CalendarWeek()
        else if (dateRangeType == DateRangeType.month)
          const CalendarMonth(),
      ],
    );
  }
}
