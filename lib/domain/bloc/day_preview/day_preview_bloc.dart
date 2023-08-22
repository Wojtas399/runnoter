import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/health_measurement.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/health_measurement_repository.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';

part 'day_preview_event.dart';
part 'day_preview_state.dart';

class DayPreviewBloc extends BlocWithStatus<DayPreviewEvent, DayPreviewState,
    DayPreviewBlocInfo, dynamic> {
  final HealthMeasurementRepository _healthMeasurementRepository;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateService _dateService;
  final String _userId;
  final DateTime date;

  DayPreviewBloc({
    required String userId,
    required this.date,
    DayPreviewState state = const DayPreviewState(status: BlocStatusInitial()),
  })  : _healthMeasurementRepository = getIt<HealthMeasurementRepository>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateService = getIt<DateService>(),
        _userId = userId,
        super(state) {
    on<DayPreviewEventInitialize>(_initialize, transformer: restartable());
    on<DayPreviewEventRemoveHealthMeasurement>(_removeHealthMeasurement);
  }

  Future<void> _initialize(
    DayPreviewEventInitialize event,
    Emitter<DayPreviewState> emit,
  ) async {
    final bool isPastDay = date.isBefore(_dateService.getToday());
    final Stream<_ListenedParams> stream$ = Rx.combineLatest3(
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
        workouts: workouts,
        races: races,
      ),
    );
    await emit.forEach(
      stream$,
      onData: (_ListenedParams params) => state.copyWith(
        isPastDay: isPastDay,
        healthMeasurement: params.healthMeasurement,
        healthMeasurementAsNull: params.healthMeasurement == null,
        workouts: params.workouts,
        races: params.races,
      ),
    );
  }

  Future<void> _removeHealthMeasurement(
    DayPreviewEventRemoveHealthMeasurement event,
    Emitter<DayPreviewState> emit,
  ) async {
    if (state.healthMeasurement == null) return;
    emitLoadingStatus(emit);
    await _healthMeasurementRepository.deleteMeasurement(
      userId: _userId,
      date: state.healthMeasurement!.date,
    );
    emitCompleteStatus(emit, info: DayPreviewBlocInfo.healthMeasurementDeleted);
  }
}

enum DayPreviewBlocInfo { healthMeasurementDeleted }

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
