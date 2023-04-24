import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_stage.dart';
import 'double_formatter.dart';

extension WorkoutStageFormatter on WorkoutStage {
  String toUIFormat(BuildContext context) {
    String description = '';
    final WorkoutStage stage = this;
    if (stage is WorkoutStageBaseRun) {
      description = _createBaseRunDescription(context, stage);
    } else if (stage is WorkoutStageZone2) {
      description = _createZone2Description(context, stage);
    } else if (stage is WorkoutStageZone3) {
      description = _createZone3Description(context, stage);
    } else if (stage is WorkoutStageRhythms) {
      description = _createRhythmsDescription(context, stage);
    } else if (stage is WorkoutStageHillRepeats) {
      description = _createHillRepeatsDescription(context, stage);
    } else if (stage is WorkoutStageStretching) {
      description = _createStretchingDescription(context);
    } else if (stage is WorkoutStageStrengthening) {
      description = _createStrengtheningDescription(context);
    } else if (stage is WorkoutStageFoamRolling) {
      description = _createFoamRollingDescription(context);
    }
    return description;
  }

  String _createBaseRunDescription(
    BuildContext context,
    WorkoutStageBaseRun stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_base_run;
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '$stageName $distance HR<${stage.maxHeartRate}';
  }

  String _createZone2Description(
    BuildContext context,
    WorkoutStageZone2 stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_zone2;
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '$stageName $distance HR<${stage.maxHeartRate}';
  }

  String _createZone3Description(
    BuildContext context,
    WorkoutStageZone3 stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_zone3;
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '$stageName $distance HR<${stage.maxHeartRate}';
  }

  String _createRhythmsDescription(
    BuildContext context,
    WorkoutStageRhythms stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_rhythms;
    final String seriesDescription =
        '${stage.amountOfSeries}x${stage.seriesDistanceInMeters}m';
    String breakDescription = '${AppLocalizations.of(context)!.workout_break} ';
    if (stage.breakMarchDistanceInMeters > 0) {
      breakDescription += ' ${AppLocalizations.of(context)!.workout_march(
        stage.breakMarchDistanceInMeters,
      )}, ';
    }
    breakDescription += AppLocalizations.of(context)!.workout_jog(
      stage.breakJogDistanceInMeters,
    );
    return '$stageName $seriesDescription, $breakDescription';
  }

  String _createHillRepeatsDescription(
    BuildContext context,
    WorkoutStageHillRepeats stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_hill_repeats;
    final String seriesDescription =
        '${stage.amountOfSeries}x${stage.seriesDistanceInMeters}m';
    String breakDescription = '${AppLocalizations.of(context)!.workout_break} ';
    if (stage.breakMarchDistanceInMeters > 0) {
      breakDescription += ' ${AppLocalizations.of(context)!.workout_march(
        stage.breakMarchDistanceInMeters,
      )}, ';
    }
    breakDescription += AppLocalizations.of(context)!.workout_jog(
      stage.breakJogDistanceInMeters,
    );
    return '$stageName $seriesDescription, $breakDescription';
  }

  String _createStretchingDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_stretching;
  }

  String _createStrengtheningDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_strengthening;
  }

  String _createFoamRollingDescription(BuildContext context) {
    return AppLocalizations.of(context)!.workout_foamRolling;
  }
}
