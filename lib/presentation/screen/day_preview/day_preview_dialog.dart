import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/day_preview/day_preview_cubit.dart';
import '../../../domain/repository/race_repository.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/responsive_layout_component.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/navigator_service.dart';
import 'day_preview_activities_content.dart';
import 'day_preview_dialog_actions.dart';

class DayPreviewDialog extends StatelessWidget {
  final DateTime date;

  const DayPreviewDialog({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _CubitProvider(
      date: date,
      child: const ResponsiveLayout(
        mobileBody: _FullScreenContent(),
        desktopBody: _NormalDialog(),
      ),
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
        workoutRepository: context.read<WorkoutRepository>(),
        raceRepository: context.read<RaceRepository>(),
        dateService: DateService(),
      )..initialize(),
      child: child,
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return AlertDialog(
      title: const _Title(),
      content: const SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _Actions(),
              SizedBox(height: 16),
              DayPreviewActivities(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(str.close),
        ),
      ],
    );
  }
}

class _FullScreenContent extends StatelessWidget {
  const _FullScreenContent();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      floatingActionButton: _Actions(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Paddings24(
            child: DayPreviewActivities(),
          ),
        ),
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
    return AppBar(
      centerTitle: true,
      title: const _Title(),
      leading: const CloseButton(),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    final DateTime date = context.read<DayPreviewCubit>().date;

    return Text('${Str.of(context).day} ${date.toDateWithDots()}');
  }
}

class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    if (context.isMobileSize) {
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
            child: const Icon(Icons.emoji_events),
            label: str.race,
            onTap: () => _addRace(context),
          ),
          SpeedDialChild(
            child: const Icon(Icons.directions_run_outlined),
            label: str.workout,
            onTap: () => _addWorkout(context),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: FilledButton(
              onPressed: () => _addWorkout(context),
              child: Text('${str.add} ${str.workout}'),
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: FilledButton(
              onPressed: () => _addRace(context),
              child: Text('${str.add} ${str.race}'),
            ),
          ),
        ],
      ),
    );
  }

  void _addWorkout(BuildContext context) {
    popRoute(
      result: DayPreviewDialogActionAddWorkout(
        date: context.read<DayPreviewCubit>().date,
      ),
    );
  }

  void _addRace(BuildContext context) {
    popRoute(
      result: DayPreviewDialogActionAddRace(
        date: context.read<DayPreviewCubit>().date,
      ),
    );
  }
}
