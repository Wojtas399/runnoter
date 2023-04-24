import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_status.dart';

extension WorkoutStatusFormatter on WorkoutStatus {
  Icon toIcon() {
    if (this is WorkoutStatusPending) {
      return const Icon(
        Icons.schedule,
        color: Colors.orange,
      );
    } else if (this is WorkoutStatusDone) {
      return const Icon(
        Icons.check_circle_outline,
        color: Colors.green,
      );
    } else if (this is WorkoutStatusFailed) {
      return const Icon(
        Icons.cancel_outlined,
        color: Colors.red,
      );
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
}
