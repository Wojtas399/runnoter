import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_stage.dart';
import '../../../component/scrollable_content_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/workout_stage_formatter.dart';
import '../../../service/dialog_service.dart';
import '../../../service/utils.dart';
import '../../workout_stage_creator/ui/workout_stage_creator_screen.dart';
import '../bloc/workout_creator_bloc.dart';

part 'workout_creator_content.dart';
part 'workout_creator_workout_stage_item.dart';
part 'workout_creator_workout_stages.dart';

class WorkoutCreatorScreen extends StatelessWidget {
  final DateTime date;

  const WorkoutCreatorScreen({
    super.key,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return _BlocProvider(
      date: date,
      child: const _Content(),
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
      create: (_) => WorkoutCreatorBloc()
        ..add(
          WorkoutCreatorEventInitialize(date: date),
        ),
      child: child,
    );
  }
}
