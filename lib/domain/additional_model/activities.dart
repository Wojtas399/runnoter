import 'package:equatable/equatable.dart';

import '../entity/race.dart';
import '../entity/workout.dart';

class Activities extends Equatable {
  final List<Workout>? workouts;
  final List<Race>? races;

  const Activities({this.workouts, this.races});

  @override
  List<Object?> get props => [workouts, races];
}
