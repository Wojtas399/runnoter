import 'package:flutter/material.dart';

import '../../domain/entity/workout_stage.dart';
import '../extension/context_extensions.dart';
import '../extension/double_extensions.dart';
import '../extension/string_extensions.dart';
import '../service/workout_stage_service.dart';
import 'distance_unit_formatter.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toTotalDistanceDescription(BuildContext context) {
    final String distanceUnit = context.distanceUnit.toUIShortFormat();
    double totalDistance = 0;
    List<String> stageDescriptions = [];
    for (final stage in this) {
      if (stage is DistanceWorkoutStage || stage is SeriesWorkoutStage) {
        final double stageDistanceInKm = calculateDistanceOfWorkoutStage(stage);
        final double convertedStageDistance = context
            .convertDistanceFromDefaultUnit(stageDistanceInKm)
            .decimal(2);
        final stageDistanceStr = convertedStageDistance.toString().trimZeros();
        totalDistance += convertedStageDistance;
        stageDescriptions.add(
          '${stage.toTypeName(context)} $stageDistanceStr$distanceUnit',
        );
      }
    }
    final totalDistanceStr = totalDistance.toString().trimZeros();
    return '$totalDistanceStr$distanceUnit (${stageDescriptions.join(' + ')})';
  }
}
