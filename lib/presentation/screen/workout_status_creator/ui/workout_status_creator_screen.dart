import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/model/workout_status.dart';
import '../../../component/scrollable_content_component.dart';
import '../../../component/text_field_component.dart';
import '../../../formatter/decimal_text_input_formatter.dart';
import '../../../formatter/mood_rate_formatter.dart';
import '../../../formatter/workout_status_formatter.dart';
import '../../../service/utils.dart';

part 'workout_status_creator_average_pace.dart';
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
