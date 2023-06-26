import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/day_preview/day_preview_cubit.dart';
import '../../../domain/entity/race.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/activity_item_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';
import '../screens.dart';

part 'day_preview_activities_content.dart';

class DayPreviewScreen extends StatelessWidget {
  final DateTime date;

  const DayPreviewScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      date: date,
      child: const _Content(),
    );
  }
}

class _CubitProvider extends StatelessWidget {
  final DateTime date;
  final Widget child;

  const _CubitProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DayPreviewCubit(
        date: date,
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
        dateService: DateService(),
      )..initialize(),
      child: child,
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      floatingActionButton: _FloatingActionButton(),
      body: SafeArea(
        child: _ActivitiesContent(),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final DateTime date = context.read<DayPreviewCubit>().date;

    return AppBar(
      centerTitle: true,
      title: Text(
        '${Str.of(context).day} ${date.toDateWithDots()}',
      ),
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      spacing: 16,
      childMargin: EdgeInsets.zero,
      childPadding: const EdgeInsets.all(8.0),
      children: [
        SpeedDialChild(
          child: const Icon(Icons.directions_run_outlined),
          label: Str.of(context).workout,
          onTap: () {
            _onAddWorkoutSelected(context);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.emoji_events),
          label: Str.of(context).race,
          onTap: () {
            _onAddRaceSelected(context);
          },
        ),
      ],
    );
  }

  void _onAddWorkoutSelected(BuildContext context) {
    navigateTo(
      context: context,
      route: WorkoutCreatorRoute(
        creatorArguments: WorkoutCreatorAddModeArguments(
          date: context.read<DayPreviewCubit>().date,
        ),
      ),
    );
  }

  void _onAddRaceSelected(BuildContext context) {
    navigateTo(
      context: context,
      route: const RaceCreatorRoute(),
    );
  }
}
