import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../common/date_service.dart';
import '../../../../../data/entity/health_measurement.dart';
import '../../../../../data/entity/race.dart';
import '../../../../../data/entity/workout.dart';
import '../../../../../data/interface/repository/health_measurement_repository.dart';
import '../../../../../data/interface/repository/race_repository.dart';
import '../../../../../data/interface/repository/workout_repository.dart';
import '../../../../../data/interface/service/auth_service.dart';
import '../../../../../dependency_injection.dart';

part 'day_preview_state.dart';

class DayPreviewCubit extends Cubit<DayPreviewState> {
  final AuthService _authService;
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateService _dateService;
  final String _userId;
  final DateTime date;
  StreamSubscription<_ListenedParams>? _listener;

  DayPreviewCubit({
    required String userId,
    required this.date,
    DayPreviewState initialState = const DayPreviewState(),
  })  : _authService = getIt<AuthService>(),
        _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateService = getIt<DateService>(),
        _userId = userId,
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    final bool isPastDate = date.isBefore(_dateService.getToday());
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
          _ListenedParams(
        healthMeasurement: healthMeasurement,
        workouts: workouts ?? [],
        races: races ?? [],
      ),
    ).listen(
      (_ListenedParams params) => emit(state.copyWith(
        isPastDate: isPastDate,
        canModifyHealthMeasurement: _userId == loggedUserId,
        healthMeasurement: params.healthMeasurement,
        healthMeasurementAsNull: params.healthMeasurement == null,
        workouts: params.workouts,
        races: params.races,
      )),
    );
  }

  Future<void> removeHealthMeasurement() async {
    if (state.healthMeasurement == null) return;
    await _healthMeasurementRepository.deleteMeasurement(
      userId: _userId,
      date: state.healthMeasurement!.date,
    );
  }
}

class _ListenedParams extends Equatable {
  final HealthMeasurement? healthMeasurement;
  final List<Workout>? workouts;
  final List<Race>? races;

  const _ListenedParams({
    required this.healthMeasurement,
    required this.workouts,
    required this.races,
  });

  @override
  List<Object?> get props => [healthMeasurement, workouts, races];
}
