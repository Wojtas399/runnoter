import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../common/date_service.dart';
import '../../common/workout_stage_service.dart';
import '../../dependency_injection.dart';
import '../additional_model/calendar_date_range_data.dart';
import '../entity/health_measurement.dart';
import '../entity/race.dart';
import '../entity/workout.dart';
import '../repository/health_measurement_repository.dart';
import '../repository/race_repository.dart';
import '../repository/workout_repository.dart';
import '../service/auth_service.dart';

class CurrentWeekCubit extends Cubit<CalendarDateRangeData?> {
  final DateService _dateService;
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  StreamSubscription<CalendarDateRangeData>? _dateRangeDataListener;

  CurrentWeekCubit({
    CalendarDateRangeData? dateRangeData,
  })  : _dateService = getIt<DateService>(),
        _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        super(dateRangeData);

  int? get numberOfActivities =>
      (state?.workouts.length ?? 0) + (state?.races.length ?? 0);

  double? get scheduledTotalDistance => _calculateScheduledTotalDistance();

  double? get coveredTotalDistance => _calculateCoveredTotalDistance();

  @override
  Future<void> close() {
    _dateRangeDataListener?.cancel();
    _dateRangeDataListener = null;
    return super.close();
  }

  void initialize() {
    final DateTime today = _dateService.getToday();
    final DateTime firstDayOfTheWeek = _dateService.getFirstDayOfTheWeek(today);
    final DateTime lastDayOfTheWeek = _dateService.getLastDayOfTheWeek(today);
    _dateRangeDataListener ??= _authService.loggedUserId$
        .whereType<String>()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest3(
            _healthMeasurementRepository.getMeasurementsByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
            ),
            _workoutRepository.getWorkoutsByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
            ),
            _raceRepository.getRacesByDateRange(
              userId: loggedUserId,
              startDate: firstDayOfTheWeek,
              endDate: lastDayOfTheWeek,
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
          ),
        )
        .listen((CalendarDateRangeData dateRangeData) => emit(dateRangeData));
  }

  double _calculateScheduledTotalDistance() {
    if (state == null) return 0;
    final double workoutsDistance = state!.workouts
        .map(
          (workout) => workout.stages.map(calculateDistanceOfWorkoutStage).sum,
        )
        .sum;
    final double racesDistance =
        state!.races.map((Race race) => race.distance).sum;
    return workoutsDistance + racesDistance;
  }

  double _calculateCoveredTotalDistance() {
    if (state == null) return 0;
    final double workoutsCoveredDistance =
        state!.workouts.map((workout) => workout.coveredDistance).sum;
    final double racesCoveredDistance =
        state!.races.map((race) => race.coveredDistance).sum;
    return workoutsCoveredDistance + racesCoveredDistance;
  }
}
