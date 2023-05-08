import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_status.dart';

extension WorkoutStatusFormatter on WorkoutStatus {
  IconData toIcon() {
    if (this is WorkoutStatusPending) {
      return Icons.schedule;
    } else if (this is WorkoutStatusCompleted) {
      return Icons.check_circle_outline;
    } else if (this is WorkoutStatusUncompleted) {
      return Icons.cancel_outlined;
    } else {
      throw '[WorkoutStatusFormatter - toIcon()]: Unknown status type';
    }
  }

  String toLabel(BuildContext context) {
    final str = Str.of(context);
    if (this is WorkoutStatusPending) {
      return str.workoutStatusPending;
    } else if (this is WorkoutStatusCompleted) {
      return str.workoutStatusCompleted;
    } else if (this is WorkoutStatusUncompleted) {
      return str.workoutStatusUncompleted;
    } else {
      throw '[WorkoutStatusFormatter - toLabel()]: Unknown status type';
    }
  }

  Color toColor() {
    if (this is WorkoutStatusPending) {
      return Colors.deepOrangeAccent;
    } else if (this is WorkoutStatusCompleted) {
      return Colors.green;
    } else if (this is WorkoutStatusUncompleted) {
      return Colors.red;
    } else {
      throw '[WorkoutStatusFormatter - toColor()]: Unknown status type';
    }
  }
}
