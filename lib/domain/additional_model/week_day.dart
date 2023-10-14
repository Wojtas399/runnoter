import 'package:equatable/equatable.dart';

import '../../data/entity/health_measurement.dart';
import '../../data/entity/race.dart';
import '../entity/workout.dart';

class WeekDay extends Equatable {
  final DateTime date;
  final bool isDisabled;
  final bool isTodayDay;
  final HealthMeasurement? healthMeasurement;
  final List<Workout> workouts;
  final List<Race> races;

  const WeekDay({
    required this.date,
    this.isDisabled = false,
    this.isTodayDay = false,
    this.healthMeasurement,
    this.workouts = const [],
    this.races = const [],
  });

  @override
  List<Object?> get props => [
        date,
        isDisabled,
        isTodayDay,
        healthMeasurement,
        workouts,
        races,
      ];
}
