import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../additional_model/calendar_date_range_data.dart';
import '../entity/health_measurement.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/health_measurement_repository.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';

class CalendarDateRangeDataCubit extends Cubit<CalendarDateRangeData> {
  final String userId;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  StreamSubscription<CalendarDateRangeData>? _listener;

  CalendarDateRangeDataCubit({required this.userId})
      : _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(const CalendarDateRangeData(
          healthMeasurements: [],
          workouts: [],
          races: [],
        ));

  @override
  Future<void> close() {
    _disposeListener();
    return super.close();
  }

  void dateRangeChanged({
    required final DateTime startDate,
    required final DateTime endDate,
  }) {
    _disposeListener();
    _setDataListener(startDate, endDate);
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
          CalendarDateRangeData(
        healthMeasurements: [...?healthMeasurements],
        workouts: [...?workouts],
        races: [...?races],
      ),
    ).listen((CalendarDateRangeData dateRangeData) => emit(dateRangeData));
  }

  void _disposeListener() {
    _listener?.cancel();
    _listener = null;
  }
}
