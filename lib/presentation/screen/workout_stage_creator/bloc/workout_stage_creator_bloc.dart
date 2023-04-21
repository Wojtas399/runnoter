import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/model/workout_stage.dart';

part 'workout_stage_creator_distance_stage_form.dart';
part 'workout_stage_creator_event.dart';
part 'workout_stage_creator_series_stage_form.dart';
part 'workout_stage_creator_state.dart';

class WorkoutStageCreatorBloc
    extends Bloc<WorkoutStageCreatorEvent, WorkoutStageCreatorState> {
  WorkoutStageCreatorBloc({
    WorkoutStageType? stageType,
    WorkoutStageCreatorForm? form,
  }) : super(
          WorkoutStageCreatorStateInProgress(
            stageType: stageType,
            form: form,
          ),
        ) {
    on<WorkoutStageCreatorEventStageTypeChanged>(_stageTypeChanged);
    on<WorkoutStageCreatorEventDistanceChanged>(_distanceChanged);
    on<WorkoutStageCreatorEventMaxHeartRateChanged>(_maxHeartRateChanged);
    on<WorkoutStageCreatorEventAmountOfSeriesChanged>(_amountOfSeriesChanged);
    on<WorkoutStageCreatorEventSeriesDistanceChanged>(_seriesDistanceChanged);
    on<WorkoutStageCreatorEventWalkingDistanceChanged>(_walkingDistanceChanged);
    on<WorkoutStageCreatorEventJoggingDistanceChanged>(_joggingDistanceChanged);
  }

  void _stageTypeChanged(
    WorkoutStageCreatorEventStageTypeChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageType stageType = event.stageType;
    WorkoutStageCreatorForm? form;
    if (_isDistanceStage(stageType)) {
      form = const WorkoutStageCreatorDistanceStageForm(
        distanceInKm: null,
        maxHeartRate: null,
      );
    } else if (_isSeriesStage(stageType)) {
      form = const WorkoutStageCreatorSeriesStageForm(
        amountOfSeries: null,
        seriesDistanceInMeters: null,
        breakWalkingDistanceInMeters: null,
        breakJoggingDistanceInMeters: null,
      );
    }
    emit(WorkoutStageCreatorStateInProgress(
      stageType: stageType,
      form: form,
    ));
  }

  void _distanceChanged(
    WorkoutStageCreatorEventDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorDistanceStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            distanceInKm: event.distanceInKm,
          ),
        ));
      }
    }
  }

  void _maxHeartRateChanged(
    WorkoutStageCreatorEventMaxHeartRateChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorDistanceStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            maxHeartRate: event.maxHeartRate,
          ),
        ));
      }
    }
  }

  void _amountOfSeriesChanged(
    WorkoutStageCreatorEventAmountOfSeriesChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorSeriesStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            amountOfSeries: event.amountOfSeries,
          ),
        ));
      }
    }
  }

  void _seriesDistanceChanged(
    WorkoutStageCreatorEventSeriesDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorSeriesStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            seriesDistanceInMeters: event.seriesDistanceInMeters,
          ),
        ));
      }
    }
  }

  void _walkingDistanceChanged(
    WorkoutStageCreatorEventWalkingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorSeriesStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            breakWalkingDistanceInMeters: event.walkingDistanceInMeters,
          ),
        ));
      }
    }
  }

  void _joggingDistanceChanged(
    WorkoutStageCreatorEventJoggingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStageCreatorForm? form = state.form;
      if (form is WorkoutStageCreatorSeriesStageForm) {
        emit(state.copyWith(
          form: form.copyWith(
            breakJoggingDistanceInMeters: event.joggingDistanceInMeters,
          ),
        ));
      }
    }
  }

  bool _isDistanceStage(WorkoutStageType stage) {
    return stage == WorkoutStageType.baseRun ||
        stage == WorkoutStageType.zone2 ||
        stage == WorkoutStageType.zone3;
  }

  bool _isSeriesStage(WorkoutStageType stage) {
    return stage == WorkoutStageType.hillRepeats ||
        stage == WorkoutStageType.rhythms;
  }
}
