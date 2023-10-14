import 'package:equatable/equatable.dart';

import '../../data/entity/health_measurement.dart';
import '../../data/entity/race.dart';
import '../../data/entity/workout.dart';

class CalendarUserData extends Equatable {
  final List<HealthMeasurement> healthMeasurements;
  final List<Workout> workouts;
  final List<Race> races;

  const CalendarUserData({
    required this.healthMeasurements,
    required this.workouts,
    required this.races,
  });

  @override
  List<Object?> get props => [healthMeasurements, workouts, races];
}
