import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/model/workout_stage.dart';
import 'double_formatter.dart';

extension WorkoutStageFormatter on WorkoutStage {
  String toUIFormat(BuildContext context) {
    String description = '';
    final WorkoutStage stage = this;
    if (stage is WorkoutStageOWB) {
      description = _createOWBDescription(stage);
    } else if (stage is WorkoutStageBC2) {
      description = _createBC2Description(stage);
    } else if (stage is WorkoutStageBC3) {
      description = _createBC3Description(stage);
    } else if (stage is WorkoutStageRhythms) {
      description = _createRhythmsDescription(context, stage);
    } else if (stage is WorkoutStageStrength) {
      description = _createStrengthDescription(context, stage);
    }
    return description;
  }

  String _createOWBDescription(WorkoutStageOWB stage) {
    const String stageName = 'OWB1';
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '$stageName $distance HR<${stage.maxHeartRate}';
  }

  String _createBC2Description(WorkoutStageBC2 stage) {
    const String stageName = 'BC2';
    final String distance = stage.distanceInKilometers.toKilometersFormat();
    return '$stageName $distance HR<${stage.maxHeartRate}';
  }

  String _createBC3Description(WorkoutStageBC3 stage) {
    const String stageName = 'BC3';
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

  String _createStrengthDescription(
    BuildContext context,
    WorkoutStageStrength stage,
  ) {
    final String stageName = AppLocalizations.of(context)!.workout_strength;
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
}
