import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout.dart';
import '../../../../domain/model/workout_stage.dart';
import '../../../../domain/model/workout_status.dart';
import '../../../../domain/repository/workout_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../component/big_button_component.dart';
import '../../../config/navigation/routes.dart';
import '../../../formatter/date_formatter.dart';
import '../../../formatter/list_of_workout_stages_formatter.dart';
import '../../../formatter/workout_stage_formatter.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../../../service/navigator_service.dart';
import '../bloc/day_preview_bloc.dart';
import '../bloc/day_preview_event.dart';

part 'day_preview_content.dart';
part 'day_preview_no_workout_content.dart';
part 'day_preview_workout_content.dart';
part 'day_preview_workout_status_buttons.dart';

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
      child: const DayPreviewContent(),
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
      )..add(
          DayPreviewEventInitialize(
            date: date,
          ),
        ),
      child: child,
    );
  }
}
