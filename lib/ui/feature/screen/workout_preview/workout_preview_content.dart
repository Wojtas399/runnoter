import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/additional_model/activity_status.dart';
import '../../../../domain/cubit/workout_preview/workout_preview_cubit.dart';
import '../../../component/big_button_component.dart';
import '../../../component/body/medium_body_component.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../config/navigation/router.dart';
import '../../../extension/context_extensions.dart';
import '../../../service/navigator_service.dart';
import '../activity_status_creator/cubit/activity_status_creator_cubit.dart';
import 'workout_preview_actions.dart';
import 'workout_preview_workout_info.dart';

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
              child: Column(
                children: [
                  _WorkoutInfo(),
                  _WorkoutStatusButton(),
                ],
              ),
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
    final bool isWorkoutLoaded = context.select(
      (WorkoutPreviewCubit cubit) => cubit.state.isWorkoutLoaded,
    );

    return isWorkoutLoaded
        ? const WorkoutPreviewWorkoutInfo()
        : const LoadingInfo();
  }
}

class _WorkoutStatusButton extends StatelessWidget {
  const _WorkoutStatusButton();

  @override
  Widget build(BuildContext context) {
    final ActivityStatus? activityStatus = context.select(
      (WorkoutPreviewCubit cubit) => cubit.state.activityStatus,
    );
    String label = Str.of(context).activityStatusEditStatus;
    if (activityStatus is ActivityStatusPending) {
      label = Str.of(context).activityStatusFinish;
    }

    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: BigButton(
        label: label,
        onPressed: () => _onPressed(context),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    final workoutPreviewCubit = context.read<WorkoutPreviewCubit>();
    navigateTo(ActivityStatusCreatorRoute(
      userId: workoutPreviewCubit.userId,
      activityType: ActivityType.workout.name,
      activityId: workoutPreviewCubit.workoutId,
    ));
  }
}
