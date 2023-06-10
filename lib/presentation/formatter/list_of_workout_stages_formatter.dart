import 'package:flutter/cupertino.dart';

import '../../domain/entity/workout_stage.dart';
import '../service/workout_stage_service.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toTotalDistanceDescription(BuildContext context) {
    double totalDistance = 0;
    List<String> stageDistanceDescriptions = [];
    for (final stage in this) {
      final double stageDistance = calculateDistanceOfWorkoutStage(stage);
      totalDistance += stageDistance;
      if (stage is DistanceWorkoutStage) {
        stageDistanceDescriptions.add(
          '${stage.toTypeName(context)} ${stage.distanceInKilometers} km',
        );
      } else if (stage is SeriesWorkoutStage) {
        stageDistanceDescriptions.add(
          '${stage.toTypeName(context)} $stageDistance km',
        );
      }
    }
    return '$totalDistance km (${stageDistanceDescriptions.join(' + ')})';
  }
}
