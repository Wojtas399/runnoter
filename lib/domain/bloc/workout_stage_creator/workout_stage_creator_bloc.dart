import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/workout_stage.dart';

part 'workout_stage_creator_distance_stage_form.dart';
part 'workout_stage_creator_event.dart';
part 'workout_stage_creator_series_stage_form.dart';
part 'workout_stage_creator_state.dart';

class WorkoutStageCreatorBloc
    extends Bloc<WorkoutStageCreatorEvent, WorkoutStageCreatorState> {
  final WorkoutStage? _originalStage;

  WorkoutStageCreatorBloc({
    required WorkoutStage? originalStage,
    WorkoutStageCreatorState state = const WorkoutStageCreatorStateInProgress(
      stageType: null,
      form: null,
    ),
  })  : _originalStage = originalStage,
        super(state) {
    on<WorkoutStageCreatorEventStageTypeChanged>(_stageTypeChanged);
    on<WorkoutStageCreatorEventDistanceChanged>(_distanceChanged);
    on<WorkoutStageCreatorEventMaxHeartRateChanged>(_maxHeartRateChanged);
    on<WorkoutStageCreatorEventAmountOfSeriesChanged>(_amountOfSeriesChanged);
    on<WorkoutStageCreatorEventSeriesDistanceChanged>(_seriesDistanceChanged);
    on<WorkoutStageCreatorEventWalkingDistanceChanged>(_walkingDistanceChanged);
    on<WorkoutStageCreatorEventJoggingDistanceChanged>(_joggingDistanceChanged);
    on<WorkoutStageCreatorEventSubmit>(_submit);
  }

  void _stageTypeChanged(
    WorkoutStageCreatorEventStageTypeChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageType stageType = event.stageType;
    WorkoutStageCreatorForm? form;
    if (_isDistanceStage(stageType) &&
        (_originalStage is DistanceWorkoutStage || _originalStage == null)) {
      form = WorkoutStageCreatorDistanceStageForm(
        originalStage: _originalStage as DistanceWorkoutStage?,
        distanceInKm: null,
        maxHeartRate: null,
      );
    } else if (_isSeriesStage(stageType) &&
        (_originalStage is SeriesWorkoutStage || _originalStage == null)) {
      form = WorkoutStageCreatorSeriesStageForm(
        originalStage: _originalStage as SeriesWorkoutStage?,
        amountOfSeries: null,
        seriesDistanceInMeters: null,
        walkingDistanceInMeters: null,
        joggingDistanceInMeters: null,
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
            walkingDistanceInMeters: event.walkingDistanceInMeters,
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
            joggingDistanceInMeters: event.joggingDistanceInMeters,
          ),
        ));
      }
    }
  }

  void _submit(
    WorkoutStageCreatorEventSubmit event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    final WorkoutStageCreatorState state = this.state;
    if (state is WorkoutStageCreatorStateInProgress) {
      final WorkoutStage? workoutStage = _mapFormToWorkoutStage(
        state.stageType,
        state.form,
      );
      if (workoutStage != null) {
        emit(
          WorkoutStageCreatorStateSubmitted(
            workoutStage: workoutStage,
          ),
        );
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

  WorkoutStage? _mapFormToWorkoutStage(
    WorkoutStageType? stageType,
    WorkoutStageCreatorForm? form,
  ) {
    if (stageType == null) return null;
    if (form is WorkoutStageCreatorDistanceStageForm) {
      return _mapDistanceStageFormToWorkoutStage(stageType, form);
    } else if (form is WorkoutStageCreatorSeriesStageForm) {
      return _mapSeriesStageFormToWorkoutStage(stageType, form);
    }
    return null;
  }

  WorkoutStage? _mapDistanceStageFormToWorkoutStage(
    WorkoutStageType stageType,
    WorkoutStageCreatorDistanceStageForm distanceStageForm,
  ) {
    final double? distanceInKilometers = distanceStageForm.distanceInKm;
    final int? maxHeartRate = distanceStageForm.maxHeartRate;
    if (distanceInKilometers == null || maxHeartRate == null) {
      return null;
    }
    if (stageType == WorkoutStageType.baseRun) {
      return WorkoutStageBaseRun(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    } else if (stageType == WorkoutStageType.zone2) {
      return WorkoutStageZone2(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    } else if (stageType == WorkoutStageType.zone3) {
      return WorkoutStageZone3(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    }
    return null;
  }

  WorkoutStage? _mapSeriesStageFormToWorkoutStage(
    WorkoutStageType stageType,
    WorkoutStageCreatorSeriesStageForm seriesStageForm,
  ) {
    final int? amountOfSeries = seriesStageForm.amountOfSeries;
    final int? seriesDistanceInMeters = seriesStageForm.seriesDistanceInMeters;
    final int? walkingDistanceInMeters =
        seriesStageForm.walkingDistanceInMeters;
    final int? joggingDistanceInMeters =
        seriesStageForm.joggingDistanceInMeters;
    if (amountOfSeries == null ||
        seriesDistanceInMeters == null ||
        (walkingDistanceInMeters == null && joggingDistanceInMeters == null)) {
      return null;
    }
    if (stageType == WorkoutStageType.hillRepeats) {
      return WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters ?? 0,
        joggingDistanceInMeters: joggingDistanceInMeters ?? 0,
      );
    } else if (stageType == WorkoutStageType.rhythms) {
      return WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters ?? 0,
        joggingDistanceInMeters: joggingDistanceInMeters ?? 0,
      );
    }
    return null;
  }
}
