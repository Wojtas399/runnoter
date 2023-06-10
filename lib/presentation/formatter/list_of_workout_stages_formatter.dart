import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/workout_stage.dart';
import '../../domain/service/distance_unit_service.dart';
import '../service/workout_stage_service.dart';
import 'distance_unit_formatter.dart';
import 'workout_stage_formatter.dart';

extension ListOfWorkoutStagesFormatter on List<WorkoutStage> {
  String toTotalDistanceDescription(BuildContext context) {
    final distanceUnitService = context.read<DistanceUnitService>();
    final String distanceUnit = distanceUnitService.state.toUIShortFormat();
    double totalDistance = 0;
    List<String> stageDescriptions = [];
    for (final stage in this) {
      final double stageDistanceInKm = calculateDistanceOfWorkoutStage(stage);
      final double convertedStageDistance = double.parse(
        distanceUnitService
            .convertFromDefault(stageDistanceInKm)
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
