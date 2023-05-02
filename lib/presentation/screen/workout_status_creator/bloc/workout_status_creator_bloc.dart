import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout_status.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';

part 'workout_status_creator_event.dart';
part 'workout_status_creator_state.dart';

class WorkoutStatusCreatorBloc extends BlocWithStatus<WorkoutStatusCreatorEvent,
    WorkoutStatusCreatorState, dynamic, dynamic> {
  WorkoutStatusCreatorBloc({
    BlocStatus status = const BlocStatusInitial(),
    Pace? averagePace,
  }) : super(
          WorkoutStatusCreatorState(
            status: status,
            averagePace: averagePace,
          ),
        ) {
    on<WorkoutStatusCreatorEventWorkoutStatusTypeChanged>(
      _workoutStatusTypeChanged,
    );
    on<WorkoutStatusCreatorEventCoveredDistanceInKmChanged>(
      _coveredDistanceInKmChanged,
    );
    on<WorkoutStatusCreatorEventMoodRateChanged>(_moodRateChanged);
    on<WorkoutStatusCreatorEventAvgPaceMinutesChanged>(_avgPaceMinutesChanged);
    on<WorkoutStatusCreatorEventAvgPaceSecondsChanged>(_avgPaceSecondsChanged);
    on<WorkoutStatusCreatorEventAvgHeartRateChanged>(_avgHeartRateChanged);
  }

  void _workoutStatusTypeChanged(
    WorkoutStatusCreatorEventWorkoutStatusTypeChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      workoutStatusType: event.workoutStatusType,
    ));
  }

  void _coveredDistanceInKmChanged(
    WorkoutStatusCreatorEventCoveredDistanceInKmChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      coveredDistanceInKm: event.coveredDistanceInKm,
    ));
  }

  void _moodRateChanged(
    WorkoutStatusCreatorEventMoodRateChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      moodRate: event.moodRate,
    ));
  }

  void _avgPaceMinutesChanged(
    WorkoutStatusCreatorEventAvgPaceMinutesChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePace: Pace(
        minutes: event.minutes,
        seconds: state.averagePace?.seconds ?? 0,
      ),
    ));
  }

  void _avgPaceSecondsChanged(
    WorkoutStatusCreatorEventAvgPaceSecondsChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averagePace: Pace(
        minutes: state.averagePace?.minutes ?? 0,
        seconds: event.seconds,
      ),
    ));
  }

  void _avgHeartRateChanged(
    WorkoutStatusCreatorEventAvgHeartRateChanged event,
    Emitter<WorkoutStatusCreatorState> emit,
  ) {
    emit(state.copyWith(
      averageHeartRate: event.averageHeartRate,
    ));
  }
}
