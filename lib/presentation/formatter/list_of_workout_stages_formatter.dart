import 'package:flutter/cupertino.dart';

import '../../domain/entity/workout_stage.dart';
import '../extension/context_extensions.dart';
import '../service/workout_stage_service.dart';
import 'distance_unit_formatter.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toTotalDistanceDescription(BuildContext context) {
    final String distanceUnit = context.distanceUnit.toUIShortFormat();
    double totalDistance = 0;
    List<String> stageDescriptions = [];
    for (final stage in this) {
      final double stageDistanceInKm = calculateDistanceOfWorkoutStage(stage);
      final double convertedStageDistance = double.parse(
        context
            .convertDistanceFromDefaultUnit(stageDistanceInKm)
            .toStringAsFixed(2),
      );
      totalDistance += convertedStageDistance;
      stageDescriptions.add(
        '${stage.toTypeName(context)} $convertedStageDistance$distanceUnit',
      );
    }
    return '$totalDistance$distanceUnit (${stageDescriptions.join(' + ')})';
  }
}
