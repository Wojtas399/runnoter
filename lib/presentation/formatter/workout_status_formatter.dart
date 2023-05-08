import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_status.dart';

extension WorkoutStatusFormatter on WorkoutStatus {
  IconData toIcon() {
    if (this is WorkoutStatusPending) {
      return Icons.schedule;
    } else if (this is WorkoutStatusDone) {
      return Icons.check_circle_outline;
    } else if (this is WorkoutStatusAborted) {
      return Icons.stop_circle_outlined;
    } else if (this is WorkoutStatusUndone) {
      return Icons.cancel_outlined;
    } else {
      throw '[WorkoutStatusFormatter - toIcon()]: Unknown status type';
    }
  }

  String toLabel(BuildContext context) {
    final str = Str.of(context);
    if (this is WorkoutStatusPending) {
      return str.workoutStatusPending;
    } else if (this is WorkoutStatusDone) {
      return str.workoutStatusDone;
    } else if (this is WorkoutStatusAborted) {
      return str.workoutStatusAborted;
    } else if (this is WorkoutStatusUndone) {
      return str.workoutStatusUndone;
    } else {
      throw '[WorkoutStatusFormatter - toLabel()]: Unknown status type';
    }
  }

  Color toColor() {
    if (this is WorkoutStatusPending) {
      return Colors.deepOrangeAccent;
    } else if (this is WorkoutStatusDone) {
      return Colors.green;
    } else if (this is WorkoutStatusAborted) {
      return Colors.grey;
    } else if (this is WorkoutStatusUndone) {
      return Colors.red;
    } else {
      throw '[WorkoutStatusFormatter - toColor()]: Unknown status type';
    }
  }
}
