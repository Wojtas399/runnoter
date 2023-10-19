import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/model/health_measurement.dart';
import '../../data/model/race.dart';
import '../../data/model/workout.dart';
import '../../data/repository/health_measurement/health_measurement_repository.dart';
import '../../data/repository/race/race_repository.dart';
import '../../data/repository/workout/workout_repository.dart';
import '../../dependency_injection.dart';
import '../service/workout_stage_service.dart';

class CalendarUserDataCubit extends Cubit<CalendarUserData?> {
  final String userId;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  StreamSubscription<CalendarUserData?>? _listener;

  CalendarUserDataCubit({
    required this.userId,
    CalendarUserData? initialUserData,
  })  : _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(initialUserData);

  int? get numberOfActivities =>
      state == null ? null : state!.workouts.length + state!.races.length;

  double? get scheduledTotalDistance => _calculateScheduledTotalDistance();

  double? get coveredTotalDistance => _calculateCoveredTotalDistance();

  @override
  Future<void> close() {
    _disposeListener();
    return super.close();
  }

  void dateRangeChanged({
    required final DateTime? startDate,
    required final DateTime? endDate,
  }) {
    _disposeListener();
    if (startDate != null && endDate != null) {
      _setDataListener(startDate, endDate);
    }
  }

  Future<void> refresh({
    required final DateTime startDate,
    required final DateTime endDate,
  }) async {
    await _workoutRepository.refreshWorkoutsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    await _raceRepository.refreshRacesByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
    await _healthMeasurementRepository.refreshMeasurementsByDateRange(
      startDate: startDate,
      endDate: endDate,
      userId: userId,
    );
  }

  void _setDataListener(DateTime startDate, DateTime endDate) {
    _listener ??= Rx.combineLatest3(
      _healthMeasurementRepository.getMeasurementsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      ),
      _workoutRepository.getWorkoutsByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      ),
      _raceRepository.getRacesByDateRange(
        startDate: startDate,
        endDate: endDate,
        userId: userId,
      ),
      (
        List<HealthMeasurement>? healthMeasurements,
        List<Workout>? workouts,
        List<Race>? races,
      ) =>
          CalendarUserData(
        healthMeasurements: [...?healthMeasurements],
        workouts: [...?workouts],
        races: [...?races],
      ),
    ).listen((CalendarUserData? userData) => emit(userData));
  }

  void _disposeListener() {
    _listener?.cancel();
    _listener = null;
  }

  double? _calculateScheduledTotalDistance() {
    if (state == null) return null;
    final double workoutsDistance = state!.workouts
        .map(
          (workout) => workout.stages.map(calculateDistanceOfWorkoutStage).sum,
        )
        .sum;
    final double racesDistance =
        state!.races.map((Race race) => race.distance).sum;
    return workoutsDistance + racesDistance;
  }

  double? _calculateCoveredTotalDistance() {
    if (state == null) return null;
    final double workoutsCoveredDistance =
        state!.workouts.map((workout) => workout.coveredDistance).sum;
    final double racesCoveredDistance =
        state!.races.map((race) => race.coveredDistance).sum;
    return workoutsCoveredDistance + racesCoveredDistance;
  }
}

class CalendarUserData extends Equatable {
  final List<HealthMeasurement> healthMeasurements;
  final List<Workout> workouts;
  final List<Race> races;

  const CalendarUserData({
    required this.healthMeasurements,
    required this.workouts,
    required this.races,
  });

  @override
  List<Object?> get props => [healthMeasurements, workouts, races];
}
