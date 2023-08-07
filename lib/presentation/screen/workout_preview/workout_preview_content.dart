import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../extension/context_extensions.dart';
import 'workout_preview_actions.dart';
import 'workout_preview_workout.dart';

class WorkoutPreviewContent extends StatelessWidget {
  const WorkoutPreviewContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: MediumBody(
            child: Paddings24(
              child: _WorkoutInfo(),
            ),
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
      title: Text(Str.of(context).workoutPreviewTitle),
      centerTitle: true,
      actions: context.isMobileSize
          ? const [
              WorkoutPreviewWorkoutActions(),
              GapHorizontal8(),
            ]
          : null,
    );
  }
}

class _WorkoutInfo extends StatelessWidget {
  const _WorkoutInfo();

  @override
  Widget build(BuildContext context) {
    final bool areDataLoaded = context.select(
      (WorkoutPreviewBloc bloc) => bloc.state.areDataLoaded,
    );

    return areDataLoaded
        ? const WorkoutPreviewWorkoutInfo()
        : const LoadingInfo();
  }
}
