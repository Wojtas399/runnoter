import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_status.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/workout_status_formatter.dart';

part 'workout_status_creator_content.dart';
part 'workout_status_creator_status_type.dart';

class WorkoutStatusCreatorScreen extends StatelessWidget {
  final String workoutId;

  const WorkoutStatusCreatorScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}
