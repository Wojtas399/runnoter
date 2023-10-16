import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/entity/workout.dart';

part 'workout_stage_creator_distance_form.dart';
part 'workout_stage_creator_series_form.dart';
part 'workout_stage_creator_state.dart';

class WorkoutStageCreatorCubit extends Cubit<WorkoutStageCreatorState> {
  final WorkoutStage? _originalStage;

  WorkoutStageCreatorCubit({
    WorkoutStage? originalStage,
    WorkoutStageCreatorState initialState = const WorkoutStageCreatorState(),
  })  : _originalStage = originalStage,
        super(initialState);

  void initialize() {
    if (_originalStage == null) return;
    if (_originalStage is DistanceWorkoutStage) {
      final distanceStage = _originalStage as DistanceWorkoutStage;
      final workoutStageType = _mapWorkoutStageToStageType(distanceStage);
      emit(state.copyWith(
        originalStageType: workoutStageType,
        stageType: workoutStageType,
        distanceForm: WorkoutStageCreatorDistanceForm(
          originalStage: distanceStage,
          distanceInKm: distanceStage.distanceInKm,
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

  void stageTypeChanged(WorkoutStageType? workoutStageType) {
    emit(state.copyWith(stageType: workoutStageType));
  }

  void distanceChanged(double distanceInKm) {
    emit(state.copyWith(
      distanceForm: state.distanceForm.copyWith(distanceInKm: distanceInKm),
    ));
  }

  void maxHeartRateChanged(int maxHeartRate) {
    emit(state.copyWith(
      distanceForm: state.distanceForm.copyWith(maxHeartRate: maxHeartRate),
    ));
  }

  void amountOfSeriesChanged(int amountOfSeries) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(amountOfSeries: amountOfSeries),
    ));
  }

  void seriesDistanceChanged(int seriesDistanceInMeters) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        seriesDistanceInMeters: seriesDistanceInMeters,
      ),
    ));
  }

  void walkingDistanceChanged(int walkingDistanceInMeters) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        walkingDistanceInMeters: walkingDistanceInMeters,
      ),
    ));
  }

  void joggingDistanceChanged(int joggingDistanceInMeters) {
    emit(state.copyWith(
      seriesForm: state.seriesForm.copyWith(
        joggingDistanceInMeters: joggingDistanceInMeters,
      ),
    ));
  }

  void submit() {
    WorkoutStage? workoutStage;
    if (state.isDistanceStage) {
      workoutStage = _mapDistanceFormToWorkoutStage();
    } else if (state.isSeriesStage) {
      workoutStage = _mapSeriesFormToWorkoutStage();
    }
    if (workoutStage != null) {
      emit(state.copyWith(stageToAdd: workoutStage));
    }
  }

  WorkoutStageType _mapWorkoutStageToStageType(
    WorkoutStage stage,
  ) =>
      switch (stage) {
        WorkoutStageCardio() => WorkoutStageType.cardio,
        WorkoutStageZone2() => WorkoutStageType.zone2,
        WorkoutStageZone3() => WorkoutStageType.zone3,
        WorkoutStageHillRepeats() => WorkoutStageType.hillRepeats,
        WorkoutStageRhythms() => WorkoutStageType.rhythms,
      };

  WorkoutStage? _mapDistanceFormToWorkoutStage() {
    final form = state.distanceForm;
    final double? distanceInKm = form.distanceInKm;
    final int? maxHeartRate = form.maxHeartRate;
    if (distanceInKm == null || maxHeartRate == null) {
      return null;
    }
    if (state.stageType == WorkoutStageType.cardio) {
      return WorkoutStageCardio(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
    } else if (state.stageType == WorkoutStageType.zone2) {
      return WorkoutStageZone2(
        distanceInKm: distanceInKm,
        maxHeartRate: maxHeartRate,
      );
    } else if (state.stageType == WorkoutStageType.zone3) {
      return WorkoutStageZone3(
        distanceInKm: distanceInKm,
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
