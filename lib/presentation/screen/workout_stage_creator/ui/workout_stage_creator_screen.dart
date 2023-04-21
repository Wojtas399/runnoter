import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../service/navigator_service.dart';
import '../../../service/utils.dart';
import '../bloc/workout_stage_creator_bloc.dart';

part 'workout_stage_creator_content.dart';
part 'workout_stage_creator_distance_form.dart';
part 'workout_stage_creator_series_form.dart';

class WorkoutStageCreatorScreen extends StatelessWidget {
  const WorkoutStageCreatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const _BlocProvider(
      child: WorkoutStageCreatorContent(),
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
      create: (_) => WorkoutStageCreatorBloc(),
      child: child,
    );
  }
}
