import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../dependency_injection.dart';
import '../entity/health_measurement.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/health_measurement_repository.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';

class DayPreviewCubit extends Cubit<DayPreviewState?> {
  final String _userId;
  final DateTime date;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateService _dateService;
  StreamSubscription<DayPreviewState?>? _listener;

  DayPreviewCubit({
    required String userId,
    required this.date,
    DayPreviewState? state,
  })  : _userId = userId,
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateService = getIt<DateService>(),
        super(state);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  bool get isPastDate => date.isBefore(_dateService.getToday());

  void initialize() {
    _listener ??= Rx.combineLatest3(
      _healthMeasurementRepository.getMeasurementByDate(
        date: date,
        userId: _userId,
      ),
      _workoutRepository.getWorkoutsByDate(date: date, userId: _userId),
      _raceRepository.getRacesByDate(date: date, userId: _userId),
      (
        HealthMeasurement? healthMeasurement,
        List<Workout>? workouts,
        List<Race>? races,
      ) =>
          healthMeasurement == null && workouts == null && races == null
              ? null
              : DayPreviewState(
                  healthMeasurement: healthMeasurement,
                  workouts: [...?workouts],
                  races: [...?races],
                ),
    ).listen((DayPreviewState? state) => emit(state));
  }
}

class DayPreviewState extends Equatable {
  final HealthMeasurement? healthMeasurement;
  final List<Workout> workouts;
  final List<Race> races;

  const DayPreviewState({
    required this.healthMeasurement,
    required this.workouts,
    required this.races,
  });

  @override
  List<Object?> get props => [healthMeasurement, workouts, races];
}
