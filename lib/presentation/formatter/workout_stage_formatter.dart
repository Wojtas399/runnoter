import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../domain/entity/workout_stage.dart';
import '../../domain/service/distance_unit_service.dart';
import 'distance_unit_formatter.dart';

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
      description = Str.of(context).workoutStageStretching;
    } else if (stage is WorkoutStageStrengthening) {
      description = Str.of(context).workoutStageStrengthening;
    } else if (stage is WorkoutStageFoamRolling) {
      description = Str.of(context).workoutStageFoamRolling;
    }
    return description;
  }

  String toTypeName(BuildContext context) {
    final str = Str.of(context);
    if (this is WorkoutStageBaseRun) {
      return str.workoutStageBaseRun;
    } else if (this is WorkoutStageZone2) {
      return str.workoutStageZone2;
    } else if (this is WorkoutStageZone3) {
      return str.workoutStageZone3;
    } else if (this is WorkoutStageRhythms) {
      return str.workoutStageRhythms;
    } else if (this is WorkoutStageHillRepeats) {
      return str.workoutStageHillRepeats;
    } else if (this is WorkoutStageStretching) {
      return str.workoutStageStretching;
    } else if (this is WorkoutStageStrengthening) {
      return str.workoutStageStrengthening;
    } else if (this is WorkoutStageFoamRolling) {
      return str.workoutStageFoamRolling;
    }
    return '';
  }

  String _createDistanceStageDescription(
    BuildContext context,
    DistanceWorkoutStage stage,
  ) {
    final distanceUnitService = context.read<DistanceUnitService>();
    final double convertedDistance = distanceUnitService.convertFromDefault(
      stage.distanceInKilometers,
    );
    final String distanceUnit = distanceUnitService.state.toUIShortFormat();
    final String distance =
        '${convertedDistance.toStringAsFixed(2)}$distanceUnit';
    return '${stage.toTypeName(context)} $distance HR<${stage.maxHeartRate}';
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
