import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout.dart';

extension AdditionalWorkoutFormatted on AdditionalWorkout {
  String toUIFormat(BuildContext context) {
    switch (this) {
      case AdditionalWorkout.stretching:
        return AppLocalizations.of(context)!.additional_workout_stretching;
      case AdditionalWorkout.strengthening:
        return AppLocalizations.of(context)!.additional_workout_strengthening;
    }
  }
}
