import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_status.dart';
import '../../../component/big_button_component.dart';
import '../../../component/scrollable_content_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../formatter/minutes_or_seconds_input_formatter.dart';
import '../../../formatter/mood_rate_formatter.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../../../service/utils.dart';
import '../bloc/workout_status_creator_bloc.dart';

part 'workout_status_creator_average_pace.dart';
part 'workout_status_creator_content.dart';
part 'workout_status_creator_status_type.dart';

abstract class WorkoutStatusCreatorArguments {
  final String? workoutId;

  const WorkoutStatusCreatorArguments({
    required this.workoutId,
  });
}

class WorkoutStatusCreatorFinishWorkoutArguments
    extends WorkoutStatusCreatorArguments {
  WorkoutStatusCreatorFinishWorkoutArguments({
    required super.workoutId,
  });
}

class WorkoutStatusCreatorScreen extends StatelessWidget {
  final WorkoutStatusCreatorArguments arguments;

  const WorkoutStatusCreatorScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: _Content(),
    );
  }
}

class _BlocProvider extends StatelessWidget {
  final Widget child;

  const _BlocProvider({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WorkoutStatusCreatorBloc(),
      child: child,
    );
  }
}
