import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_stage.dart';
import 'double_formatter.dart';

extension WorkoutStageFormatter on WorkoutStage {
  String toUIFormat(BuildContext context) {
    String description = '';
    final WorkoutStage stage = this;
    if (stage is WorkoutStageBaseRun) {
      description = _createDistanceStageDescription(context, stage);
    } else if (stage is WorkoutStageZone2) {
      description = _createDistanceStageDescription(context, stage);
    } else if (stage is WorkoutStageZone3) {
      description = _createDistanceStageDescription(context, stage);
    } else if (stage is WorkoutStageRhythms) {
      description = _createSeriesStageDescription(context, stage);
    } else if (stage is WorkoutStageHillRepeats) {
      description = _createSeriesStageDescription(context, stage);
    } else if (stage is WorkoutStageStretching) {
      description = _createStretchingDescription(context);
    } else if (stage is WorkoutStageStrengthening) {
      description = _createStrengtheningDescription(context);
    } else if (stage is WorkoutStageFoamRolling) {
      description = _createFoamRollingDescription(context);
    }
    return description;
  }

  String toTypeName(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (this is WorkoutStageBaseRun) {
      return appLocalizations.workout_stage_base_run;
    } else if (this is WorkoutStageZone2) {
      return appLocalizations.workout_stage_zone2;
    } else if (this is WorkoutStageZone3) {
      return appLocalizations.workout_stage_zone3;
    } else if (this is WorkoutStageRhythms) {
      return appLocalizations.workout_stage_rhythms;
    } else if (this is WorkoutStageHillRepeats) {
      return appLocalizations.workout_stage_hill_repeats;
    } else if (this is WorkoutStageStretching) {
      return appLocalizations.workout_stage_stretching;
    } else if (this is WorkoutStageStrengthening) {
      return appLocalizations.workout_stage_strengthening;
    } else if (this is WorkoutStageFoamRolling) {
      return appLocalizations.workout_stage_foamRolling;
    }
    return '';
  }

  String _createDistanceStageDescription(
    BuildContext context,
    DistanceWorkoutStage stage,
  ) {
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '${stage.toTypeName(context)} $distance HR<${stage.maxHeartRate}';
  }

  String _createSeriesStageDescription(
    BuildContext context,
    SeriesWorkoutStage stage,
  ) {
    final String seriesDescription =
        '${stage.amountOfSeries}x${stage.seriesDistanceInMeters}m';
    String breakDescription =
        '${AppLocalizations.of(context)!.workout_stage_break} ';
    if (stage.walkingDistanceInMeters > 0) {
      breakDescription += ' ${AppLocalizations.of(context)!.workout_stage_march(
        stage.walkingDistanceInMeters,
      )}, ';
    }
    if (stage.walkingDistanceInMeters > 0) {
      breakDescription += AppLocalizations.of(context)!.workout_stage_jog(
        stage.joggingDistanceInMeters,
      );
    }
    return '${stage.toTypeName(context)} $seriesDescription, $breakDescription';
  }

  String _createStretchingDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_stage_stretching;
  }

  String _createStrengtheningDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_stage_strengthening;
  }

  String _createFoamRollingDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_stage_foamRolling;
  }
}
