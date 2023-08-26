import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/activity_status.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../cubit/chart_date_range_cubit.dart';
import '../../entity/activity.dart';
import '../../entity/race.dart';
import '../../entity/workout.dart';
import '../../repository/race_repository.dart';
import '../../repository/workout_repository.dart';
import '../../service/auth_service.dart';

part 'mileage_event.dart';
part 'mileage_state.dart';

class MileageBloc
    extends BlocWithStatus<MileageEvent, MileageState, dynamic, dynamic> {
  final AuthService _authService;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final ChartDateRangeCubit _chartDateRangeCubit;
  final DateService _dateService;
  StreamSubscription<ChartDateRangeState>? _chartDateRangeListener;

  MileageBloc({
    MileageState initialState = const MileageState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _chartDateRangeCubit = getIt<ChartDateRangeCubit>(),
        _dateService = getIt<DateService>(),
        super(initialState) {
    on<MileageEventInitialize>(_initialize);
    on<MileageEventChartDateRangeUpdated>(
      _chartDateRangeUpdated,
      transformer: restartable(),
    );
    on<MileageEventChangeDateRangeType>(_changeDateRangeType);
    on<MileageEventPreviousDateRange>(_previousDateRange);
    on<MileageEventNextDateRange>(_nextDateRange);
  }

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    return super.close();
  }

  void _initialize(
    MileageEventInitialize event,
    Emitter<MileageState> emit,
  ) {
    _disposeChartDateRangeListener();
    _chartDateRangeListener ??= _chartDateRangeCubit.stream.listen(
      (ChartDateRangeState chartDateRange) => add(
        MileageEventChartDateRangeUpdated(chartDateRange: chartDateRange),
      ),
    );
  }

  Future<void> _chartDateRangeUpdated(
    MileageEventChartDateRangeUpdated event,
    Emitter<MileageState> emit,
  ) async {
    final DateRangeType dateRangeType = event.chartDateRange.dateRangeType;
    final DateRange? dateRange = event.chartDateRange.dateRange;
    if (dateRange == null || dateRangeType == DateRangeType.month) return;
    final Stream<_Activities> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _workoutRepository.getWorkoutsByDateRange(
                  startDate: dateRange.startDate,
                  endDate: dateRange.endDate,
                  userId: loggedUserId,
                ),
                _raceRepository.getRacesByDateRange(
                  startDate: dateRange.startDate,
                  endDate: dateRange.endDate,
                  userId: loggedUserId,
                ),
                (List<Workout>? workouts, List<Race>? races) => _Activities(
                  workouts: [...?workouts],
                  races: [...?races],
                ),
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
    MileageEventChangeDateRangeType event,
    Emitter<MileageState> emit,
  ) {
    if (event.dateRangeType == DateRangeType.month) return;
    _chartDateRangeCubit.initializeNewDateRangeType(event.dateRangeType);
  }

  void _previousDateRange(
    MileageEventPreviousDateRange event,
    Emitter<MileageState> emit,
  ) {
    _chartDateRangeCubit.previousDateRange();
  }

  void _nextDateRange(
    MileageEventNextDateRange event,
    Emitter<MileageState> emit,
  ) {
    _chartDateRangeCubit.nextDateRange();
  }

  List<MileageChartPoint> _createPointsForEachWeekDay(
    DateRange dateRange,
    _Activities activities,
  ) =>
      List<MileageChartPoint>.generate(
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
          return MileageChartPoint(
            date: date,
            mileage: workoutsCoveredDistance + racesCoveredDistance,
          );
        },
      );

  List<MileageChartPoint> _createPointsForEachMonth(
    final int year,
    final _Activities activities,
  ) =>
      List<MileageChartPoint>.generate(
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
          return MileageChartPoint(
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
    _chartDateRangeListener?.cancel();
    _chartDateRangeListener = null;
  }
}

class _Activities extends Equatable {
  final List<Workout> workouts;
  final List<Race> races;

  const _Activities({required this.workouts, required this.races});

  @override
  List<Object?> get props => [workouts, races];
}
