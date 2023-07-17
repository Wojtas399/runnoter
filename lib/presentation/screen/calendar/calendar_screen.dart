import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/bloc/calendar/calendar_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/calendar/calendar_component.dart';
import '../../component/calendar/calendar_component_cubit.dart';
import '../../component/card_body_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/body_sizes.dart';
import '../../config/navigation/router.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../day_preview/day_preview_dialog.dart';
import '../day_preview/day_preview_dialog_actions.dart';

@RoutePage()
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: GetIt.I.get<BodySizes>().bigBodyWidth,
            ),
            child: const ResponsiveLayout(
              mobileBody: Paddings24(
                child: _Calendar(),
              ),
              tabletBody: CardBody(
                child: _Calendar(),
              ),
              desktopBody: CardBody(
                child: _Calendar(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final Widget child;

  const _CubitProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CalendarCubit(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
      ),
      child: child,
    );
  }
}

class _Calendar extends StatefulWidget {
  const _Calendar();

  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<_Calendar> {
  @override
  Widget build(BuildContext context) {
    final CalendarState state = context.select(
      (CalendarCubit cubit) => cubit.state,
    );

    return Calendar(
      activities: [
        ...?state.workouts?.map(
          (Workout workout) => CalendarDayActivity(
            date: workout.date,
            color: workout.status.toColor(context),
          ),
        ),
        ...?state.races?.map(
          (Race race) => CalendarDayActivity(
            date: race.date,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      onMonthChanged: (
        DateTime firstDisplayingDate,
        DateTime lastDisplayingDate,
      ) {
        _onMonthChanged(context, firstDisplayingDate, lastDisplayingDate);
      },
      onDayPressed: (DateTime date) {
        _onDayPressed(context, date);
      },
    );
  }

  void _onMonthChanged(
    BuildContext context,
    DateTime firstDisplayingDate,
    DateTime lastDisplayingDate,
  ) {
    context.read<CalendarCubit>().monthChanged(
          firstDisplayingDate: firstDisplayingDate,
          lastDisplayingDate: lastDisplayingDate,
        );
  }

  Future<void> _onDayPressed(BuildContext context, DateTime date) async {
    final DayPreviewDialogAction? action =
        await showDialogDependingOnScreenSize(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: context.read<AuthService>()),
          RepositoryProvider.value(value: context.read<WorkoutRepository>()),
          RepositoryProvider.value(value: context.read<RaceRepository>()),
        ],
        child: DayPreviewDialog(date: date),
      ),
    );
    if (action == null) return;
    switch (action) {
      case DayPreviewDialogActionAddWorkout():
        navigateTo(
          WorkoutCreatorRoute(date: action.date.toPathFormat()),
        );
        break;
      case DayPreviewDialogActionAddRace():
        navigateTo(
          RaceCreatorRoute(dateStr: action.date.toPathFormat()),
        );
        break;
      case DayPreviewDialogActionShowWorkout():
        navigateTo(
          WorkoutPreviewRoute(workoutId: action.workoutId),
        );
        break;
      case DayPreviewDialogActionShowRace():
        navigateTo(
          RacePreviewRoute(raceId: action.raceId),
        );
        break;
    }
  }
}
