import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../cubit/date_range_manager_cubit.dart';
import '../../entity/activity.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';

part 'mileage_stats_event.dart';
part 'mileage_stats_state.dart';

class MileageStatsBloc extends Bloc<MileageStatsEvent, MileageStatsState> {
  final String _userId;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateRangeManagerCubit _dateRangeManagerCubit;
  final DateService _dateService;
  StreamSubscription<DateRangeManagerState>? _dateRangeManagerListener;

  MileageStatsBloc({
    required String userId,
    MileageStatsState initialState = const MileageStatsState(),
  })  : _userId = userId,
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateRangeManagerCubit = getIt<DateRangeManagerCubit>(),
        _dateService = getIt<DateService>(),
        super(initialState) {
    on<MileageStatsEventInitialize>(_initialize);
    on<MileageStatsEventChartDateRangeUpdated>(
      _chartDateRangeUpdated,
      transformer: restartable(),
    );
    on<MileageStatsEventChangeDateRangeType>(_changeDateRangeType);
    on<MileageStatsEventPreviousDateRange>(_previousDateRange);
    on<MileageStatsEventNextDateRange>(_nextDateRange);
  }

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    return super.close();
  }

  void _initialize(
    MileageStatsEventInitialize event,
    Emitter<MileageStatsState> emit,
  ) {
    _disposeChartDateRangeListener();
    _dateRangeManagerListener ??= _dateRangeManagerCubit.stream.listen(
      (DateRangeManagerState dateRangeManagerState) => add(
        MileageStatsEventChartDateRangeUpdated(
          dateRangeManagerState: dateRangeManagerState,
        ),
      ),
    );
    _dateRangeManagerCubit.initializeNewDateRangeType(DateRangeType.year);
  }

  Future<void> _chartDateRangeUpdated(
    MileageStatsEventChartDateRangeUpdated event,
    Emitter<MileageStatsState> emit,
  ) async {
    final DateRangeType dateRangeType =
        event.dateRangeManagerState.dateRangeType;
    final DateRange? dateRange = event.dateRangeManagerState.dateRange;
    if (dateRange == null || dateRangeType == DateRangeType.month) return;
    final Stream<_Activities> stream$ = Rx.combineLatest2(
      _workoutRepository.getWorkoutsByDateRange(
        startDate: dateRange.startDate,
        endDate: dateRange.endDate,
        userId: _userId,
      ),
      _raceRepository.getRacesByDateRange(
        startDate: dateRange.startDate,
        endDate: dateRange.endDate,
        userId: _userId,
      ),
      (List<Workout>? workouts, List<Race>? races) => _Activities(
        workouts: [...?workouts],
        races: [...?races],
      ),
    );
    await emit.forEach(
      stream$,
      onData: (_Activities activities) => state.copyWith(
        dateRangeType: dateRangeType,
        dateRange: dateRange,
        mileageChartPoints: dateRangeType == DateRangeType.week
            ? _createPointsForEachWeekDay(dateRange, activities)
            : _createPointsForEachMonth(dateRange.startDate.year, activities),
      ),
    );
  }

  void _changeDateRangeType(
    MileageStatsEventChangeDateRangeType event,
    Emitter<MileageStatsState> emit,
  ) {
    if (event.dateRangeType == DateRangeType.month) return;
    _dateRangeManagerCubit.initializeNewDateRangeType(event.dateRangeType);
  }

  void _previousDateRange(
    MileageStatsEventPreviousDateRange event,
    Emitter<MileageStatsState> emit,
  ) {
    _dateRangeManagerCubit.previousDateRange();
  }

  void _nextDateRange(
    MileageStatsEventNextDateRange event,
    Emitter<MileageStatsState> emit,
  ) {
    _dateRangeManagerCubit.nextDateRange();
  }

  List<MileageStatsChartPoint> _createPointsForEachWeekDay(
    DateRange dateRange,
    _Activities activities,
  ) =>
      List<MileageStatsChartPoint>.generate(
        7,
        (index) {
          final DateTime date = DateTime(
            dateRange.startDate.year,
            dateRange.startDate.month,
            dateRange.startDate.day + index,
          );
          final workoutsFromDay = activities.workouts.where(
            (Workout workout) =>
                _dateService.areDatesTheSame(workout.date, date),
          );
          final racesFromDay = activities.races.where(
            (Race race) => _dateService.areDatesTheSame(race.date, date),
          );
          final double workoutsCoveredDistance =
              _sumCoveredDistancesOfActivities(workoutsFromDay);
          final double racesCoveredDistance =
              _sumCoveredDistancesOfActivities(racesFromDay);
          return MileageStatsChartPoint(
            date: date,
            mileage: workoutsCoveredDistance + racesCoveredDistance,
          );
        },
      );

  List<MileageStatsChartPoint> _createPointsForEachMonth(
    final int year,
    final _Activities activities,
  ) =>
      List<MileageStatsChartPoint>.generate(
        12,
        (index) {
          final DateTime date = DateTime(year, 1 + index);
          final workoutsFromMonth = activities.workouts
              .where((Workout workout) => workout.date.month == date.month);
          final racesFromMonth = activities.races
              .where((Race race) => race.date.month == date.month);
          final double workoutsCoveredDistance =
              _sumCoveredDistancesOfActivities(workoutsFromMonth);
          final double racesCoveredDistance =
              _sumCoveredDistancesOfActivities(racesFromMonth);
          return MileageStatsChartPoint(
            date: date,
            mileage: workoutsCoveredDistance + racesCoveredDistance,
          );
        },
      );

  double _sumCoveredDistancesOfActivities(Iterable<Activity> activities) {
    if (activities.isEmpty) return 0.0;
    return activities
        .map(_getActivityCoveredDistance)
        .reduce((totalDistance, raceDistance) => totalDistance + raceDistance);
  }

  double _getActivityCoveredDistance(Activity activity) {
    final ActivityStatus status = activity.status;
    if (status is ActivityStatusWithParams) return status.coveredDistanceInKm;
    return 0.0;
  }

  void _disposeChartDateRangeListener() {
    _dateRangeManagerListener?.cancel();
    _dateRangeManagerListener = null;
  }
}

class _Activities extends Equatable {
  final List<Workout> workouts;
  final List<Race> races;

  const _Activities({required this.workouts, required this.races});

  @override
  List<Object?> get props => [workouts, races];
}
