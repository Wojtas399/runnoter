import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'workout_stage_creator_distance_stage_form.dart';
part 'workout_stage_creator_event.dart';
part 'workout_stage_creator_series_stage_form.dart';
part 'workout_stage_creator_state.dart';

class WorkoutStageCreatorBloc
    extends Bloc<WorkoutStageCreatorEvent, WorkoutStageCreatorState> {
  WorkoutStageCreatorBloc({
    WorkoutStage? stageType,
    WorkoutStageCreatorForm? form,
  }) : super(
          WorkoutStageCreatorState(
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
    final WorkoutStage stageType = event.stageType;
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
    emit(state.copyWith(
      stageType: stageType,
      form: form,
    ));
  }

  void _distanceChanged(
    WorkoutStageCreatorEventDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorDistanceStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          distanceInKm: event.distanceInKm,
        ),
      ));
    }
  }

  void _maxHeartRateChanged(
    WorkoutStageCreatorEventMaxHeartRateChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorDistanceStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          maxHeartRate: event.maxHeartRate,
        ),
      ));
    }
  }

  void _amountOfSeriesChanged(
    WorkoutStageCreatorEventAmountOfSeriesChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorSeriesStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          amountOfSeries: event.amountOfSeries,
        ),
      ));
    }
  }

  void _seriesDistanceChanged(
    WorkoutStageCreatorEventSeriesDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorSeriesStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          seriesDistanceInMeters: event.seriesDistanceInMeters,
        ),
      ));
    }
  }

  void _walkingDistanceChanged(
    WorkoutStageCreatorEventWalkingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorSeriesStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          breakWalkingDistanceInMeters: event.walkingDistanceInMeters,
        ),
      ));
    }
  }

  void _joggingDistanceChanged(
    WorkoutStageCreatorEventJoggingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorForm? form = state.form;
    if (form is WorkoutStageCreatorSeriesStageForm) {
      emit(state.copyWith(
        form: form.copyWith(
          breakJoggingDistanceInMeters: event.joggingDistanceInMeters,
        ),
      ));
    }
  }

  bool _isDistanceStage(WorkoutStage stage) {
    return stage == WorkoutStage.baseRun ||
        stage == WorkoutStage.zone2 ||
        stage == WorkoutStage.zone3;
  }

  bool _isSeriesStage(WorkoutStage stage) {
    return stage == WorkoutStage.hillRepeats || stage == WorkoutStage.rhythms;
  }
}
