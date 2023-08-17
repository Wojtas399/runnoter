import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';

enum WorkoutsRange { week, month }

class ClientWorkoutsState extends BlocState<ClientWorkoutsState> {
  final WorkoutsRange range;
  final List<Workout> workouts;
  final List<Race> races;

  const ClientWorkoutsState({
    required super.status,
    this.range = WorkoutsRange.week,
    this.workouts = const [],
    this.races = const [],
  });

  @override
  List<Object?> get props => [status, range, workouts, races];

  @override
  ClientWorkoutsState copyWith({
    BlocStatus? status,
    WorkoutsRange? range,
    List<Workout>? workouts,
    List<Race>? races,
  }) =>
      ClientWorkoutsState(
        status: status ?? const BlocStatusComplete(),
        range: range ?? this.range,
        workouts: workouts ?? this.workouts,
        races: races ?? this.races,
      );
}
