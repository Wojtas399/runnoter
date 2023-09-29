import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../common/workout_stage_service.dart';
import '../../domain/additional_model/workout_stage.dart';
import '../extension/context_extensions.dart';
import '../extension/double_extensions.dart';
import 'string_formatter.dart';
import 'distance_unit_formatter.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toUITotalDistance(BuildContext context) {
    final String distanceUnit = context.distanceUnit.toUIShortFormat();
    double totalDistance = map(
      (stage) => _calculateConvertedDistanceOfWorkoutStage(context, stage),
    ).sum;
    return '$totalDistance $distanceUnit';
  }

  String toUIDetailedTotalDistance(BuildContext context) {
    final String distanceUnit = context.distanceUnit.toUIShortFormat();
    double totalDistance = 0;
    List<String> stageDescriptions = [];
    for (final stage in this) {
      if (stage is DistanceWorkoutStage || stage is SeriesWorkoutStage) {
        final double convertedStageDistance =
            _calculateConvertedDistanceOfWorkoutStage(context, stage);
        final stageDistanceStr = convertedStageDistance.toString().trimZeros();
        totalDistance += convertedStageDistance;
        stageDescriptions.add(
          '${stage.toTypeName(context)} $stageDistanceStr $distanceUnit',
        );
      }
    }
    final totalDistanceStr = totalDistance.toString().trimZeros();
    String description = '$totalDistanceStr $distanceUnit';
    if (totalDistance > 0) {
      description += ' (${stageDescriptions.join(' + ')})';
    }
    return description;
  }

  double _calculateConvertedDistanceOfWorkoutStage(
    BuildContext context,
    WorkoutStage stage,
  ) {
    final double stageDistanceInKm = calculateDistanceOfWorkoutStage(stage);
    return context.convertDistanceFromDefaultUnit(stageDistanceInKm).decimal(2);
  }
}
