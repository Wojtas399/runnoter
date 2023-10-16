import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/additional_model/calendar_user_data.dart';
import '../../../../domain/cubit/calendar_user_data_cubit.dart';
import '../../../component/body/big_body_component.dart';
import '../../../component/card_body_component.dart';
import '../../../component/date_range_header_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../component/shimmer/shimmer.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/date_range_manager_cubit.dart';
import '../../../formatter/date_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import '../../dialog/day_preview/day_preview_dialog.dart';
import '../../dialog/day_preview/day_preview_dialog_actions.dart';
import 'calendar_month.dart';
import 'calendar_stats.dart';
import 'calendar_week.dart';
import 'cubit/calendar_cubit.dart';

class Calendar extends StatelessWidget {
  final String userId;

  const Calendar({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final List<Week>? calendarWeeks = context.read<CalendarCubit>().state.weeks;

    return BlocProvider(
      create: (_) => CalendarUserDataCubit(userId: userId)
        ..dateRangeChanged(
          startDate: calendarWeeks?.first.days.first.date,
          endDate: calendarWeeks?.last.days.last.date,
        ),
      child: const _BlocsListener(
        child: _Content(),
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
        BlocListener<CalendarCubit, CalendarState>(
          listenWhen: (previousState, currentState) =>
              previousState.dateRange != currentState.dateRange &&
              currentState.weeks != null,
          listener: _onDateRangeChanged,
        ),
        BlocListener<CalendarCubit, CalendarState>(
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
    context.read<CalendarCubit>().resetPressedDay();
  }

  void _onUserDataChanged(BuildContext context, CalendarUserData? userData) {
    context.read<CalendarCubit>().userDataUpdated(userData!);
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

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await _onRefresh(context),
      child: const SingleChildScrollView(
        child: BigBody(
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

  Future<void> _onRefresh(BuildContext context) async {
    final DateRange? dateRange = context.read<CalendarCubit>().state.dateRange;
    if (dateRange != null) {
      await context.read<CalendarUserDataCubit>().refresh(
            startDate: dateRange.startDate,
            endDate: dateRange.endDate,
          );
    }
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 144),
      child: Column(
        children: [
          CalendarMobileStats(),
          Gap32(),
          _CalendarBody(),
        ],
      ),
    );
  }
}

class _TabletContent extends StatelessWidget {
  const _TabletContent();

  @override
  Widget build(BuildContext context) {
    return const Paddings24(
      child: Column(
        children: [
          _DateRange(),
          Gap24(),
          CalendarTabletStats(),
          Gap16(),
          CardBody(child: _CalendarBody()),
        ],
      ),
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Paddings24(
      child: Column(
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
      ),
    );
  }
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    final DateRangeType dateRangeType = context.select(
      (CalendarCubit cubit) => cubit.state.dateRangeType,
    );
    final DateRange? dateRange = context.select(
      (CalendarCubit cubit) => cubit.state.dateRange,
    );

    return dateRange != null
        ? DateRangeHeader(
            selectedDateRangeType: dateRangeType,
            dateRange: dateRange,
            onWeekSelected: () => context
                .read<CalendarCubit>()
                .changeDateRangeType(DateRangeType.week),
            onMonthSelected: () => context
                .read<CalendarCubit>()
                .changeDateRangeType(DateRangeType.month),
            onPreviousRangePressed:
                context.read<CalendarCubit>().previousDateRange,
            onNextRangePressed: context.read<CalendarCubit>().nextDateRange,
          )
        : const SizedBox();
  }
}

class _CalendarBody extends StatelessWidget {
  const _CalendarBody();

  @override
  Widget build(BuildContext context) {
    final DateRangeType? dateRangeType = context.select(
      (CalendarCubit cubit) => cubit.state.dateRangeType,
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
