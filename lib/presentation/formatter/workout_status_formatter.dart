import 'package:flutter/material.dart';

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
      throw '[WorkoutStatusFormatter]: Unknown status type';
    }
  }
}
