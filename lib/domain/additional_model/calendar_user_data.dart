import 'package:equatable/equatable.dart';

import '../entity/health_measurement.dart';
import '../entity/race.dart';
import '../entity/workout.dart';

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
