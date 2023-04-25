import 'package:flutter/cupertino.dart';

import '../../domain/model/workout_stage.dart';
import '../service/workout_stage_service.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toTotalDistanceDescription(BuildContext context) {
    double totalDistance = 0;
    List<String> stageDistanceDescriptions = [];
    for (final stage in this) {
      if (stage is DistanceWorkoutStage) {
        totalDistance += stage.distanceInKilometers;
        stageDistanceDescriptions.add(
          '${stage.toTypeName(context)} ${stage.distanceInKilometers} km',
        );
      } else if (stage is SeriesWorkoutStage) {
        final stageTotalDistance =
            calculateTotalDistanceInKmOfSeriesWorkout(stage);
        totalDistance += stageTotalDistance;
        stageDistanceDescriptions.add(
          '${stage.toTypeName(context)} $stageTotalDistance km',
        );
      }
    }
    return '$totalDistance km (${stageDistanceDescriptions.join(' + ')})';
  }
}
