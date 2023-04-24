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
    on<WorkoutStageCreatorEventSubmit>(_submit);
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
    if (stageType == null) {
      return null;
    }
    if (form is WorkoutStageCreatorDistanceStageForm) {
      return _mapDistanceStageFormToWorkoutStage(stageType, form);
    } else if (form is WorkoutStageCreatorSeriesStageForm) {
      return _mapSeriesStageFormToWorkoutStage(stageType, form);
    } else {
      return _mapNoFormStageToWorkoutStage(stageType);
    }
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
    final int? breakWalkingDistanceInMeters =
        seriesStageForm.breakWalkingDistanceInMeters;
    final int? breakJoggingDistanceInMeters =
        seriesStageForm.breakJoggingDistanceInMeters;
    if (amountOfSeries == null ||
        seriesDistanceInMeters == null ||
        (breakWalkingDistanceInMeters == null &&
            breakJoggingDistanceInMeters == null)) {
      return null;
    }
    if (stageType == WorkoutStageType.hillRepeats) {
      return WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakWalkingDistanceInMeters ?? 0,
        breakJogDistanceInMeters: breakJoggingDistanceInMeters ?? 0,
      );
    } else if (stageType == WorkoutStageType.rhythms) {
      return WorkoutStageRhythms(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        breakMarchDistanceInMeters: breakWalkingDistanceInMeters ?? 0,
        breakJogDistanceInMeters: breakJoggingDistanceInMeters ?? 0,
      );
    }
    return null;
  }

  WorkoutStage? _mapNoFormStageToWorkoutStage(
    WorkoutStageType stageType,
  ) {
    if (stageType == WorkoutStageType.stretching) {
      return const WorkoutStageStretching();
    } else if (stageType == WorkoutStageType.strengthening) {
      return const WorkoutStageStrengthening();
    } else if (stageType == WorkoutStageType.foamRolling) {
      return const WorkoutStageFoamRolling();
    }
    return null;
  }
}
