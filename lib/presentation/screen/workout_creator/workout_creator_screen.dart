import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get_it/get_it.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/workout_creator/workout_creator_bloc.dart';
import '../../../domain/entity/workout.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/screen_adjustable_body_component.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../component/text_field_component.dart';
import '../../config/body_sizes.dart';
import '../../extension/context_extensions.dart';
import '../../extension/string_extensions.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../../service/utils.dart';
import '../workout_stage_creator/workout_stage_creator_dialog.dart';

part 'workout_creator_content.dart';
part 'workout_creator_submit_button.dart';
part 'workout_creator_workout_stage_item.dart';
part 'workout_creator_workout_stages_list.dart';
part 'workout_creator_workout_stages_section.dart';

@RoutePage()
class WorkoutCreatorScreen extends StatelessWidget {
  final String? date;
  final String? workoutId;

  const WorkoutCreatorScreen({
    super.key,
    @PathParam('date') this.date,
    @PathParam('workoutId') this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime? date = this.date?.toDateTime();
    if (date == null) throw '[WORKOUT-CREATOR] Date is required!';
    return _BlocProvider(
      date: date,
      workoutId: workoutId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime date;
  final String? workoutId;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.workoutId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WorkoutCreatorBloc(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        date: date,
        workoutId: workoutId,
      )..add(const WorkoutCreatorEventInitialize()),
      child: child,
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<WorkoutCreatorBloc, WorkoutCreatorState,
        WorkoutCreatorBlocInfo, dynamic>(
      onInfo: (WorkoutCreatorBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutCreatorBlocInfo info) {
    switch (info) {
      case WorkoutCreatorBlocInfo.editModeInitialized:
        break;
      case WorkoutCreatorBlocInfo.workoutAdded:
        _onWorkoutAddedInfo(context);
        break;
      case WorkoutCreatorBlocInfo.workoutUpdated:
        _onWorkoutUpdatedInfo(context);
        break;
    }
  }

  void _onWorkoutAddedInfo(BuildContext context) {
    navigateBack();
    showSnackbarMessage(Str.of(context).workoutCreatorAddedWorkoutMessage);
  }

  void _onWorkoutUpdatedInfo(BuildContext context) {
    navigateBack();
    showSnackbarMessage(Str.of(context).workoutCreatorUpdatedWorkoutMessage);
  }
}
