import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entity/workout_stage.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';

part 'workout_stage_creator_distance_form.dart';
part 'workout_stage_creator_event.dart';
part 'workout_stage_creator_series_form.dart';
part 'workout_stage_creator_state.dart';

class WorkoutStageCreatorBloc
    extends Bloc<WorkoutStageCreatorEvent, WorkoutStageCreatorState> {
  final WorkoutStage? _originalStage;

  WorkoutStageCreatorBloc({
    required WorkoutStage? originalStage,
    WorkoutStageCreatorState state = const WorkoutStageCreatorState(
      status: BlocStatusInitial(),
    ),
  })  : _originalStage = originalStage,
        super(state) {
    on<WorkoutStageCreatorEventInitialize>(_initialize);
    on<WorkoutStageCreatorEventStageTypeChanged>(_stageTypeChanged);
    on<WorkoutStageCreatorEventDistanceChanged>(_distanceChanged);
    on<WorkoutStageCreatorEventMaxHeartRateChanged>(_maxHeartRateChanged);
    on<WorkoutStageCreatorEventAmountOfSeriesChanged>(_amountOfSeriesChanged);
    on<WorkoutStageCreatorEventSeriesDistanceChanged>(_seriesDistanceChanged);
    on<WorkoutStageCreatorEventWalkingDistanceChanged>(_walkingDistanceChanged);
    on<WorkoutStageCreatorEventJoggingDistanceChanged>(_joggingDistanceChanged);
    on<WorkoutStageCreatorEventSubmit>(_submit);
  }

  void _initialize(
    WorkoutStageCreatorEventInitialize event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    if (_originalStage == null) return;
    if (_originalStage is DistanceWorkoutStage) {
      final distanceStage = _originalStage as DistanceWorkoutStage;
      final workoutStageType = _mapWorkoutStageToStageType(distanceStage);
      emit(state.copyWith(
        originalStageType: workoutStageType,
        stageType: workoutStageType,
        distanceForm: WorkoutStageCreatorDistanceForm(
          originalStage: distanceStage,
          distanceInKm: distanceStage.distanceInKilometers,
          maxHeartRate: distanceStage.maxHeartRate,
        ),
      ));
    } else if (_originalStage is SeriesWorkoutStage) {
      final seriesStage = _originalStage as SeriesWorkoutStage;
      final workoutStageType = _mapWorkoutStageToStageType(seriesStage);
      emit(state.copyWith(
        originalStageType: workoutStageType,
        stageType: workoutStageType,
        seriesForm: WorkoutStageCreatorSeriesForm(
          originalStage: seriesStage,
          amountOfSeries: seriesStage.amountOfSeries,
          seriesDistanceInMeters: seriesStage.seriesDistanceInMeters,
          walkingDistanceInMeters: seriesStage.walkingDistanceInMeters,
          joggingDistanceInMeters: seriesStage.joggingDistanceInMeters,
        ),
      ));
    }
  }

  void _stageTypeChanged(
    WorkoutStageCreatorEventStageTypeChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      stageType: event.stageType,
    ));
  }

  void _distanceChanged(
    WorkoutStageCreatorEventDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      distanceForm: state.distanceForm.copyWith(
        distanceInKm: event.distanceInKm,
      ),
    ));
  }

  void _maxHeartRateChanged(
    WorkoutStageCreatorEventMaxHeartRateChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      distanceForm: state.distanceForm.copyWith(
        maxHeartRate: event.maxHeartRate,
      ),
    ));
  }

  void _amountOfSeriesChanged(
    WorkoutStageCreatorEventAmountOfSeriesChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        amountOfSeries: event.amountOfSeries,
      ),
    ));
  }

  void _seriesDistanceChanged(
    WorkoutStageCreatorEventSeriesDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        seriesDistanceInMeters: event.seriesDistanceInMeters,
      ),
    ));
  }

  void _walkingDistanceChanged(
    WorkoutStageCreatorEventWalkingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        walkingDistanceInMeters: event.walkingDistanceInMeters,
      ),
    ));
  }

  void _joggingDistanceChanged(
    WorkoutStageCreatorEventJoggingDistanceChanged event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        joggingDistanceInMeters: event.joggingDistanceInMeters,
      ),
    ));
  }

  void _submit(
    WorkoutStageCreatorEventSubmit event,
    Emitter<WorkoutStageCreatorState> emit,
  ) {
    WorkoutStage? workoutStage;
    if (state.isDistanceStage) {
      workoutStage = _mapDistanceFormToWorkoutStage();
    } else if (state.isSeriesStage) {
      workoutStage = _mapSeriesFormToWorkoutStage();
    }
    if (workoutStage != null) {
      emit(state.copyWith(
        stageToSubmit: workoutStage,
      ));
    }
  }

  WorkoutStageType _mapWorkoutStageToStageType(
    WorkoutStage stage,
  ) =>
      switch (stage) {
        WorkoutStageBaseRun() => WorkoutStageType.cardio,
        WorkoutStageZone2() => WorkoutStageType.zone2,
        WorkoutStageZone3() => WorkoutStageType.zone3,
        WorkoutStageHillRepeats() => WorkoutStageType.hillRepeats,
        WorkoutStageRhythms() => WorkoutStageType.rhythms,
      };

  WorkoutStage? _mapDistanceFormToWorkoutStage() {
    final form = state.distanceForm;
    final double? distanceInKilometers = form.distanceInKm;
    final int? maxHeartRate = form.maxHeartRate;
    if (distanceInKilometers == null || maxHeartRate == null) {
      return null;
    }
    if (state.stageType == WorkoutStageType.cardio) {
      return WorkoutStageBaseRun(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    } else if (state.stageType == WorkoutStageType.zone2) {
      return WorkoutStageZone2(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    } else if (state.stageType == WorkoutStageType.zone3) {
      return WorkoutStageZone3(
        distanceInKilometers: distanceInKilometers,
        maxHeartRate: maxHeartRate,
      );
    }
    return null;
  }

  WorkoutStage? _mapSeriesFormToWorkoutStage() {
    final WorkoutStageCreatorSeriesForm form = state.seriesForm;
    final int? amountOfSeries = form.amountOfSeries;
    final int? seriesDistanceInMeters = form.seriesDistanceInMeters;
    final int? walkingDistanceInMeters = form.walkingDistanceInMeters;
    final int? joggingDistanceInMeters = form.joggingDistanceInMeters;
    if (amountOfSeries == null ||
        seriesDistanceInMeters == null ||
        (walkingDistanceInMeters == null && joggingDistanceInMeters == null)) {
      return null;
    }
    if (state.stageType == WorkoutStageType.hillRepeats) {
      return WorkoutStageHillRepeats(
        amountOfSeries: amountOfSeries,
        seriesDistanceInMeters: seriesDistanceInMeters,
        walkingDistanceInMeters: walkingDistanceInMeters ?? 0,
        joggingDistanceInMeters: joggingDistanceInMeters ?? 0,
      );
    } else if (state.stageType == WorkoutStageType.rhythms) {
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
