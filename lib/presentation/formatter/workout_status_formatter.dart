import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_status.dart';

extension WorkoutStatusFormatter on WorkoutStatus {
  IconData toIcon() {
    if (this is WorkoutStatusPending) {
      return Icons.schedule;
    } else if (this is WorkoutStatusDone) {
      return Icons.check_circle_outline;
    } else if (this is WorkoutStatusFailed) {
      return Icons.cancel_outlined;
    } else {
      throw '[WorkoutStatusFormatter - toIcon()]: Unknown status type';
    }
  }

  String toLabel(BuildContext context) {
    if (this is WorkoutStatusPending) {
      return AppLocalizations.of(context)!.workout_status_pending;
    } else if (this is WorkoutStatusDone) {
      return AppLocalizations.of(context)!.workout_status_done;
    } else if (this is WorkoutStatusFailed) {
      return AppLocalizations.of(context)!.workout_status_failed;
    } else {
      throw '[WorkoutStatusFormatter - toLabel()]: Unknown status type';
    }
  }

  Color toColor() {
    if (this is WorkoutStatusPending) {
      return Colors.deepOrangeAccent;
    } else if (this is WorkoutStatusDone) {
      return Colors.green;
    } else if (this is WorkoutStatusFailed) {
      return Colors.red;
    } else {
      throw '[WorkoutStatusFormatter - toColor()]: Unknown status type';
    }
  }
}
