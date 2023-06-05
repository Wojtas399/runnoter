import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../domain/bloc/day_preview/day_preview_bloc.dart';
import '../../../domain/entity/run_status.dart';
import '../../../domain/entity/workout_stage.dart';
import '../../../domain/repository/workout_repository.dart';
import '../../../domain/service/auth_service.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/nullable_text_component.dart';
import '../../config/navigation/routes.dart';
import '../../formatter/date_formatter.dart';
import '../../formatter/list_of_workout_stages_formatter.dart';
import '../../formatter/mood_rate_formatter.dart';
import '../../formatter/pace_formatter.dart';
import '../../formatter/run_status_formatter.dart';
import '../../formatter/workout_stage_formatter.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import '../screens.dart';

part 'day_preview_app_bar.dart';
part 'day_preview_content.dart';
part 'day_preview_no_workout_content.dart';
part 'day_preview_run_status.dart';
part 'day_preview_workout_content.dart';

class DayPreviewScreen extends StatelessWidget {
  final DateTime date;

  const DayPreviewScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      date: date,
      child: const _BlocListener(
        child: DayPreviewContent(),
      ),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final DateTime date;
  final Widget child;

  const _BlocProvider({
    required this.date,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => DayPreviewBloc(
        authService: context.read<AuthService>(),
        workoutRepository: context.read<WorkoutRepository>(),
        dateService: DateService(),
      )..add(
          DayPreviewEventInitialize(
            date: date,
          ),
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
    return BlocWithStatusListener<DayPreviewBloc, DayPreviewState,
        DayPreviewInfo, dynamic>(
      onInfo: (DayPreviewInfo info) {
        _manageInfo(context, info);
      },
      child: child,
    );
  }

  void _manageInfo(BuildContext context, DayPreviewInfo info) {
    switch (info) {
      case DayPreviewInfo.editWorkout:
        _navigateToWorkoutEditor(context);
        break;
      case DayPreviewInfo.workoutDeleted:
        _showInfoAboutDeletedWorkout(context);
        break;
    }
  }

  void _navigateToWorkoutEditor(BuildContext context) {
    final DayPreviewBloc dayPreviewBloc = context.read<DayPreviewBloc>();
    final DateTime? date = dayPreviewBloc.state.date;
    final String? workoutId = dayPreviewBloc.state.workoutId;
    if (date != null && workoutId != null) {
      navigateTo(
        context: context,
        route: WorkoutCreatorRoute(
          creatorArguments: WorkoutCreatorEditModeArguments(
            date: date,
            workoutId: workoutId,
          ),
        ),
      );
    }
  }

  void _showInfoAboutDeletedWorkout(BuildContext context) {
    showSnackbarMessage(
      context: context,
      message: Str.of(context).dayPreviewDeletedWorkoutMessage,
    );
  }
}
