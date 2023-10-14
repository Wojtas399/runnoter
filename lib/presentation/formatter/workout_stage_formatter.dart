import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/additional_model/workout_stage.dart';
import '../extension/context_extensions.dart';
import '../extension/double_extensions.dart';
import 'distance_unit_formatter.dart';
import 'string_formatter.dart';

extension WorkoutStageFormatter on WorkoutStage {
  String toUIFormat(BuildContext context) {
    final WorkoutStage stage = this;
    return switch (stage) {
      DistanceWorkoutStage() => _createDistanceStageDescription(context, stage),
      SeriesWorkoutStage() => _createSeriesStageDescription(context, stage),
    };
  }

  String toTypeName(BuildContext context) {
    final str = Str.of(context);
    return switch (this) {
      WorkoutStageCardio() => str.workoutStageCardio,
      WorkoutStageZone2() => str.workoutStageZone2,
      WorkoutStageZone3() => str.workoutStageZone3,
      WorkoutStageRhythms() => str.workoutStageRhythms,
      WorkoutStageHillRepeats() => str.workoutStageHillRepeats,
    };
  }

  String _createDistanceStageDescription(
    BuildContext context,
    DistanceWorkoutStage stage,
  ) {
    final double convertedDistance = context.convertDistanceFromDefaultUnit(
      stage.distanceInKm,
    );
    final String distanceUnit = context.distanceUnit.toUIShortFormat();
    final String distance =
        '${convertedDistance.decimal(2).toString().trimZeros()} $distanceUnit';
    return '${stage.toTypeName(context)} $distance, HR<${stage.maxHeartRate}';
  }

  String _createSeriesStageDescription(
    BuildContext context,
    SeriesWorkoutStage stage,
  ) {
    final str = Str.of(context);
    final String seriesDescription =
        '${stage.amountOfSeries}x${stage.seriesDistanceInMeters}m';
    String breakDescription = '${str.workoutStageBreak} ';
    if (stage.walkingDistanceInMeters > 0) {
      breakDescription += ' ${str.workoutStageWalking(
        stage.walkingDistanceInMeters,
      )}, ';
    }
    if (stage.joggingDistanceInMeters > 0) {
      breakDescription += str.workoutStageJogging(
        stage.joggingDistanceInMeters,
      );
    }
    return '${stage.toTypeName(context)} $seriesDescription, $breakDescription';
  }
}
