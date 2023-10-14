import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/date_service.dart';
import '../../../data/additional_model/activity_status.dart';
import '../../../data/entity/activity.dart';
import '../../../data/entity/race.dart';
import '../../../data/entity/workout.dart';
import '../../../data/interface/repository/race_repository.dart';
import '../../../data/interface/repository/workout_repository.dart';
import '../../../dependency_injection.dart';
import '../../cubit/date_range_manager_cubit.dart';

part 'mileage_stats_state.dart';

class MileageStatsCubit extends Cubit<MileageStatsState> {
  final String _userId;
  final WorkoutRepository _workoutRepository;
  final RaceRepository _raceRepository;
  final DateRangeManagerCubit _dateRangeManagerCubit;
  final DateService _dateService;
  StreamSubscription<DateRangeManagerState>? _dateRangeManagerListener;
  StreamSubscription<_Activities>? _activitiesListener;

  MileageStatsCubit({
    required String userId,
    MileageStatsState initialState = const MileageStatsState(),
  })  : _userId = userId,
        _workoutRepository = getIt<WorkoutRepository>(),
        _raceRepository = getIt<RaceRepository>(),
        _dateRangeManagerCubit = getIt<DateRangeManagerCubit>(),
        _dateService = getIt<DateService>(),
        super(initialState);

  @override
  Future<void> close() {
    _disposeChartDateRangeListener();
    _disposeActivitiesListener();
    return super.close();
  }

  void initialize() {
    _disposeChartDateRangeListener();
    _dateRangeManagerListener ??=
        _dateRangeManagerCubit.stream.listen(_dateRangeUpdated);
    _dateRangeManagerCubit.initializeNewDateRangeType(DateRangeType.year);
  }

  void changeDateRangeType(DateRangeType dateRangeType) {
    if (dateRangeType == DateRangeType.month) return;
    _dateRangeManagerCubit.initializeNewDateRangeType(dateRangeType);
  }

  void previousDateRange() {
    _dateRangeManagerCubit.previousDateRange();
  }

  void nextDateRange() {
    _dateRangeManagerCubit.nextDateRange();
  }

  Future<void> refresh() async {
    final DateRange? dateRange = state.dateRange;
    if (dateRange == null) return;
    await _workoutRepository.refreshWorkoutsByDateRange(
      startDate: dateRange.startDate,
      endDate: dateRange.endDate,
      userId: _userId,
    );
    await _raceRepository.refreshRacesByDateRange(
      startDate: dateRange.startDate,
      endDate: dateRange.endDate,
      userId: _userId,
    );
  }

  void _dateRangeUpdated(DateRangeManagerState dateRangeManagerState) {
    final DateRangeType dateRangeType = dateRangeManagerState.dateRangeType;
    final DateRange? dateRange = dateRangeManagerState.dateRange;
    if (dateRange == null || dateRangeType == DateRangeType.month) return;
    _disposeActivitiesListener();
    _activitiesListener ??= Rx.combineLatest2(
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
    ).listen(
      (_Activities activities) => emit(state.copyWith(
        dateRangeType: dateRangeType,
        dateRange: dateRange,
        mileageChartPoints: dateRangeType == DateRangeType.week
            ? _createPointsForEachWeekDay(dateRange, activities)
            : _createPointsForEachMonth(dateRange.startDate.year, activities),
      )),
    );
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
                _dateService.areDaysTheSame(workout.date, date),
          );
          final racesFromDay = activities.races.where(
            (Race race) => _dateService.areDaysTheSame(race.date, date),
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

  void _disposeActivitiesListener() {
    _activitiesListener?.cancel();
    _activitiesListener = null;
  }
}

class _Activities extends Equatable {
  final List<Workout> workouts;
  final List<Race> races;

  const _Activities({required this.workouts, required this.races});

  @override
  List<Object?> get props => [workouts, races];
}
