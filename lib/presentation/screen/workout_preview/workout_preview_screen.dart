import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/workout_preview/workout_preview_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/content_with_label_component.dart';
import '../../component/edit_delete_popup_menu_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/nullable_text_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/run_status_info_component.dart';
import '../../component/screen_adjustable_body_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/routes.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/list_of_workout_stages_formatter.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../screens.dart';

part 'workout_preview_actions.dart';
part 'workout_preview_content.dart';
part 'workout_preview_workout.dart';

class WorkoutPreviewScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutPreviewScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      workoutId: workoutId,
      child: const _BlocListener(
        child: _Content(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final String workoutId;
  final Widget child;

  const _BlocProvider({
    required this.workoutId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => WorkoutPreviewBloc(
        workoutId: workoutId,
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
      )..add(
          const WorkoutPreviewEventInitialize(),
        ),
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
    return BlocWithStatusListener<WorkoutPreviewBloc, WorkoutPreviewState,
        WorkoutPreviewBlocInfo, dynamic>(
      onInfo: (WorkoutPreviewBlocInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, WorkoutPreviewBlocInfo info) {
    switch (info) {
      case WorkoutPreviewBlocInfo.workoutDeleted:
        navigateBack();
        _showInfoAboutDeletedWorkout(context);
        break;
    }
  }

  void _showInfoAboutDeletedWorkout(BuildContext context) {
    showSnackbarMessage(Str.of(context).workoutPreviewDeletedWorkoutMessage);
  }
}
